#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(InvariantCausalPrediction)

CASES = strtoi(args[1])
PATH = args[2]
DEBUG = strtoi(args[3])

if (DEBUG) {
    print(sprintf('PATH: %s', PATH))
    print(sprintf('TOTAL NUMBER OF CASES: %d', CASES))
    }

case_no = 0

while (case_no < CASES) {

    if (DEBUG) print(sprintf("  Trying test case %d", case_no)) else 0
    
    ## Read csv
    filename = sprintf('%stest_case_%d_data.csv', PATH, case_no)
    raw = read.csv(filename, header=FALSE)
    
    ## Process the data and set up variables for ICP
    target <- 0 # target is always 0
    ExpInd <- raw[,1] + 1
    Y <- raw[,target+2]
    preds <- c(2:ncol(raw))
    preds <- preds[-(target+1)]
    X <- data.matrix(raw[, preds])

    ## Run ICP
    alpha <- 0.001
    ## icp = ICP(X,Y,ExpInd,selection='all',alpha=alpha, gof=alpha, showCompletion=FALSE)
    icp <- hiddenICP(X,Y,ExpInd,alpha=0.01)
    if (DEBUG) print(icp) else 0

    ## One-hot encode accepted sets
    one_hot <- matrix(0, 1, ncol(X))
    one_hot[1,] = icp$pvalues < alpha
    if (DEBUG) {
        print(icp$pvalues)
        print(one_hot)
        }

    ## Write point estimate
    print("Saving test case")
    filename = sprintf('%shicp_result_%d.csv', PATH, case_no)
    write.csv(one_hot, filename)

    print(sprintf("  saved test case %d to file %s", case_no, filename))

    if (DEBUG) print(sprintf("  Finished test case %d", case_no)) else 0
    }

    case_no = case_no + 1
 
