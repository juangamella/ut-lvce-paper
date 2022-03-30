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
import sempler
import sempler.generators
import multiprocessing
import traceback
import gc
import ut_lvcm.main
import ut_lvcm.utils as utils
import ut_lvcm.experiments as experiments
import ut_lvcm.metrics as metrics

# --------------------------------------------------------------------
# Parse input parameters


# Definitions and default settings
arguments = {
    # Execution parameters
    'n_workers': {'default': 1, 'type': int},
    # 'batch_size': {'default': 20000, 'type': int},
    'seed': {'default': 42, 'type': int},
    'tag': {'type': str},
    'debug': {'default': False, 'type': bool},
    'chunksize': {'type': int, 'default': 1},
    'disc': {'default': 15, 'type': int},
    'runs': {'default': 1, 'type': int},
    # SCM generation parameters
    'no_edges': {'default': 5, 'type': int},
    'G': {'default': 1, 'type': int},
    'k': {'default': 2.1, 'type': float},
    'p': {'default': 20, 'type': int},
    'w_lo': {'default': 0.6, 'type': float},
    'w_hi': {'default': 0.8, 'type': float},
    'v_lo': {'default': 0.5, 'type': float},
    'v_hi': {'default': 0.6, 'type': float},
    'i_v_lo': {'default': 5, 'type': float},
    'i_v_hi': {'default': 10, 'type': float},
    'psi_lo': {'default': 0.1, 'type': float},
    'psi_hi': {'default': 0.2, 'type': float},
    'i_psi_lo': {'default': 0, 'type': float},
    'i_psi_hi': {'default': 0, 'type': float},
    'h': {'default': 2, 'type': int},
    'e': {'default': 5, 'type': int},
    'size_I': {'default': 3, 'type': int},
    # Estimator settings
    'psi_fixed': {'default': False, 'type': bool},
    'init': {'default': 0, 'type': int},
    # If we should skip the graph pruning phase
    'np': {'default': False, 'type': bool},
    'th': {'default': None, 'type': float},
    'hist': {'default': 1, 'type': int},
    # Force the estimator to run with a particular h
    'fh': {'default': None, 'type': int},
    # Sampling parameters
    'n': {'default': 1000, 'type': int},
    #  GES parameters
    # If GES should run without a backward phase
    'gb': {'default': False, 'type': bool},
    # If GES should run with multiple penalizations
    'gp': {'default': False, 'type': bool}
    #  TODO: fill these
}

# Parse settings from input
parser = argparse.ArgumentParser(description='Run experiments')
for name, params in arguments.items():
    if params['type'] == bool:
        options = {'action': 'store_true'}
    else:
        options = {'action': 'store', 'type': params['type']}
    if 'default' in params:
        options['default'] = params['default']
    parser.add_argument("--" + name,
                        dest=name,
                        required=False,
                        **options)

args = parser.parse_args()

# Parameters that will be excluded from the filename (see parameter_string function above)
excluded_keys = ['debug', 'n_workers', 'chunksize', 'hist']  # , 'batch_size']
excluded_keys += ['tag'] if args.tag is None else []
excluded_keys += ['gp'] if args.gp == 0 else []
excluded_keys += ['gb'] if args.gp == 0 else []
excluded_keys += ['fh'] if args.gp is None else []
excluded_keys += ['th'] if args.th is None else []
excluded_keys += ['psi_fixed'] if not args.psi_fixed else []


print(args)  # For debugging

# Set random seed
rng = np.random.default_rng(args.seed)

# --------------------------------------------------------------------
# Generate test cases
#   A test case is an SCM and a set of interventions

if args.G == -1:
    print("Generating a chain graph with p=%d" % args.p)
    if args.init == 7:
        # Constraining choice so true I-MEC is not a singleton unless necessary
        choice = range(max(0, args.p - args.size_I - 3), args.p)
        true_I = set(rng.choice(choice, size=args.size_I, replace=False))
    else:
        true_I = set(sempler.generators.intervention_targets(
            args.p, 1, args.size_I, random_state=args.seed)[0])
    print("  Graph 1 - I = %s" % (true_I))
    model = experiments.chain_graph(args.p,
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
                                    random_state=args.seed,
                                    verbose=False)
    test_cases = [(model, true_I)]
