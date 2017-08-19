function [lm_Conf, SUJ]= defino_path(lm_Conf)

    eeglabpath  = '/home/brunobian/Documentos/toolbox/eeglab11_0_3_1b';
    addpath(genpath(eeglabpath),'-end');
    
    lm_Conf.datapath  = [lm_Conf.path 'example/data_ex/']; 
    
    
    tmp = dir([lm_Conf.datapath  '/*.mat']); 
    fileNames = {tmp.name};
    
    SUJ = [];
    for i=1:length(fileNames)
        splitStr = regexp(fileNames{i},'_','split');
        splitStr = regexp(splitStr{2},'\.','split');
        
        SUJ(i).sujName  = splitStr{1};
        SUJ(i).fileName = fileNames{i};
    end
    
    eeglab
end