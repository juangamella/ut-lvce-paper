#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

## Load dependencies
library("Matrix")
library("MASS")
library("mvtnorm")
library("RSpectra")
library("matrixcalc")
library("pcaPP")
library("cvTools")
library(pcalg)
library(bnlearn)

set.seed(1) # For reproducibility

case_no = strtoi(args[1])
PATH = args[2]
sprintf(args[3])
DEBUG = strtoi(args[3])

if (DEBUG) {
    print(sprintf('PATH: %s', PATH))
}

if (DEBUG) print(sprintf("  Trying test case %d", case_no)) else 0

## Read csv
filename = sprintf('%stest_case_%d_pooled_data.csv', PATH, case_no)
X = read.csv(filename, header=FALSE)

n = nrow(X)
p = ncol(X)

if (DEBUG) print(sprintf("  Loaded data - n=%d, p=%d", n, p)) else 0

## -------------------------------------------------------------------
## Estimating S, L using 5-fold cross-validation

source("./scratch/lrps-admm/lrps/fit_path.R")
source("./scratch/lrps-admm/lrps/fast_lrps_admm.R")
source("./scratch/lrps-admm/lrps/cross_validation.R")
xval.lls <- c()
gammas <- c(0.05, 0.07, 0.1, 0.12, 0.15, 0.17, 0.2)
for(gamma in gammas) {
    xval.path <- cross.validate.low.rank.plus.sparse(X = X, gamma = gamma, n = nrow(X), covariance.estimator = cor, 
                                                     n.folds = 5, 
                                                     verbose = FALSE, seed = 1,
                                                     n.lambdas = 40, lambda.ratio = 1e-04)
    bf <- choose.cross.validate.low.rank.plus.sparse(xval.path)$mean_xval_ll
    xval.lls <- c(xval.lls, bf)
}
best.gamma <- gammas[which.min(xval.lls)]
print(paste("Selected value of Gamma", best.gamma))


xval.path <- cross.validate.low.rank.plus.sparse(X = X, gamma = best.gamma, n = nrow(X), covariance.estimator = cor, 
                                                 n.folds = 5, 
                                                 verbose = FALSE, seed = 1,
                                                 n.lambdas = 40, lambda.ratio = 1e-04)

## -------------------------------------------------------------------
## Fit GES using S^-1 as input


selected.S <- choose.cross.validate.low.rank.plus.sparse(xval.path)$fit$S
## Because the GES function of pcalg can only take a data matrix as input and not a covariance matrix, 
## we simulate data with the exact same sample covariance matrix as the estimated one. 
## This is a trick that lets use the GES function of pcalg.
source("./scratch/lrps-admm/utils/generate_data_for_GES.R")
fake.data <- generate.data.for.GES(Sest = selected.S, n=n, p=p)

## Run GES on the resulting data
score <- new("GaussL0penObsScore", fake.data)
ges.fit <- ges(score)

## -------------------------------------------------------------------
## Extract CPDAG
if (DEBUG) print("  Extracting CPDAG") else 0
cpdag <- matrix(0, p, p)
i = 1
for (parents in ges.fit$essgraph$.in.edges) {
    cpdag[parents, i] = 1
    i <- i+1
}
    

## Print CPDAG
if (DEBUG) {
    print(cpdag)
}

## Save resulting adjacency
filename = sprintf('%slrps_result_%d.csv', PATH, case_no)
write.csv(cpdag, filename)

if (DEBUG) print(sprintf("  Finished test case %d", case_no)) else 0
