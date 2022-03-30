# Experiments for section 5 + related supplementary material
# Total jobs: 40 + (4)

############################################################################################################################################
############################################################################################################################################
##### Combinations according to
# +-------------------------------+----------+----------+------------+
# | Interventions on Obs.  / Lat. |   Hard   |   Soft   |   None     |
# +-------------------------------+----------+----------+------------+
# | Hard                          |       10 | 10,19,20 | (20)       |
# | Soft                          | 10,19,20 | 10,19,20 | Ø          |
# +-------------------------------+----------+----------+------------+

BASE='--n_workers 50 --cluster --chunksize 1 --runs 10 --seed 42 --G 50 --k 2.1 --p 20 --w_lo 0.7 --w_hi 0.7 --v_lo 0.5 --v_hi 0.6 --psi_lo 0.2 --psi_hi 0.3 --h 2 --e 5 --min_parents 2 --hist 1'
BSUB_PARAMS='-W 120:00 -n 51'

# ----------------------------------------------------------------------------------------------------------------------------------------------------------------
# HH - hard interventions on observeds, hard interventions on latents
# 4 jobs

INTERVENTIONS='--i_v_lo 6 --i_v_hi 12 --i_psi_lo 1 --i_psi_hi 5'
TAG='fffchh'

# I = 10

echo "first CMD: bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 100"
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 100
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 500
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 1000
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 10000


# ----------------------------------------------------------------------------------------------------------------------------------------------------------------
# HS - Hard interventions on observed and soft on latents
# 12 jobs

INTERVENTIONS='--i_v_lo 6 --i_v_hi 12 --i_psi_lo 0.2 --i_psi_hi 1'
TAG='fffchs'

# I = 10

bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 100
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 500
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 1000
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 10000

# I = 19

bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 100
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 500
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 1000
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 10000

# I = 20

bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 100
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 500
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 1000
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 10000


# ----------------------------------------------------------------------------------------------------------------------------------------------------------------
# HN - Hard interventions on observed and none on latents
# 4 jobs

INTERVENTIONS='--i_v_lo 6 --i_v_hi 12'
TAG='fffchn'

# I = 20

# bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 100
# bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 500
# bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 1000
# bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 10000

# ----------------------------------------------------------------------------------------------------------------------------------------------------------------
# SH - Soft interventions on observeds and hard on latents
# 12 jobs

INTERVENTIONS='--i_v_lo 3 --i_v_hi 6 --i_psi_lo 1 --i_psi_hi 5'
TAG='fffcsh'

# I = 10

bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 100
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 500
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 1000
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 10000

# I = 19

bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 100
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 500
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 1000
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 10000

# I = 20

bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 100
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 500
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 1000
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 10000

# ----------------------------------------------------------------------------------------------------------------------------------------------------------------
# SS - Soft interventions on observed and latents
# 12 jobs

INTERVENTIONS='--i_v_lo 3 --i_v_hi 6 --i_psi_lo 0.2 --i_psi_hi 1'
TAG='fffcss'

# I = 10

bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 100
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 500
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 1000
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 10 --n 10000

# I = 19

bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 100
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 500
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 1000
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 19 --n 10000

# I = 20

bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 100
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 500
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 1000
bsub $BSUB_PARAMS python3 -m ut_lvcm.comparison_experiments --tag $TAG $BASE $INTERVENTIONS --size_I 20 --it --n 10000
