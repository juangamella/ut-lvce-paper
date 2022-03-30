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
# | Interventions on Obs.  / Lat. |   Hard   |   Soft   |   None     |
# +-------------------------------+----------+----------+------------+
# | Hard                          |       10 | 10,19,20 | Ø          |
# | Soft                          | 10,19,20 | 10,19,20 | Ø          |
# +-------------------------------+----------+----------+------------+
# Total is 3 + 9 + 10 + 11 = 33 jobs

# Set the number of threads/cores that can be used to run the experiments
N_THREADS=4

BASE='--chunksize 1 --runs 10 --seed 42 --G 50 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --psi_lo 0.2 --psi_hi 0.3 --h 2 --e 5 --min_parents 2 --hist 1'

# ----------------------------------------------------------------------------------------------------------------------------------------------------------------
# HH - hard interventions on observeds, hard interventions on latents
# 3 jobs

INTERVENTIONS='--i_v_lo 6 --i_v_hi 12 --i_psi_lo 1 --i_psi_hi 5'
TAG='fffchh'

# I = 10

python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 100
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 500
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 1000


# ----------------------------------------------------------------------------------------------------------------------------------------------------------------
# HS - Hard interventions on observed and soft on latents
# 9 jobs

INTERVENTIONS='--i_v_lo 6 --i_v_hi 12 --i_psi_lo 0.2 --i_psi_hi 1'
TAG='fffchs'

# I = 10

python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 100
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 500
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 1000

# I = 19

python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 100
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 500
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 1000

# I = 20

python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 100
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 500
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 1000


# ----------------------------------------------------------------------------------------------------------------------------------------------------------------
# SH - Soft interventions on observeds and hard on latents
# 10 jobs

INTERVENTIONS='--i_v_lo 3 --i_v_hi 6 --i_psi_lo 1 --i_psi_hi 5'
TAG='fffcsh'

# I = 10

python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 100
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 500
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 1000

# I = 19

python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 100
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 500
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 1000
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 10000

# I = 20

python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 100
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 500
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 1000

# ----------------------------------------------------------------------------------------------------------------------------------------------------------------
# SS - Soft interventions on observed and latents
# 11 jobs

INTERVENTIONS='--i_v_lo 3 --i_v_hi 6 --i_psi_lo 0.2 --i_psi_hi 1'
TAG='fffcss'

# I = 10

python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 100
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 500
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 1000

# I = 19

python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 100
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 500
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 1000
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 10000

# I = 20

python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 100
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 500
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 1000
python3 -m ut_lvcm.comparison_experiments --n_workers $N_THREADS --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 10000
