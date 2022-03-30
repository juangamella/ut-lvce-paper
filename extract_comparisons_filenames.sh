echo '# Experiments for section 5 + related supplementary material'
echo '# Total jobs: 40 + (4)'
echo
echo '############################################################################################################################################'
echo '############################################################################################################################################'
echo '##### Combinations according to'
echo '# +-------------------------------+----------+----------+------------+'
echo '# | Interventions on Obs.  / Lat. |   Hard   |   Soft   |   None     |'
echo '# +-------------------------------+----------+----------+------------+'
echo '# | Hard                          |       10 | 10,19,20 | (20)       |'
echo '# | Soft                          | 10,19,20 | 10,19,20 | Ø          |'
echo '# +-------------------------------+----------+----------+------------+'
echo
echo
echo '# ----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '# HH - hard interventions on observeds, hard interventions on latents'
echo '# 4 jobs'
echo '# I = 10'
echo
echo 'files_hh = ['
echo '['
ls comparison_experiments | grep tag:ffchh | grep size_I:10
echo ']'
echo ']'
echo
echo '# ----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '# HS - Hard interventions on observed and soft on latents'
echo '# 12 jobs'
echo
echo 'files_hs = ['
echo '['
ls comparison_experiments | grep tag:ffchs | grep size_I:10
echo '],'
echo '['
ls comparison_experiments | grep tag:ffchs | grep size_I:19
echo '],'
echo '['
ls comparison_experiments | grep tag:ffchs | grep size_I:20
echo ']]'
echo
echo
echo '# ----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '# HN - Hard interventions on observed and none on latents'
echo '# 4 jobs'
echo
echo 'files_hn = ['
echo '['
ls comparison_experiments | grep tag:ffchn | grep size_I:10
echo '],'
echo '['
ls comparison_experiments | grep tag:ffchn | grep size_I:19
echo '],'
echo '['
ls comparison_experiments | grep tag:ffchn | grep size_I:20
echo ']]'
echo
echo
echo '# ----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '# SH - Soft interventions on observeds and hard on latents'
echo '# 8 jobs'
echo
echo 'files_sh = ['
echo '['
ls comparison_experiments | grep tag:ffcsh | grep size_I:10
echo '],'
echo '['
ls comparison_experiments | grep tag:ffcsh | grep size_I:19
echo '],'
echo '['
ls comparison_experiments | grep tag:ffcsh | grep size_I:20
echo ']]'
echo
echo
echo '# ----------------------------------------------------------------------------------------------------------------------------------------------------------------'
echo '# SS - Soft interventions on observed and latents'
echo '# 12 jobs'
echo
echo 'files_ss = ['
echo '['
ls comparison_experiments | grep tag:ffcss | grep size_I:10
echo '],'
echo '['
ls comparison_experiments | grep tag:ffcss | grep size_I:19
echo '],'
echo '['
ls comparison_experiments | grep tag:ffcss | grep size_I:20
echo ']]'
echo
echo
