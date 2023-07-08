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

# --------------------------------------------------------------------------------
# Baseline 2 (figure 3a): recovering I-MEC from initial set of DAGs, no edge pruning
# tag: fb2

# Random graph

sbatch --time=1:00:00 --ntasks=51 --wrap="python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb2 --chunksize 1 --runs 50 --seed 42 --G 1 --disc 30 --k 2.1 --p 20 --w_lo 0.6 --w_hi 0.8 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 3 --np --n 100"
sbatch --time=1:00:00 --ntasks=51 --wrap="python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb2 --chunksize 1 --runs 50 --seed 42 --G 1 --disc 30 --k 2.1 --p 20 --w_lo 0.6 --w_hi 0.8 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 3 --np --n 500"
sbatch --time=1:00:00 --ntasks=51 --wrap="python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb2 --chunksize 1 --runs 50 --seed 42 --G 1 --disc 30 --k 2.1 --p 20 --w_lo 0.6 --w_hi 0.8 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 3 --np --n 1000"
sbatch --time=1:00:00 --ntasks=51 --wrap="python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb2 --chunksize 1 --runs 50 --seed 42 --G 1 --disc 30 --k 2.1 --p 20 --w_lo 0.6 --w_hi 0.8 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 3 --np --n 10000"

# --------------------------------------------------------------------------------
# Baseline 3 (figure 3b): recovering I-MEC from initial set of DAGs, WITH edge pruning
# tag: fb3

# Random graph

sbatch --time=1:00:00 --ntasks=51 --wrap="python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G 1 --k 2.1 --p 20 --w_lo 0.6 --w_hi 0.8 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 100"
sbatch --time=1:00:00 --ntasks=51 --wrap="python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G 1 --k 2.1 --p 20 --w_lo 0.6 --w_hi 0.8 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 500"
sbatch --time=1:00:00 --ntasks=51 --wrap="python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G 1 --k 2.1 --p 20 --w_lo 0.6 --w_hi 0.8 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 1000"
sbatch --time=1:00:00 --ntasks=51 --wrap="python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G 1 --k 2.1 --p 20 --w_lo 0.6 --w_hi 0.8 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 10000"

# Chain graph

sbatch --time=1:00:00 --ntasks=51 --wrap="python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G -1 --p 20 --w_lo 0.6 --w_hi 0.8 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 100"
sbatch --time=1:00:00 --ntasks=51 --wrap="python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G -1 --p 20 --w_lo 0.6 --w_hi 0.8 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 500"
sbatch --time=1:00:00 --ntasks=51 --wrap="python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G -1 --p 20 --w_lo 0.6 --w_hi 0.8 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 1000"
sbatch --time=1:00:00 --ntasks=51 --wrap="python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G -1 --p 20 --w_lo 0.6 --w_hi 0.8 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 10000"
