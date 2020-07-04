function [lm_Conf, SUJ]= definePath(lm_Conf)

    addpath(genpath(lm_Conf.eeglabpath),'-end');
    
    tmp = dir([lm_Conf.datapath  '/*.mat']); 
    fileNames = {tmp.name};
    
    SUJ = [];
    for i=1:length(fileNames)
        splitStr = regexp(fileNames{i},'\.','split');
        
        SUJ(i).sujName  = splitStr{1};
        SUJ(i).fileName = fileNames{i};
    end
    
    eeglab
end