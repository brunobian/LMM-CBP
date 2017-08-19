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


function lm_Conf = lm_exportErpCsv(data, coVarNames, EEG, su, sep, lm_Conf)
%%    
try
    fprintf('Exporting EEG data from subject %0.0f to CSV \n', su)
    
    pth = lm_Conf.csvPath;
    
    % Generate one file per time sample
    lm_Conf.nTimes = size(EEG.times,2);
    for iTime = 1:lm_Conf.nTimes 
        filename = [pth '/t' num2str(iTime) '.csv'];    
        
        % Generate header, only for the firts subject 
        if su == 1
            % Generate eletrode-columns' names
            e = strjoin(sep,arrayfun(@(x) ['E' num2str(x)], 1:128, ...
                                     'UniformOutput', false));
            
            % Generate the header with the the time as last column
            header =  [coVarNames, sep, 'time', sep, e];

            % Generate the file and write header
            fid = fopen(filename, 'w+', 'n', 'UTF-8');
            fprintf(fid, '%s\n', header);
            fclose(fid);
        end

        amp   = squeeze(EEG.data(:, iTime, :))';
        times = repmat(EEG.times(iTime), length(amp), 1);

        % Convert amp to string.
        amp  = num2str(amp);

        % Open the file in addition mode
        fid = fopen(filename, 'a+', 'n', 'UTF-8');
        for iAmp = 1:size(amp,1)
            % Convert spaces into sep
            ThisAmpLine = regexprep(amp(iAmp,:), ' +', sep);
            
            % Delete starting and ending sep
            if strcmpi(ThisAmpLine(1), sep); ThisAmpLine(1) = ''; end

            % Generate data str separated by sep
            thisDataLine = [];
            thisDataLine = cellfun(@(x) [thisDataLine x(iAmp,:) sep], ...
                           data, 'UniformOutput', false);
            thisDataLine = [thisDataLine{:}];
            
            % Generate the full row with the time and amplitudes
            finalStr = [thisDataLine, num2str(times(iAmp)), sep, ThisAmpLine];

            % Save
            fprintf(fid,'%s \n', finalStr);
        end
        fclose(fid);

    end
catch ME
    keyboard
end
end
