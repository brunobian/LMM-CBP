# LMM-CBP code

Code for running cluster-based permutation test on EEG data using fieldtrip toolbox for Matlab and lme4 for R. The interaction between both programs depends on bash code implemented in Linux. This code allows to parallelize in different cores of one computer and in different computers.

This code consist in functions for exporting fieldtrip structures into CSV format, which could be easily imported in R.

# Structure

- **LMM-CBP/**: library
  - **bash_functions/**: functions for the interaction between Matlab and R
    - **run_models.sh**: 
    - **runParallelCluster.sh**: 
    - **runParallelCores.sh**: 

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
    - **complete_run.R**
    - **generateIterMatrix.R**
    - **lmmElecTime.R**
    - **completeRun.R**
    - **lmElecTime.R**
    - **lmmTimeWindow.R**
 
  - **example/**: 



# Dependencies

- Matlab: fieldtrip
- R: lme4
- bash

# Usage

## Exporting data

For creating the corpus:
```bash
cd corpus
make
```

For creating the tagged corpus execute this Makefile with the target *tagged_corpus*: 
```bash
make tagged_corpus
```

## Training

To train the n-grams models from the corpus (*corpus/corpus_cleaned_normalized.txt*) execute

```bash
sh train_ngrams.py n
```

This will generate the file *models/n-gram.lm.gz* 

## Calculating predictions

Once you have the models trained you can execute *predictor_tables.py*. For example if we want the predicitons of the 2-gram and 3-gram for the texts 1, 2 and 3 (There is no text 6), and store it in a file named TABLE then you can execute:

```bash
python predictor_tables.py -ngram_predictor_orders 2 3 -text_numbers 1 2 3 -fileout TABLE
```

This will store it in a csv file, which you can use it to plot the correlations with the predictions of the humans (cloze):

```bash
python analyze_table.py < TABLE
```

Many of these scripts have a flag for a description of the parameters using the flag *-h*.

## Entropy

Yo can use the *predictor_tables.py* script with the flag *-entropy* and it will output the entropy instead of the probabilities (Now this works only for HumanPredictor, because for n-grams it takes too long).

For calculating the entropy of n-grams (without or without cache):

- First you have to obtain the conditional probability distribution at the targets of a text (e.g. text number 1):

```bash
python print_distributions -text_number 1 -ngram_predictor_order 4 -output_filename DIST_4gram_text1
```

- Then you can use the ** script for calculating the entropy at each target:

```bash
python calculate_entropy_from_conditional_distributions.py -filename DIST_4gram_text1
```

This will output for each target the target word, the entropy, the entropy using only the top 10 predicitions and then the top 10 predictions.

- If you want to calculate the entropy interpolating with you can do it with the appropiate flags:

```bash
python calculate_entropy_from_conditional_distributions -filename DIST_4gram_text1 -calculate_with_cache -cache_text_number 1 -cache_lambda 0.22
```

## Factored Language Models

### Training

After you have a tagged corpus (*corpus/factored_corpus_WGNCPL.txt*), you can train all the models in *flm_models* executing:

```bash
python train_all_flm_models.py
```

And this will generate a script called *train_all_models.sh*, which you can edit at your convenience and then execute it:

```bash
./train_all_flm_models.sh
```

### Calculating predictions

If you want to calculate the predictions using the model in *flm_models/bigramWN.flm* for the texts 1, 2 and 3, and store it in a file named TABLE then you can execute:

```bash
python predictor_tables.py -flm_model_filenames flm_models/bigramWN.flm text_numbers 1 2 3 > TABLE
```

An this will generate the predictions as in the n-gram models case.
