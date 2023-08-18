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

# Experiment table (intervention/latent strength, intervention size)

# +-------------------------------+----------+----------+------------+
# | Graph. density  / # latents . |   2      |   3      |   4        |
# +-------------------------------+----------+----------+------------+
# | 1.9                           |       10 |       10 |         10 |
# | 2.1                           |       10 |       10 |         10 |
# | 2.3                           |       10 |       10 |         10 |
# +-------------------------------+----------+----------+------------+
# Total 3 x 9 = 27 jobs

# NOTE: The only effect of the --cluster tag below is to set the
# result storage directory to a different location. This location is
# specific to the ETH Euler cluster, and is hardcoded in the file
# ut_lvcm/comparison_experiments.py.
#   -> You don't need to use this flag to run on a cluster.

BASE='--n_workers 50 --cluster --chunksize 1 --runs 10 --seed 42 --G 50 --p 20 --w_lo 0.6 --w_hi 0.8 --v_lo 0.5 --v_hi 0.6 --psi_lo 0.2 --psi_hi 0.3 --i_v_lo 6 --i_v_hi 12 --i_psi_lo 0.2 --i_psi_hi 1 --size_I 10 --e 5 --min_parents 2 --Hs="1,2,3,4,5,6" --save --umd'
BSUB_PARAMS='--time=50:00:00 --ntasks=150'

# ----------------------------------------------------------------------
# H = 2

# h = 2, k = 1.9
CASE_PARAMS='--h 2 --k 1.9'
TAG='uhd2l'

echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""

# h = 2, k = 2.5
CASE_PARAMS='--h 2 --k 2.5'
TAG='uhd2m'

echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""

# h = 2, k = 3
CASE_PARAMS='--h 2 --k 3'
TAG='uhd2h'

echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""

# ----------------------------------------------------------------------
# H = 3

# h = 3, k = 1.9
CASE_PARAMS='--h 3 --k 1.9'
TAG='uhd3l'

echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""

# h = 3, k = 2.5
CASE_PARAMS='--h 3 --k 2.5'
TAG='uhd3m'

echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""

# h = 3, k = 3
CASE_PARAMS='--h 3 --k 3'
TAG='uhd3h'

echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""


# ----------------------------------------------------------------------
# H = 4

# h = 4, k = 1.9
CASE_PARAMS='--h 4 --k 1.9'
TAG='uhd4l'

echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""

# h = 4, k = 2.5
CASE_PARAMS='--h 4 --k 2.5'
TAG='uhd4m'

echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""

# h = 4, k = 3
CASE_PARAMS='--h 4 --k 3'
TAG='uhd4h'

echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""


# ----------------------------------------------------------------------
# H = 6

# h = 6, k = 1.9
CASE_PARAMS='--h 6 --k 1.9'
TAG='uhd6l'

echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""

# h = 6, k = 2.5
CASE_PARAMS='--h 6 --k 2.5'
TAG='uhd6m'

echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""

# h = 6, k = 3
CASE_PARAMS='--h 6 --k 3'
TAG='uhd6h'

echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""

# # ----------------------------------------------------------------------
# # H = XX

# # h = XX, k = 1.9
# CASE_PARAMS='--h XX --k 1.9'
# TAG='uhdXXl'

# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""

# # h = XX, k = 2.5
# CASE_PARAMS='--h XX --k 2.5'
# TAG='uhdXXm'

# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""

# # h = XX, k = 3
# CASE_PARAMS='--h XX --k 3'
# TAG='uhdXXh'

# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""

 
# # ----------------------------------------------------------------------
# # H = 5

# # h = 5, k = 1.9
# CASE_PARAMS='--h 5 --k 1.9'
# TAG='uhd5l'

# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""

# # h = 5, k = 2.5
# CASE_PARAMS='--h 5 --k 2.5'
# TAG='uhd5m'

# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""

# # h = 5, k = 3
# CASE_PARAMS='--h 5 --k 3'
# TAG='uhd5h'

# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""


# # ----------------------------------------------------------------------
# # H = 10

# # h = 10, k = 1.9
# CASE_PARAMS='--h 10 --k 1.9'
# TAG='uhd10l'

# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""

# # h = 10, k = 2.5
# CASE_PARAMS='--h 10 --k 2.5'
# TAG='uhd10m'

# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""

# # h = 10, k = 3
# CASE_PARAMS='--h 10 --k 3'
# TAG='uhd10h'

# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 100\""
# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 500\""
# echo "sbatch $BSUB_PARAMS --wrap=\"python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $CASE_PARAMS --n 1000\""
