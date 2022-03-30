echo '# Experiments for section 4 + related supplementary material'
echo '# Total jobs: 32'
echo
echo '############################################################################################################################################'
echo '############################################################################################################################################'
echo '##### Experiments for main paper (sections 4 and 5)'
echo
echo '# --------------------------------------------------------------------------------'
echo '# Baseline 2 (figure ??): recovering I-MEC from initial set of DAGs, no edge pruning'
echo '# tag: fb1'
echo '# 4 jobs'
echo
echo '# Random graph'
echo
echo 'files_baseline_2_rd_hs = ['
ls experiments | grep fb2 | grep G:1 | grep i_v_lo:6
echo ']'
echo
echo
echo '# --------------------------------------------------------------------------------'
echo '# Baseline 3 (figure ??)'
echo '# tag: fb3'
echo '# 8 jobs'
echo
echo '# Random graph'
echo
echo 'files_baseline_3_rd_hs = ['
ls experiments | grep fb3 | grep G:1 | grep i_v_lo:6
echo ']'
echo
echo '# Chain graph'
echo
echo 'files_baseline_3_ch_hs = ['
ls experiments | grep fb3 | grep G:-1 | grep i_v_lo:6
echo ']'
echo
echo
echo '############################################################################################################################################'
echo '############################################################################################################################################'
echo '##### Experiments for supplementary material'
echo
echo '# --------------------------------------------------------------------------------'
echo '# Baseline 2: Same as in main paper but with soft interventions on observeds + chain graph'
echo '# 12 jobs'
echo '# tag: fb2b'
echo
echo '# Random graph: soft x soft interventions'
echo
echo 'files_baseline_2_rd_ss = ['
ls experiments | grep fb2 | grep G:1 | grep i_v_lo:3
echo ']'
echo
echo '# Chain graph: hard x soft interventions'
echo
echo 'files_baseline_2_ch_hs = ['
ls experiments | grep fb2 | grep G:-1 | grep i_v_lo:6
echo ']'
echo
echo
echo '# Chain graph: soft x soft interventions'
echo
echo 'files_baseline_2_ch_ss = ['
ls experiments | grep fb2 | grep G:-1 | grep i_v_lo:3
echo ']'
echo
echo
echo '# --------------------------------------------------------------------------------'
echo '# Baseline 3: same as in main paper but with soft interventions (3,6) on observed variables'
echo '# tag: fb3'
echo '# 8 jobs'
echo
echo '# Random graph'
echo
echo 'files_baseline_3_rd_ss = ['
ls experiments | grep fb3 | grep G:1 | grep i_v_lo:3
echo ']'
echo
echo '# Chain graph'
echo
echo 'files_baseline_3_ch_ss = ['
ls experiments | grep fb3 | grep G:-1 | grep i_v_lo:3
echo ']'
