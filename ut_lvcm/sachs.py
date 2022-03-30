# Copyright 2020 Juan Luis Gamella Martin

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

import numpy as np
import pandas as pd
import ut_lvcm.utils as utils
import ut_lvcm.main as main
import time
from datetime import datetime
import pickle

# --------------------------------------------------------------------
# DAGs

DATA_PATH = "scratch/sachs/"
PATH = "sachs_experiments/"

filenames = ["b2camp.csv", "cd3cd28+aktinhib.csv", "cd3cd28+g0076.csv",
             "cd3cd28+ly.csv", "cd3cd28+psitect.csv", "cd3cd28+u0126.csv", "cd3cd28.csv", "pma.csv"]


# nodes_vars = {"RAF": "praf",
#               "MEK": "pmek",
#               "ERK": "p44/42",
#               "PLcg": "plcg",
#               "PIP2": "PIP2",
#               "PIP3": "PIP3",
#               "PKC": "PKC",
#               "AKT": "pakts473",
#               "PKA": "PKA",
#               "JNK": "pjnk",
#               "P38": "P38"}

node_names = ["RAF", "MEK", "ERK", "PLcg", "PIP2",
              "PIP3", "PKC", "AKT", "PKA", "JNK", "P38"]
var_names = ["praf", "pmek", "p44/42", "plcg", "PIP2",
             "PIP3", "PKC", "pakts473", "PKA", "pjnk", "P38"]

nodes_vars = dict(zip(node_names, var_names))

cpdag_icp = np.array(
    [[0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
     [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
     [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
     [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0],
     [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
     [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0],
     [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
     [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
     [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
     [0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1],
     [0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0]])

dag_consensus = np.array([
    [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
    [0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0],
    [1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]])

dag_eaton = np.array([
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0],
    [0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 1, 0, 0, 0, 0, 1, 1, 0, 1, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]])

dag_reconstructed = np.array([
    [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
    [0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0],
    [1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]])

dag_mooij = np.array([
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0],
    [1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1],
    [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]])

DAGs = []

DAGs += [("consensus", dag_consensus),
         ("eaton", dag_eaton),
         ("reconstructed", dag_reconstructed),
         ("mooij", dag_mooij)]

for i, dag in enumerate(utils.all_dags(cpdag_icp)):
    DAGs.append(("dantzig-%d" % (i + 1), dag))

# --------------------------------------------------------------------
# Auxiliary functions


def process_data():
    """Process the data from the .csv files into a single np.array where
    the columns are in the same order as the DAGs."""
    dataframes = [pd.read_csv(DATA_PATH + f) for f in filenames]
    data = [df[var_names].to_numpy() for df in dataframes]
    np.savez(DATA_PATH + "sachs_data", *data)


def load_data(normalize=True):
    f = np.load(DATA_PATH + "sachs_data.npz")
    data = list(f.values())
    if normalize:
        pooled = np.vstack(data)
        mean = pooled.mean(axis=0)
        std = pooled.std(axis=0)
        data = [(X - mean) / std for X in data]
    return data


# -------------------------------------------------------------------
# Experiments

try:
    all_data = load_data()
except FileNotFoundError:
    process_data()

train_data, test_data = utils.split_data(
    all_data, [0.95, 0.05], random_state=42)

print("Training data :", [len(x) for x in train_data])
print("Test data :", [len(x) for x in test_data])

score_params = {
    'psi_max': None,
    'psi_fixed': False,
    'max_iter': 1000,
    'threshold_dist_B': 1e-3,
    'threshold_fluctuation': 1e-5,
    'max_fluctuations': 50,
    'threshold_score': 1e-5,
    'learning_rate': 1,
    'B_solver': 'cvx'}

num_latent = 1

# --------------------------------
# Experiment 1: Score all the DAGS

hs = [0, 1, 2, 3]


def experiment(prune_edges, tag, folds=[.7, .15, .15], random_state=42):
    experiment_start = time.time()
    print("Beginning experiments at %s" % datetime.now())
    print("  Pruning edges:", prune_edges)
    print()
    results = []
    for (name, dag) in DAGs:
        print("\nRunning UT-LVCE for %s DAG" % name)
        start = time.time()
        # result = "test"
        result = main.fit(train_data,
                          prune_graph=prune_edges,
                          nums_latent=hs,
                          initial_graphs=np.array([dag]),
                          folds=folds,
                          **score_params,
                          verbose=1,
                          store_history=0,
                          random_state=random_state)
        results.append(result)
        print("  Done (%0.2f seconds)" % (time.time() - start))

    print("Finished experiments (%0.2f seconds)" %
          (time.time() - experiment_start))
    save_results(results, prune_edges, tag, random_state)
    return results


def save_results(results, prune_edges, tag, random_state):
    filename = PATH + \
        "sach_results_%d_prune:%s_random_state:%d_tag:%s.pickle" % (
            time.time(), prune_edges, random_state, tag)
    with open(filename, 'wb') as f:
        pickle.dump((results, num_latent, score_params), f)
        print('\nWrote compiled results to "%s"' % filename)


def run_multisplit_experiments(prune_edges, splits):
    for i in splits:
        tag = "w_testset_%d" % i
        experiment(prune_edges=prune_edges, tag=tag,
                   folds=[.7, .15, .15], random_state=i + 1)


# --------------------------------------------------------------------
# Run experiments


if __name__ == '__main__':
    splits = list(range(50))
    # Run without pruning
    run_multisplit_experiments(prune_edges=True, splits=splits)
    # Run with pruning
    run_multisplit_experiments(prune_edges=False, splits=splits)