else:
    print("Generating test cases (pre-screening for large MECs : %s)" % args.disc)
    test_cases = []  # list of (true_model, true_I)
    i = 0
    seed = rng.integers(0, int(1e6))
    As = []  # To ensure we don't generate duplicate models
    while len(test_cases) < args.G:
        print(".", end="")
        seed += 1
        # Sample intervention targets
        true_I = set(sempler.generators.intervention_targets(
            args.p, 1, args.size_I, random_state=seed)[0])
        print("  Graph %d - I = %s" % (i, true_I)) if args.debug else None
        # Build model
        model = experiments.sample_model(args.p,
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
                                         random_state=seed, verbose=False)
        # Sample data
        max_degree = utils.degrees(utils.moral_graph(model.A)).max()
        # If we've already generated this graph, discard it
        if len(As) > 0 and (model.A == As).all(axis=(1, 2)).any():
            print("    Duplicate") if args.debug else None
            continue
        elif max_degree > np.ceil(args.p / 6):
            print("    Max-degree of moral graph is %d > p / 6 = %s" %
                  (max_degree, args.p / 6)) if args.debug else None
            continue
        elif np.sum(model.A) < .8 * args.p or np.sum(model.A) > 1.5 * args.p:
            print("    Too few or too many edges (%d)" %
                  np.sum(model.A)) if args.debug else None
        # elif args.disc and args.init == 0:
        #     X, _, _ = model.sample(args.n, random_state=args.seed)
        #     cpdag = ut_lvcm.ges.fit(X, verbose=1)
        #     print("    Enumerating all DAGs...", end="") if args.debug else None
        #     start = time.time()
        #     initial_graphs =
        #     print(" (%d) done (%0.2f seconds)" %
        #           (len(initial_graphs), time.time() - start)) if args.debug else None
        #     # Save
        #     if len(initial_graphs) > args.disc:
        #         print("    Discarded as GES MEC is larger (%d) than %d" %
        #               (len(initial_graphs), args.disc)) if args.debug else None
        #     else:
        #         print("    Accepted")
        #         i += 1
        #         As.append(model.A)
        #         test_cases.append((model, true_I))
        elif args.disc and args.init in [0, 1, 3, 4]:
            mec = utils.mec(model.A)
            if len(mec) > args.disc:
                print("    Discarded as true MEC is larger (%d) than %d" %
                      (len(mec), args.disc)) if args.debug else None
            else:
                print("    Accepted")
                # Compute true MEC and I-MEC
                true_mec = utils.mec(model.A)
                true_imec = utils.imec(model.A, true_I)
                print("|MEC| =", len(true_mec), "|I-MEC| =", len(true_imec))
                i += 1
                As.append(model.A)
                test_cases.append((model, true_I))
        else:
            print("    Accepted")
            i += 1
            As.append(model.A)
            test_cases.append((model, true_I))

print(" done.")

# Check that we generated different graphs
if args.G == -1:
    assert len(test_cases) == 1
else:
    assert len(
        np.unique([model.A for model, _ in test_cases], axis=0)) == args.G

# --------------------------------------------------------------------
# Experiments

# UT-LVCM parameters
hs = [1, 2, 3] if args.fh is None else [args.fh]
psi_max = None  # args.psi_max * 1.5
max_iter = 1000
threshold_dist_B = 1e-3
threshold_fluctuation = 1e-5
max_fluctuations = 5
threshold_score = 1e-5
learning_rate = 1
B_solver = 'grad'
run_metrics = [metrics.type_1_struct, metrics.type_2_struct,
               metrics.type_1_I, metrics.type_2_I]
threshold_graph = args.th
threshold_I = args.th
ges_lambdas = None
ges_phases = None


