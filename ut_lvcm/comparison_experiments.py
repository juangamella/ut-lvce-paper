# Copyright 2022 Juan L. Gamella

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:

# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.

# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.

# 3. Neither the name of the copyright holder nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

"""
"""

# TODO
# - Random seed management
# - Verbosity

import pickle
import time
from datetime import datetime
import argparse
import os
import numpy as np
import pandas as pd
import multiprocessing
import gc
import ut_lvcm.main
import ut_lvcm.utils as utils
import ut_lvcm.experiments as experiments
import ut_lvcm.metrics as metrics

# --------------------------------------------------------------------
# Auxiliary functions
if __name__ != "__main__":
    msg = "comparison_experiments.py should be run as a python script, e.g.\npython -m ut_lvce.comparison_experiments <args>."
    raise Exception(msg)

# --------------------------------------------------------------------
# Auxiliary functions


def recover_parents(i, A, I):
    """Return the parents of I for each graph in the corresponding
    I-MEC."""
    imec = utils.imec(A, I)
    results = []
    for A in imec:
        results.append(set(utils.pa(i, A)))
    results = list(np.unique(results))
    return results


# --------------------------------------------------------------------
# Parse input parameters


# Definitions and default settings
arguments = {
    # Execution parameters
    "n_workers": {"default": 1, "type": int},
    # If experiments are running on the euler cluster and results should be stored in the scratch directory
    "cluster": {"default": False, "type": bool},
    # 'batch_size': {'default': 20000, 'type': int},
    "seed": {"default": 42, "type": int},
    "tag": {"type": str},
    "debug": {"default": False, "type": bool},
    "chunksize": {"type": int, "default": 1},
    "disc": {"default": 15, "type": int},
    "runs": {"default": 1, "type": int},
    # Which methods to run: u - ut-lvce, b - backshift, i - hidden ICP/causal dantzig, l - LRPS+GES
    "m": {"default": "ubil", "type": str},
    # If method output files should be kept after execution (default - No)
    "save": {"default": False, "type": bool},
    # SCM generation parameters
    "min_parents": {"default": 2, "type": int},
    "G": {"default": 1, "type": int},
    "k": {"default": 1.5, "type": float},
    "p": {"default": 20, "type": int},
    "w_lo": {"default": 0.6, "type": float},
    "w_hi": {"default": 0.8, "type": float},
    "v_lo": {"default": 0.5, "type": float},
    "v_hi": {"default": 0.6, "type": float},
    "i_v_lo": {"default": 6, "type": float},
    "i_v_hi": {"default": 12, "type": float},
    "psi_lo": {"default": 0.2, "type": float},
    "psi_hi": {"default": 0.3, "type": float},
    "i_psi_lo": {"default": 0, "type": float},
    "i_psi_hi": {"default": 0, "type": float},
    "h": {"default": 2, "type": int},
    "e": {"default": 5, "type": int},
    "size_I": {"default": 10, "type": int},
    "it": {"default": False, "type": bool},
    "sl": {"default": False, "type": bool},
    # UT-LVCE settings
    "psi_fixed": {"default": False, "type": bool},
    "th": {"default": None, "type": float},
    "hist": {"default": 1, "type": int},
    "Hs": {"default": "1,2,3", "type": str},
    # Sampling parameters
    "n": {"default": 1000, "type": int},
    #  UT-LVCM parameters
    #  TODO: fill these
}

# Parse settings from input
parser = argparse.ArgumentParser(description="Run experiments")
for name, params in arguments.items():
    if params["type"] == bool:
        options = {"action": "store_true"}
    else:
        options = {"action": "store", "type": params["type"]}
    if "default" in params:
        options["default"] = params["default"]
    parser.add_argument("--" + name, dest=name, required=False, **options)

args = parser.parse_args()

# Parameters that will be excluded from the filename (see parameter_string function above)
excluded_keys = ["debug", "n_workers", "chunksize", "save", "hist"]
excluded_keys += ["tag"] if args.tag is None else []
excluded_keys += ["th"] if args.th is None else []
excluded_keys += ["psi_fixed"] if not args.psi_fixed else []

