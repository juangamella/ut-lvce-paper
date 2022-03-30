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
import ut_lvcm.main as main
import time
from datetime import datetime
import pickle

# --------------------------------------------------------------------
# DAGs

PATH = "scratch/reservoirs/"

filenames = ["train_%d.txt" % i for i in range(1, 5)]

node_names = ["SHA", "ORO", "CLE", "NML", "DNP", "BER", "ALM",
              "EXC", "PNF", "FOL", "BUL", "ISB", "MIL", "CMN", "WRS"]

# --------------------------------------------------------------------
# Auxiliary functions


def process_data():
    """Process the data from the .csv files into a single np.array"""
    print("Processing reservoir data from files")
    print("  %s" % filenames)
    dataframes = [pd.read_csv(PATH + f, header=None) for f in filenames]
    data = [df.to_numpy() for df in dataframes]
    np.savez(PATH + "reservoirs_data", *data)
    print("  Saved in", PATH + "reservoirs_data" + ".npz")


def load_data(normalize=True):
    f = np.load(PATH + "reservoirs_data.npz")
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
    data = load_data()
except FileNotFoundError:
    process_data()


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

# --------------------------------
# Experiment: Using GES initialization, run the ut-lvce procedure on the reservoir data


def experiment(p=15, envs=None, prune_edges=True, threshold=False, ges_obs=True, tag="", folds=[0.5, 0.25, 0.25], latents=True, random_state=42):
    start = time.time()
    print("Beginning experiments at %s" % datetime.now())
    print("  Pruning edges:", prune_edges)
    print("  Thresholding:", threshold)
    print()
    # Load data
    data = load_data()
    data = [X[:, 0:p] for X in data]
    if envs is not None:
        data = [data[i] for i in envs]
    print("len(data) =", len(data))
    print("data[i].shape =", [X.shape for X in data])
    # Set up whether we allow for latents or not in the estimator
    num_latent = [0, 1, 2, 3] if latents else [0]
    # Set other parameters
    threshold_graph = 0.1 if threshold else None
    threshold_I = 0.1 if threshold else None
    # result = "test"
    result = main.fit(data,
                      prune_graph=prune_edges,
                      nums_latent=num_latent,
                      **score_params,
                      verbose=1,
                      threshold_graph=threshold_graph,
                      threshold_I=threshold_I,
                      ges_env=0 if ges_obs else None,
                      folds=folds,
                      random_state=random_state)
    print("Finished experiments (%0.2f seconds)" % (time.time() - start))
    save_results(result, p, num_latent, prune_edges, threshold, ges_obs, tag, latents, random_state)
    return result

def save_results(results, p, num_latent, prune_edges, threshold, ges_obs, tag, latents, random_state):
    filename = PATH + \
        "reservoir_results_%d_p:%d_prune:%s_th:%s_ges-obs:%s_latents:%s_random_state:%d_tag:%s.pickle" % (
            time.time(), p, prune_edges, threshold, ges_obs, latents, random_state, tag)
    with open(filename, 'wb') as f:
        pickle.dump((results, num_latent, score_params), f)
    print('\nWrote compiled results to "%s"' % filename)


def run_multisplit_experiments():
    for i in range(10):
        tag = "multisplit_%d" % i
        experiment(p=10, tag=tag, folds=[.7, .15, .15], latents=False, random_state=i)
