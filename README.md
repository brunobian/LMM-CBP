# LMM-CBP code

Code for running cluster-based permutation test on EEG data using fieldtrip toolbox for Matlab and lme4 for R. The interaction between both programs depends on bash code implemented in Linux. This code allows to parallelize in different cores of one computer and in different computers.

This code consist in functions for exporting fieldtrip structures into CSV format, which could be easily imported in R.

# Structure

- **LMM-CBP/**: library
  - **bash_functions/**: functions for the interaction between Matlab and R
    - **run_models.sh**
    - **runParallelCluster.sh**
    - **runParallelCores.sh**

  - **m_functions/**: Function for exporting fieldtrip data and to analyse LMM results
    - **lm_exportErpCsv.m**
    - **lm_parallelRunLmmCluster.m**
    - **lm_followET.m**
    - **lm_parallelRunLMM.m**
    - **lm_cbpt.m**
    - **lm_loadLmmData.m**
    - **lm_percolation.m**
    - **lm_clustering.m**
    - **lm_lookForNeighbors.m**
    - **lm_completePercolations.m**
    - **lm_maxSum.m**

  - **R_functions/**: Functions for running LMM
    - **generateIterMatrix.R**
    - **lmmElecTime.R**
    - **completeRun.R**
    - **lmElecTime.R**
    - **lmmTimeWindow.R**
 
  - **example/**: tutorial data and scripts 



# Dependencies

- Matlab: fieldtrip
- R: lme4
- bash