print(args)  # For debugging

print("Visible workers: %d vs. args.n_workers %d" % (os.cpu_count(), args.n_workers))


# Set random seed
rng = np.random.default_rng(args.seed)

# --------------------------------------------------------------------
# Generate test cases
#   A test case is an SCM and a set of interventions

DEFAULT_TARGET = 0

print("Generating test cases (pre-screening for large MECs : %s)" % args.disc)
test_cases = []  # list of (true_model, true_I)
i = 0
seed = 0
As = []  # To ensure we don't generate duplicate models
while len(test_cases) < args.G:
    print(".", end="")
    seed += 1
    # Sample intervention targets (respecting intervention on targets flag "it")
    rng = np.random.default_rng(seed)
    possible_targets = utils.all_but([DEFAULT_TARGET], args.p)
    if args.it:
        size_I = min(args.size_I, args.p)
        true_I = set(rng.choice(possible_targets, size=size_I - 1, replace=False)) | {
            DEFAULT_TARGET
        }
    else:
        size_I = min(args.size_I, args.p - 1)
        true_I = set(rng.choice(possible_targets, size=size_I, replace=False))
    # Build model
    model = experiments.sample_model(
        args.p,
        args.k,
        true_I,
        args.h,
        args.e,
        args.v_lo,
        args.v_hi,
        args.i_v_lo,
        args.i_v_hi,
        args.psi_lo,
        args.psi_hi,
        args.i_psi_lo,
        args.i_psi_hi,
        args.w_lo,
        args.w_hi,
        obs=True,
        sparse_latents=args.sl,
        random_state=seed,
        verbose=False,
    )
    # Check whether the model is valid
    max_degree = utils.degrees(utils.moral_graph(model.A)).max()
    # If we've already generated this graph, discard it
    if len(As) > 0 and (model.A == As).all(axis=(1, 2)).any():
        print("    Duplicate") if args.debug else None
        continue
    # Limit on max degree of moral graph
    elif max_degree > np.ceil(args.p / 6):
        print(
            "    Max-degree of moral graph is %d > p / 6 = %s"
            % (max_degree, args.p / 6)
        ) if args.debug else None
        continue
    # The target should have at least args.min_parents parents
    elif len(utils.pa(DEFAULT_TARGET, model.A)) < args.min_parents:
        print(
            "    Target (%d) has too few parents (%d)."
            % (DEFAULT_TARGET, len(utils.pa(DEFAULT_TARGET, model.A)))
        ) if args.debug else None
    # If given, discard graphs with large MECs
    elif args.disc:
        true_mec = utils.mec(model.A)
        if len(true_mec) > args.disc:
            print(
                "    Discarded as true MEC is larger (%d) than %d"
                % (len(true_mec), args.disc)
            ) if args.debug else None
        # Accept
        else:
            print(
                "    \nAccepted - parents = %s - I = %s"
                % (utils.pa(DEFAULT_TARGET, model.A), true_I)
            )
            print(model.gamma)
            print(model.psis)
            # Display size of MEC and I-MEC
            true_imec = utils.imec(model.A, true_I)
            print("|MEC| =", len(true_mec), "|I-MEC| =", len(true_imec))
            i += 1
            As.append(model.A)
            test_cases.append((model, true_I))
    # Accept
    else:
        print(
            "    \nAccepted - parents = %s - I = %s"
            % (utils.pa(DEFAULT_TARGET, model.A), true_I)
        )
        print(model.gamma)
        print(model.psis)
        i += 1
        As.append(model.A)
        test_cases.append((model, true_I))

print(" done.")

# Check that we generated different graphs
assert len(np.unique([model.A for model, _ in test_cases], axis=0)) == args.G

# --------------------------------------------------------------------
# Generate data for each test case

directory = "comparison_experiments/results_%d_%s/" % (
    time.time(),
    experiments.parameter_string(args, excluded_keys),
)

# If running on the Euler cluster, store results in the scratch directory
if args.cluster:
    directory = "/cluster/scratch/gajuan/" + directory

