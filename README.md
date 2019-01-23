# LMM-CBP code

Code for running cluster-based permutation test on EEG data using fieldtrip toolbox for Matlab and lme4 for R. The interaction between both programs depends on bash code implemented in Linux. This code allows to parallelize in different cores of one computer and in different computers.

This code consist in functions for exporting fieldtrip structures into CSV format, which could be easily imported in R.

# How to cite us
#### Please, if you like it / use it cite us:
Bianchi B, Shalom DE, and Kamienkowski JE, “Predicting known sentences: neural basis of proverb reading using nonparametric statistical testing and mixed-effects models” (under review)
#### And let us know!!
* Bruno Bianchi (bbianchi (at) dc (dot) uba (dot) ar)
* Diego E. Shalom (diegoshalom (at) gmail (dot) com)
* Juan E. Kamienkowski (juank (at) dc (dot) com (dot) ar)

# Required toolboxes
* [MatLab] EEGLAB (version v14.1.1): https://sccn.ucsd.edu/eeglab/index.php 
* [MatLab] Fieldtrip (version 3e7ad536c, 20170827): http://www.fieldtriptoolbox.org/ 
* [R] lm4 (version 1.1-18-1): https://cran.r-project.org/web/packages/lme4/lme4.pdf 

EEGLAB and Fieldtrip run entirely over Matlab. LMM-CBP also run from Matlab, but it connects with R (version 3.4.4) and lme4 package (version 1.1-18-1, Bates, et al. (2015) “Fitting linear mixed-effects models using lme4” Journal of Statistical Software 67, 1–48). This conection is made through bash scripts.


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