def run_test_case(test_case, seed):
    true_model, true_I = test_case
    print("No. edges in true model", np.sum(true_model.A))

    # Choose how which initial graphs to use
    #   0 - GES
    #   1 - true graph
    #   2 - true graph + random edges
    #   3 - MEC of true graph
    #   4 - MEC of true graph + random edges
    #   5 - I-MEC of true graph
    ges_phases, ges_lambdas = None, None
    if args.init == 0:  # 0 - GES
        ges_lambdas = [2, 4, 8] if args.gp else None
        ges_phases = ['forward', 'turning'] if args.gb else None
        initial_graphs = None
    elif args.init == 1:  # 1 - true graph
        initial_graphs = np.array([true_model.A])
    elif args.init == 2:  # 2 - true graph + random edges
        supergraph = utils.add_edges(true_model.A, args.no_edges, args.seed)
        initial_graphs = np.array([supergraph])
    elif args.init == 3:  # 3 - MEC of true graph
        initial_graphs = utils.mec(true_model.A)
    elif args.init == 4:  # 4 - MEC of true graph + random edges
        # supergraph = utils.add_edges(true_model.A, args.no_edges, random_state=args.seed)
        # initial_graphs = utils.mec(supergraph)
        mec = utils.mec(true_model.A)
        # Add random edges to each graph
        initial_graphs = [utils.add_edges(A, args.no_edges, random_state=i)
                          for (i, A) in enumerate(mec)]
        true_imec = utils.all_dags(utils.dag_to_icpdag(true_model.A, true_I))
        t1 = metrics.type_1_structc(initial_graphs, true_imec)
        t2 = metrics.type_2_structc(initial_graphs, true_imec)
        print("Metrics for initial graphs:", t1, t2)
        initial_graphs = np.array(initial_graphs)
    elif args.init == 5:  # 5 - I-MEC of true graph
        initial_graphs = utils.imec(true_model.A, true_I)
    elif args.init == 6:  # 6 - I-MEC of true graph + random edges
        imec = utils.imec(true_model.A, true_I)
        # Add random edges to each graph
        initial_graphs = [utils.add_edges(A, args.no_edges, random_state=i)
                          for (i, A) in enumerate(imec)]
        initial_graphs = np.array(initial_graphs)
    # 7 - MEC(true graph + random edges), ensuring initial type-II error > 0
    elif args.init == 7:
        i = 0
        threshold = 0.15
        t2 = 0
        true_icpdag = utils.dag_to_icpdag(true_model.A, true_I)
        true_imec = utils.all_dags(true_icpdag)
        print("Searching initial supergraph with type-II > %0.2f... len(true I-MEC) = %d" %
              (threshold, len(true_imec)))
        while t2 < threshold:
            supergraph = utils.add_edges(
                true_model.A, args.no_edges, random_state=args.seed + i)
            i += 1
            initial_graphs = utils.mec(supergraph)
            t2 = metrics.type_2_structc(initial_graphs, true_imec)
            print(i, " %0.2f " % t2, end="")

        t1 = metrics.type_1_structc(initial_graphs, true_imec)
        t2 = metrics.type_2_structc(initial_graphs, true_imec)
        print("\n|I-MEC*|=%d, |initial_graphs|=%d - Metrics for initial graphs: (%0.3f, %0.3f)" %
              (len(true_imec), len(initial_graphs), t1, t2))

    # Generate a sample
    data, _, _ = true_model.sample(args.n, random_state=seed)
    cond_numbers = [np.linalg.cond(np.cov(X, rowvar=False)) for X in data]
    print("Condition number of covariance matrices:", cond_numbers)
    start = time.time()

    print("Starting fit with init=%s" % args.init)
    # Run cross-validation procedure
    result = ut_lvcm.main.fit(data,
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
                              prune_I_method='rank',
                              initial_graphs=initial_graphs,
                              B_solver=B_solver,
                              score_verbose=3,
                              prune_graph=not args.np,
                              threshold_graph=threshold_graph,
                              threshold_I=threshold_I,
                              store_history=args.hist,
                              ges_phases=ges_phases,
                              ges_lambdas=ges_lambdas,
                              )
    elapsed = time.time() - start
    print("  Ran full procedure in %0.2f seconds" % elapsed)
    (best_model, best_I, best_test_score), history = result

    # Apply metrics
    start = time.time()
    print("  Running metrics")
    all_metrics = [(m, m((best_model.A, best_I), (true_model.A, true_I)))
                   for m in run_metrics]
    print("  Done (%0.2f seconds)" % (time.time() - start))
    return (best_model, best_I, best_test_score), history, all_metrics, elapsed


n_workers = os.cpu_count() - 1 if args.n_workers == -1 else args.n_workers


# Construct worker function and callbacks

def worker(info):
    idx, test_case, filename = info
    # Attempt execution
    try:
        result = run_test_case(test_case, idx)
    except Exception as e:
        trace = traceback.format_exc()
        print("ERROR:", trace)
        result = (e, trace)
    # Save result
    with open(filename, 'wb') as f:
        pickle.dump((idx, test_case, result), f)
    del result
    gc.collect()
    return idx


directory = "baseline_experiments/results_%d_%s/" % (time.time(),
                                                     experiments.parameter_string(args, excluded_keys))
os.makedirs(directory)

# Store test cases
filename = directory + "test_cases.pickle"
with open(filename, 'wb') as f:
    pickle.dump((args, test_cases), f)
print('Stored test cases in "%s"' % filename)

# Construct iterable for worker pool
iterable = []
test_cases = test_cases * args.runs
for i, test_case in enumerate(test_cases):
    item = (i, test_case, directory + "test_case_%d.pickle" % i)
    iterable.append(item)


# Run experiments


print("\n\nBeginning experiments with %d workers on %d cases at %s\n\n" %
      (n_workers, len(iterable), datetime.now()))
start = time.time()
if n_workers == 1:
    for item in iterable:
        worker(item)
else:
    with multiprocessing.Pool(n_workers) as pool:
        pool.map(worker, iterable)
end = time.time()
print("\n\nFinished experiments at %s (elapsed %0.2f seconds)" %
      (datetime.now(), end - start))

# --------------------------------------------------------------------
# Process results

experiments.compile_results(directory)
