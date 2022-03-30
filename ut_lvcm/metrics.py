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

import numpy as np
import ut_lvcm.utils as utils
# from cdt.metrics import SHD

# --------------------------------------------------------------------
# Metrics for the experiments


def type_1_struct(estimate, truth):
    true_imec = _imec(truth)
    print("Enumerated true imec: %d graphs" % len(true_imec))
    estimated_imec = _imec(estimate)
    print("Enumerated estimated imec: %d graphs" % len(estimated_imec))
    return type_1_structc(estimated_imec, true_imec)


def type_1_structc(estimated_class, true_class):
    return _maxmin_metric(estimated_class, true_class, _dist_struct)


def type_2_struct(estimate, truth):
    true_imec = _imec(truth)
    print("Enumerated true imec: %d graphs" % len(true_imec))
    estimated_imec = _imec(estimate)
    print("Enumerated estimated imec: %d graphs" % len(estimated_imec))
    return type_2_structc(estimated_imec, true_imec)


def type_2_structc(estimated_class, true_class):
    return _maxmin_metric(true_class, estimated_class, _dist_struct)


def type_1_I(estimate, truth):
    """~ type 1 error: i.e. how many of the elements in the estimated I
    are not in the true I."""
    (_, est_I) = estimate
    (_, true_I) = truth
    return _dist_sets(est_I, true_I)


def type_2_I(estimate, truth):
    """~ type 2 error: i.e. how many of the elements in the true I were
    not in the estimated I."""
    (_, est_I) = estimate
    (_, true_I) = truth
    return _dist_sets(true_I, est_I)


def type_1_parents(estimate, truth):
    """~type 1 error: how many of the parent sets in the estimate are not
    true parent sets."""
    return _maxmin_metric(estimate, truth, _dist_sets)


def type_2_parents(estimate, truth):
    """~type 2 error: how many of the parent sets in the truth were not in
    the estimate."""
    return _maxmin_metric(truth, estimate, _dist_sets)


def type_1_skeleton(estimate, truth):
    # TODO: Test
    estimated_skeleton = utils.skeleton(estimate)
    true_skeleton = utils.skeleton(truth)
    return _dist_struct(estimated_skeleton, true_skeleton)


def type_2_skeleton(estimate, truth):
    # TODO: Test
    estimated_skeleton = utils.skeleton(estimate)
    true_skeleton = utils.skeleton(truth)
    return _dist_struct(true_skeleton, estimated_skeleton)

# --------------------------------------------------------------------
# Auxiliary functions


def _imec(pair):
    (A, I) = pair
    return utils.imec(A, I)


def _maxmin_metric(maxclass, minclass, dist_fun):
    """
    Given two sets of objects class_1 and class_2 and a function dist_fun, compute the metric

       max (A2 in maxclass) min (A1 in minclass) dist_fun(A1, A2).

    """
    maxmin = -np.Inf
    for A2 in maxclass:
        min_distance = min([dist_fun(A2, A1) for A1 in minclass])
        if min_distance > maxmin:
            maxmin = min_distance
    return maxmin


def _dist_struct(A1, A2):
    """Number of edges in A1 not in A2, divided by the total number of edges in A1."""
    A1 = A1.astype(bool).astype(int)
    A2 = A2.astype(bool).astype(int)
    if A1.sum() == 0:
        return 0.0
    else:
        # Number of edges in A1 and not in A2
        edges = A2[A1.astype(bool)]
        missing = len(edges) - edges.sum()
        return missing / A1.sum()


def _dist_sets(S1, S2):
    """How many of the elements in the set S1 are not in the set S2"""
    if len(S1) == 0:
        return 0
    else:
        return len(S1 - S2) / len(S1)

# def _l_inf(B1, B2):
#     return abs(B1 - B2).max()

# # Min distance

# def metric_1(estimate, truth, train_cache):
#     """Return the minimum L∞ distance between the connectivity matrix of
#     the true model and one of the estimated I-MEC.

