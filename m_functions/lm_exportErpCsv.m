% lm_exportErpCsv   export EEGlab samples and data from the experiment to 
%                   one CVS per time sample for all the subjects. 
%
% data =    M-by-N str cell with N co-variables to analyze in the LMM and 
%           and N trials. 
%
% coVariableNames = str with the names of the co-variables in data
%                   separeted by sep
%
% EEG  =    EEGLab struct
%
% su   =    subject id. This function have to be run subject by subject
%
% sep =     Desire separator for the CSV
%
% lm_Conf = config struct from the toolbox


function lm_Conf = lm_exportErpCsv(data, EEG, su, sep, lm_Conf)
%%    
try
    fprintf('Exporting EEG data from subject %0.0f to CSV \n', su)
    pth = lm_Conf.csvPath;

    cols= arrayfun(@(x) ['E' num2str(x)], 1:size(EEG.data,1), ...
                                 'UniformOutput', false);
    fn_tmp = [pth '/tmp.csv'];    

    % Generate one file per time sample
    lm_Conf.nTimes = size(EEG.times,2);
    for iTime = 1:lm_Conf.nTimes 
        filename = [pth '/t' num2str(iTime) '.csv'];    
        
        amp = array2table(squeeze(EEG.data(:, iTime, :))',...
            'VariableNames', cols);

        times = table(repmat(EEG.times(iTime), size(amp,1), 1), ...
                      'VariableNames',{'time'});
        
        T = [times data amp];

        if su == 1
            writetable(T, filename, 'Delimiter', sep)
        else
            writetable(T,  fn_tmp, 'WriteVariableNames', 0, 'Delimiter', sep)
            system(['cat ' fn_tmp ' >> ' filename]);
        end
    end
    
catch ME
    keyboard
end
if su ~= 1
    system(['rm ' fn_tmp]);
end
end
