# Experiment Repository for *Perturbations and Causality in Gaussian Latent Variable Models*

This repository contains the code to reproduce the experiments and plot the results for the paper *"Perturbations and Causality in Gaussian Latent Variable Models"*, by A. Taeb, JL. Gamella, C. Heinze-Deml and P. Bühlmann.

This README is not intended to be completely self-explanatory, and should be read alongside the manuscript (https://arxiv.org/abs/2101.06950).

## Installing Dependencies

## Reproducing the results

### Baseline experiments (figures 3a and 3b)

1. Execute the script [`run_baselines.sh`](run_baselines.sh). It will use a total of 4 threads (cores) to run the experiments; the number of threads can be set by editing the script and setting the variable `N_THREADS` to the desired value.
2. The results are stored in the `baseline_experiments/` directory.
3. To generate the figures, use notebooks [`figures_baseline_2.ipynb`](figures_baseline_2.ipynb) and [`figures_baseline_3.ipynb`](figures_baseline_3.ipynb), appropriately replacing the existing result filenames by those from step 2. The resulting figures are stored in the `figures/` directory.

### UT-LVCE for Causal Discovery (figures 4, 7, 8 and 9)

1. Execute the script [`run_comparisons.sh`](run_comparisons.sh). It will use a total of 4 threads (cores) to run the experiments; the number of threads can be set by editing the script and setting the variable `N_THREADS` to the desired value.
2. The results are stored in the `comparison_experiments/` directory.
3. To generate the figures, use notebook [`figures_comparisons.ipynb`](figures_comparisons.ipynb), appropriately replacing the existing result filenames by those from step 2. The resulting figures are stored in the `figures/` directory.

### Sachs Dataset Experiments (figures 5 and 10)

### California Reservoirs Experiments (figure 6)

## Repository structure

## Feedback

If you need assistance or have feedback, you are more than welcome to write me an [email](mailto:juan.gamella@stat.math.ethz.ch) :)
