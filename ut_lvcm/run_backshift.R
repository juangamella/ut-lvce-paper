#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
library(backShift)

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
filename = sprintf('%stest_case_%d_data.csv', PATH, case_no)
raw = read.csv(filename, header=FALSE)

## Process the data
ExpInd <- raw[,1] + 1
X <- data.matrix(raw[,-1])

## Compute feedback estimator with stability selection

network <- backShift(X, ExpInd, ev = 1)

## Print point estimates and stable edges
if (DEBUG) {
    ## point estimate
    print(network$Ahat)
    ## shows empirical selection probability for stable edges
    print(network$AhatAdjacency)
}

## Save resulting adjacency
filename = sprintf('%sbackshift_result_%d.csv', PATH, case_no)
write.csv(network$AhatAdjacency, filename)

if (DEBUG) print(sprintf("  Finished test case %d", case_no)) else 0
