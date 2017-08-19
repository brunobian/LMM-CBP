%% Define path and open EEGlab
clc
clear all
close all
lm_Conf = struct();
lm_Conf.path = '~/Documentos/Repos/CuBaPeTo/';
lm_Conf.eeglabpath  = '/home/brunobian/Documentos/toolbox/eeglab11_0_3_1b';
lm_Conf.custonFc = './cstfuns';

cd([lm_Conf.path 'example/'])
addpath(genpath(lm_Conf.path))
addpath(genpath(lm_Conf.custonFc))
[lm_Conf, SUJ]= definePath(lm_Conf);
%% Load data from subjects and export to CSV
lm_Conf.csvPath = [lm_Conf.path 'example/csv/'];
for iSuj = 1:length(SUJ)
    
    % Load EEGLab matrix with information from the experiment into DATA
    load(SUJ(iSuj).fileName)  

    
    sep = ';';
    [dataParaCsv, coVarNames] = generateDataForCsv(DATA, EEG, ...
                                                        indbadepoch, ...
                                                        iSuj, sep);

    lm_Conf = lm_exportErpCsv(dataParaCsv, coVarNames, ...
                              EEG, iSuj, sep, lm_Conf);    


end
fprintf('Done\n')
%% Run LMM with nIter and nCores permutations across both ranEf

fixEf   = 'freq + pred + palnum';
ranEf   = '(1|pal) + (1|suj_id)';
nIter   = 2;
modType = 'lmm';
nCores  = 4;
lm_Conf.lmmOutPath            = [lm_Conf.path 'example/LMM/results/'];
lm_Conf.nohupOutPath          = [lm_Conf.path 'example/LMM/nohupOutputs/'];
lm_Conf.customFunsPath        = [lm_Conf.path 'example/'];     
lm_Conf.rFunctionsPath        = [lm_Conf.path '/R_functions/'];
lm_Conf.bashPath              = [lm_Conf.path '/bash_functions/'];
lm_Conf.permutationMatPath    = [lm_Conf.path 'example/LMM/permutations/']; 
lm_Conf.permutationVariable   = 'across';

lm_parallelRunLMM(fixEf, ranEf, nIter, modType, nCores, lm_Conf)

%% Load data from LMM

permToLoad = {lm_Conf.permutationVariable};

lm_Conf.matricesLoadedPath = [lm_Conf.path 'example/LMM/matrices/'];
values = lm_loadLmmData(permToLoad, lm_Conf);
load coords_LNI_128_toreplaceinEEG

lm_Conf.tail = 1;
lm_Conf.clusteralpha   = 0.05;
lm_clustering(permToLoad, lm_Conf, CHANS)