#     """
#     (est_model, est_I) = estimate
#     (true_model, true_I) = truth
#     # Compute the connectivities of the graphs in the estimated IMEC
#     estimated_icpdag = utils.dag_to_icpdag(est_model.A, est_I)
#     estimated_imec = utils.all_dags(estimated_icpdag)
#     print("    %d DAGs in the estimated I-MEC" % len(estimated_imec))
#     min_distance = np.Inf
#     for A in estimated_imec:
#         model, _ = train_cache.score_dag(A, est_I)
#         dist = _l_inf(model.B, true_model.B)
#         if dist < min_distance:
#             min_distance = dist
#     return min_distance


# # Maxmin distance

# def metric_2(estimate, truth, train_cache):
#     """Return the L∞ distance between the maximizing connectivity in the
#     true I-MEC and the minimizing connectivity in the estimate,
#     i.e. solve the objective

#        max_{B* in true_Bs} min_{B in est_Bs} L∞(B*,B)

#     """
#     # Fit the connectivities in the true I-MEC on the train data
#     true_Bs = []
#     (true_model, true_I) = truth
#     true_icpdag = utils.dag_to_icpdag(true_model.A, true_I)
#     true_imec = utils.all_dags(true_icpdag)
#     print("    %d DAGs in the true I-MEC" % len(true_imec))
#     for A in true_imec:
#         model, _ = train_cache.score_dag(A, true_I)
#         true_Bs.append(model.B)

#     # Fit the connectivities in the estimated I-MEC on the train data
#     est_Bs = []
#     (est_model, est_I) = estimate
#     estimated_icpdag = utils.dag_to_icpdag(est_model.A, est_I)
#     estimated_imec = utils.all_dags(estimated_icpdag)
#     print("    %d DAGs in the estimated I-MEC" % len(estimated_imec))
#     for A in estimated_imec:
#         model, _ = train_cache.score_dag(A, est_I)
#         est_Bs.append(model.B)

#     # Solve the objective
#     maxmin = -np.Inf
#     for B in true_Bs:
#         # Compute the min. distance from this B in the true I-MEC to
#         # all Bs in the estimated I-MEC
#         min_distance = min([_l_inf(B, B_hat) for B_hat in est_Bs])
#         if min_distance > maxmin:
#             maxmin = min_distance
#     return maxmin


# def metric_3(estimate, truth, _):
#     """Compute the structural hamming distance between the estimated and true I-CPDAG"""
#     return 0
#     # (true_model, true_I) = truth
#     # true_icpdag = utils.dag_to_icpdag(true_model.A, true_I)
#     # (est_model, est_I) = estimate
#     # estimated_icpdag = utils.dag_to_icpdag(est_model.A, est_I)
#     # # Compute SHD between true icpdag and estimate
#     # return SHD(true_icpdag, estimated_icpdag, double_for_anticausal=False)

# # Jaccard similarity between true and estimated I-MEC


# def metric_4(estimate, truth, train_cache):
#     """Compute the jaccard similarity between the sets of graphs in the true I-MEC and the estimated I-MEC."""
#     # Enumerate all DAGs in the I-MECS
#     (true_model, true_I) = truth
#     true_icpdag = utils.dag_to_icpdag(true_model.A, true_I)
#     true_imec = set([utils.to_factorization(A) for A in utils.all_dags(true_icpdag)])
#     (est_model, est_I) = estimate
#     estimated_icpdag = utils.dag_to_icpdag(est_model.A, est_I)
#     estimated_imec = set([utils.to_factorization(A) for A in utils.all_dags(estimated_icpdag)])
#     return len(estimated_imec & true_imec) / len(estimated_imec | true_imec)


# def metric_5(estimate, truth, train_cache):
#     """Compute the jaccard similarity between the true and estimated I"""
#     (_, true_I) = truth
#     (_, estimated_I) = estimate
#     if len(estimated_I | true_I) == 0:
#         return 1
#     else:
#         return len(estimated_I & true_I) / len(estimated_I | true_I)