os.makedirs(directory)
print('Storing results in "%s"' % directory)

# Sample data for each test case and store it in binary and csv
# formats for all the algorithms to read
start = time.time()
test_cases = test_cases * args.runs
for seed, (true_model, true_I) in enumerate(test_cases):
    data, _, _ = true_model.sample(args.n, random_state=seed)
    # Store data
    filename = directory + "test_case_%d_data" % seed
    # For backshift and hidden-ICP
    if "b" in args.m or "i" in args.m:
        experiments.data_to_csv(data, filename, debug=False)
    # For UT-LVCE
    if "u" in args.m:
        experiments.data_to_bin(data, filename, debug=False)
    # For LRPS+GES
    if "l" in args.m:
        filename = directory + "test_case_%d_pooled_data" % seed
        experiments.pooled_data_to_csv(data, filename, debug=False, normalize=True)
print(
    "Generated samples for %d test cases (%0.2f seconds)"
    % (len(test_cases), time.time() - start)
)

# Remove from memory as will be read from disk independently by each
# worker, reducing overhead
del data
gc.collect()

# --------------------------------------------------------------------
# Functions for the different methods

# UT-LVCE

hs = [int(h) for h in args.Hs.split(",")]
psi_max = None
max_iter = 1000
threshold_dist_B = 1e-3
threshold_fluctuation = 1e-5
max_fluctuations = 5
threshold_score = 1e-5
learning_rate = 1
B_solver = "grad"
threshold_graph = args.th
threshold_I = args.th


def run_ut_lvce(case_id, debug=False):
    # Read test case data
    filename = directory + "test_case_%d_data.npy" % case_id
    data = np.load(filename)
    start = time.time()
    # Run UT-LVCE
    result = ut_lvcm.main.fit(
        data,
        psi_max,
        args.psi_fixed,
        max_iter,
        threshold_dist_B,
        threshold_fluctuation,
        max_fluctuations,
        threshold_score,
        learning_rate,
        nums_latent=hs,
        verbose=args.debug,
        prune_I_method="rank",
        initial_graphs=None,
        B_solver=B_solver,
        score_verbose=3,
        threshold_graph=threshold_graph,
        threshold_I=threshold_I,
        store_history=args.hist,
        prune_graph=True,
    )
    elapsed = time.time() - start
    # Recover parents
    (estimated_model, estimated_I, _), _ = result
    result += (elapsed,)
    estimated_parents = recover_parents(DEFAULT_TARGET, estimated_model.A, estimated_I)
    print("  Ran UT-LVCE on test case %d in  %0.2f seconds." % (case_id, elapsed))
    filename = directory + "ut_lvce_result_%d.csv" % case_id
    with open(filename, "wb") as f:
        pickle.dump((estimated_parents, result), f)
    return estimated_parents, result


# Causal Dantzig


def run_causal_dantzig(debug=False):
    CMD = "Rscript ut_lvcm/run_hidden_icp.R %d %s %d" % (
        len(test_cases),
        directory,
        debug,
    )
    start = time.time()
    os.system(CMD)
    print("######################################################################")
    print(
        "  Ran Causal Dantzig (HiddenICP) on all cases in  %0.2f seconds."
        % (time.time() - start)
    )


def process_causal_dantzig_results(debug=True):
    print("Processing Causal Dantzig (HiddenICP) results:") if debug else None
    results = []
    for i in range(len(test_cases)):
        filename = directory + "hicp_result_%d.csv" % i
        print('  "hicp_result_%d.csv"' % i) if debug else None
        one_hot = pd.read_csv(filename).to_numpy()[0, 1:]
        os.remove(filename) if not args.save else None
        assert DEFAULT_TARGET == 0
        # NOTE!!: This only works because DEFAULT_TARGET is 0
        estimated_parents = set(np.where(one_hot != 0)[0] + 1)
        results.append([estimated_parents])
    return results


# Backshift


