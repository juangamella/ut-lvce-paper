# Experiments for section 4 + related supplementary material
# Total jobs: 32

############################################################################################################################################
############################################################################################################################################
##### Experiments for main paper (sections 4 and 5)

# --------------------------------------------------------------------------------
# Baseline 2 (figure ??): recovering I-MEC from initial set of DAGs, no edge pruning
# tag: fb2
# 8 jobs

# Random graph

bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb2 --chunksize 1 --runs 50 --seed 42 --G -1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 3 --np --n 100
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb2 --chunksize 1 --runs 50 --seed 42 --G -1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 3 --np --n 500
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb2 --chunksize 1 --runs 50 --seed 42 --G -1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 3 --np --n 1000
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb2 --chunksize 1 --runs 50 --seed 42 --G -1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 3 --np --n 10000

# --------------------------------------------------------------------------------
# Baseline 3 (figure ??): recovering I-MEC from initial set of DAGs, WITH edge pruning
# tag: fb3
# 8 jobs

# Random graph

bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G 1 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 100
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G 1 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 500
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G 1 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 1000
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G 1 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 10000

# Chain graph

bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G -1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 100
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G -1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 500
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G -1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 1000
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G -1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 10000



############################################################################################################################################
############################################################################################################################################
##### Experiments for supplementary material

# --------------------------------------------------------------------------------
# Baseline 2: Same as in main paper but with soft interventions on observeds + chain graph
# 12 jobs
# tag: fb2b

# Random graph: soft x soft interventions

bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb2b --chunksize 1 --runs 50 --seed 42 --G -1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 3 --np --n 100
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb2b --chunksize 1 --runs 50 --seed 42 --G -1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 3 --np --n 500
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb2b --chunksize 1 --runs 50 --seed 42 --G -1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 3 --np --n 1000
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb2b --chunksize 1 --runs 50 --seed 42 --G -1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 3 --np --n 10000

# Chain graph: hard x soft interventions

bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb2b --chunksize 1 --runs 50 --seed 42 --G 1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 3 --np --n 100
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb2b --chunksize 1 --runs 50 --seed 42 --G 1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 3 --np --n 500
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb2b --chunksize 1 --runs 50 --seed 42 --G 1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 3 --np --n 1000
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb2b --chunksize 1 --runs 50 --seed 42 --G 1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 3 --np --n 10000

# Chain graph: soft x soft interventions

bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb2b --chunksize 1 --runs 50 --seed 42 --G 1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 3 --np --n 100
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb2b --chunksize 1 --runs 50 --seed 42 --G 1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 3 --np --n 500
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb2b --chunksize 1 --runs 50 --seed 42 --G 1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 3 --np --n 1000
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb2b --chunksize 1 --runs 50 --seed 42 --G 1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 3 --np --n 10000

# --------------------------------------------------------------------------------
# Baseline 3: same as in main paper but with soft interventions (3,6) on observed variables
# tag: fb3
# 8 jobs

# Random graph

bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G 1 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 100
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G 1 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 500
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G 1 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 1000
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G 1 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 10000

# Chain graph

bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G -1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 100
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G -1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 500
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G -1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 1000
bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb3 --chunksize 1 --runs 50 --no_edges 20 --seed 42 --G -1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --disc 15 --h 2 --e 5 --size_I 10 --init 4 --n 10000


# # --------------------------------------------------------------------------------
# # Baseline 1: In case the results are ever needed
# # 16 jobs
# # tag: fb1b

# # Random graph: hard x soft interventions

# bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb1 --chunksize 1 --runs 50 --seed 42 --G -1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 1 --np --n 100
# bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb1 --chunksize 1 --runs 50 --seed 42 --G -1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 1 --np --n 500
# bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb1 --chunksize 1 --runs 50 --seed 42 --G -1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 1 --np --n 1000
# bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb1 --chunksize 1 --runs 50 --seed 42 --G -1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 1 --np --n 10000

# # Chain graph: hard x soft interventions

# bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb1 --chunksize 1 --runs 50 --seed 42 --G 1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 1 --np --n 100
# bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb1 --chunksize 1 --runs 50 --seed 42 --G 1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 1 --np --n 500
# bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb1 --chunksize 1 --runs 50 --seed 42 --G 1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 1 --np --n 1000
# bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb1 --chunksize 1 --runs 50 --seed 42 --G 1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 6 --i_v_hi 12 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 1 --np --n 10000

# # Random graph: soft x soft interventions

# bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb1b --chunksize 1 --runs 50 --seed 42 --G -1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 1 --np --n 100
# bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb1b --chunksize 1 --runs 50 --seed 42 --G -1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 1 --np --n 500
# bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb1b --chunksize 1 --runs 50 --seed 42 --G -1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 1 --np --n 1000
# bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb1b --chunksize 1 --runs 50 --seed 42 --G -1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 1 --np --n 10000

# # Chain graph: soft x soft interventions

# bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb1b --chunksize 1 --runs 50 --seed 42 --G 1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 1 --np --n 100
# bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb1b --chunksize 1 --runs 50 --seed 42 --G 1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 1 --np --n 500
# bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb1b --chunksize 1 --runs 50 --seed 42 --G 1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 1 --np --n 1000
# bsub -W 1:00 -n 51 python3 -m ut_lvcm.cross_validated_experiments --n_workers 50 --tag fb1b --chunksize 1 --runs 50 --seed 42 --G 1 --disc 30 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --i_v_lo 3 --i_v_hi 6 --psi_lo 0.2 --psi_hi 0.3 --i_psi_lo 0.2 --i_psi_hi 1 --h 2 --e 5 --size_I 4 --init 1 --np --n 10000