def run_backshift(case_id, debug=False):
    CMD = "Rscript ut_lvcm/run_backshift.R %d %s %d" % (case_id, directory, debug)
    start = time.time()
    os.system(CMD)
    print(
        "  Ran Backshift on test case %d in  %0.2f seconds."
        % (case_id, time.time() - start)
    )


def process_backshift_results(debug=True):
    print("Processing Backshift results:") if debug else None
    parents, graphs = [], []
    for i in range(len(test_cases)):
        filename = directory + "backshift_result_%d.csv" % i
        print('  "backshift_result_%d.csv"' % i) if debug else None
        estimated_graph = pd.read_csv(filename).to_numpy()[:, 1:]
        os.remove(filename) if not args.save else None
        estimated_parents = set(np.where(estimated_graph[:, DEFAULT_TARGET] != 0)[0])
        print(estimated_graph) if debug else None
        print(estimated_parents) if debug else None
        parents.append([estimated_parents])
        graphs.append(estimated_graph)
    return parents, graphs


# LRPS-ADMM


def run_lrps(case_id, debug=False):
    CMD = "Rscript ut_lvcm/run_lrps.R %d %s %d" % (case_id, directory, debug)
    start = time.time()
    os.system(CMD)
    print(
        "  Ran LRPS-ADMM on test case %d in  %0.2f seconds."
        % (case_id, time.time() - start)
    )


def process_lrps_results(debug=True):
    print("Processing LRPS-ADMM results:") if debug else None
    parents, graphs = [], []
    for i in range(len(test_cases)):
        filename = directory + "lrps_result_%d.csv" % i
        print('  "lrps_result_%d.csv"' % i) if debug else None
        estimated_graph = pd.read_csv(filename).to_numpy()[:, 1:]
        os.remove(filename) if not args.save else None
        estimated_parents = []
        for A in utils.all_dags(estimated_graph):
            estimated_parents.append(utils.pa(DEFAULT_TARGET, A))
        estimated_parents = list(np.unique(estimated_parents))
        print(estimated_graph) if debug else None
        print(estimated_parents) if debug else None
        parents.append(estimated_parents)
        graphs.append(estimated_graph)
    return parents, graphs


# Ground truth


def run_truth(case_id, debug=True):
    true_model, true_I = test_cases[case_id]
    start = time.time()
    results = recover_parents(DEFAULT_TARGET, true_model.A, true_I)
    print("  Ground truth:", results)
    print(
        "  Recovered ground truth for test case %d in %0.2f seconds"
        % (case_id, time.time() - start)
    ) if debug else None
    return results


# --------------------------------------------------------------------
# Code to actually run the experiments

# Construct worker function and callbacks


def worker_backshift(case_id):
    # Run backshift (results are processed later)
    run_backshift(case_id)


def worker_lrps(case_id):
    # Run LRPS-ADMM (results are processed later)
    run_lrps(case_id)


def worker_ut_lvce(case_id):
    # Run UT-LVCE and store result
    result = run_ut_lvce(case_id)
    gc.collect()
    return result


# Run experiments


def run_experiments(iterable, map_function):
    # Ground truth
    start = time.time()
    ground_truth = map_function(run_truth, iterable)
    print("######################################################################")
    print(
        "  Computed ground truth for all cases in %0.2f seconds" % (time.time() - start)
    )
    results_ut_lvce = None
    # Backshift
    if "b" in args.m:
        start = time.time()
        map_function(worker_backshift, iterable)
        print("######################################################################")
        print("  Ran backshift for all cases in %0.2f seconds" % (time.time() - start))
    # LRPS-ADMM
    if "l" in args.m:
        start = time.time()
        map_function(worker_lrps, iterable)
        print("######################################################################")
        print("  Ran LRPS-ADMM for all cases in %0.2f seconds" % (time.time() - start))
    if "u" in args.m:
        # UT-LVCE
        start = time.time()
        results_ut_lvce = map_function(worker_ut_lvce, iterable)
        print("######################################################################")
        print("  Ran UT-LVCE for all cases in %0.2f seconds" % (time.time() - start))
    return results_ut_lvce, ground_truth


n_workers = os.cpu_count() - 1 if args.n_workers == -1 else args.n_workers
print(
    "\n\nBeginning experiments with %d workers on %d cases at %s\n\n"
    % (n_workers, len(test_cases), datetime.now())
)
start = time.time()


# First run Causal Dantzig on all available cores
if "i" in args.m:
    run_causal_dantzig()

# Then run backShift + ut_lvce on each test case, using as many
# threads as are available
iterable = range(len(test_cases))

# Run the remaining methods
if n_workers == 1:
    # Without multiprocessing, i.e. map function runs sequentially
    print("Running experiments sequentially")

    def map_function(worker, iterable):
        return list(map(worker, iterable))

    results_ut_lvce, ground_truth = run_experiments(iterable, map_function)
else:
    # Or in parallel on a pool of n_workers
    print("Running experiments in parallel")
    with multiprocessing.Pool(n_workers) as pool:
        results_ut_lvce, ground_truth = run_experiments(iterable, pool.map)

end = time.time()
print(
    "\n\nFinished experiments at %s (elapsed %0.2f seconds)\n\n"
    % (datetime.now(), end - start)
)

# --------------------------------------------------------------------
# Process results

results = {"truth": ground_truth}

# Extract estimates

# Causal Dantzig / Hidden ICP
if "i" in args.m:
    estimates_causal_dantzig = process_causal_dantzig_results(debug=False)
    t1_causal_dantzig = [
        metrics.type_1_parents(est, truth)
        for est, truth in zip(estimates_causal_dantzig, ground_truth)
    ]
    t2_causal_dantzig = [
        metrics.type_2_parents(est, truth)
        for est, truth in zip(estimates_causal_dantzig, ground_truth)
    ]
    results["estimates_causal_dantzig"] = estimates_causal_dantzig
    results["t1_causal_dantzig"] = t1_causal_dantzig
    results["t2_causal_dantzig"] = t2_causal_dantzig

# Backshift
if "b" in args.m:
    estimates_backshift, graphs_backshift = process_backshift_results(debug=False)
    t1_backshift = [
        metrics.type_1_parents(est, truth)
        for est, truth in zip(estimates_backshift, ground_truth)
    ]
    t2_backshift = [
        metrics.type_2_parents(est, truth)
        for est, truth in zip(estimates_backshift, ground_truth)
    ]
    results["estimates_backshift"] = estimates_backshift
    results["graphs_backshift"] = graphs_backshift
    results["t1_backshift"] = t1_backshift
    results["t2_backshift"] = t2_backshift

# LRPS+GES
if "l" in args.m:
    estimates_lrps, graphs_lrps = process_lrps_results(debug=True)
    t1_lrps = [
        metrics.type_1_parents(est, truth)
        for est, truth in zip(estimates_lrps, ground_truth)
    ]
    t2_lrps = [
        metrics.type_2_parents(est, truth)
        for est, truth in zip(estimates_lrps, ground_truth)
    ]
    results["estimates_lrps"] = estimates_lrps
    results["graphs_lrps"] = graphs_lrps
    results["t1_lrps"] = t1_lrps
    results["t2_lrps"] = t2_lrps

# UT-LVCE
if "u" in args.m:
    estimates_ut_lvce = [r[0] for r in results_ut_lvce]
    t1_ut_lvce = [
        metrics.type_1_parents(est, truth)
        for est, truth in zip(estimates_ut_lvce, ground_truth)
    ]
    t2_ut_lvce = [
        metrics.type_2_parents(est, truth)
        for est, truth in zip(estimates_ut_lvce, ground_truth)
    ]
    results["estimates_ut_lvce"] = estimates_ut_lvce
    results["t1_ut_lvce"] = t1_ut_lvce
    results["t2_ut_lvce"] = t2_ut_lvce
    results["ut_lvce_output"] = [r[1] for r in results_ut_lvce]

# Save arguments, test cases and compiled results
filename = directory + "compiled_results.pickle"
with open(filename, "wb") as f:
    pickle.dump((args, test_cases, results), f)
    print('\nWrote compiled results to "%s"' % filename)
