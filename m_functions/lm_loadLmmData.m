% lm_loadLmmData load R outputs of LMM runs to matlab matrices
%
% permToLoad = cell with the names of the models (folders) to load
%
% lm_Conf = config struct from the toolbox

function values = lm_loadLmmData(permToLoad, lm_Conf)


for iPerm = 1:length(permToLoad)
    permType = permToLoad{iPerm};
    fprintf('Loading "%s" model\n', permType)

    lmmPathPerm = [lm_Conf.lmmOutPath permType '/' ];

    permFiles = dir(lmmPathPerm);
    fileNames = {permFiles(3:end).name}; % 2 first values are . and ..

    % Generate empty strcuts
    values = struct; values.t = struct; values.p = struct; 
    values.AIC = struct;

    % Load permutation results
    for iFile = 1:length(fileNames)
    try
        % identify wich type of file is loading and split names
        thisName = fileNames{iFile};
        t_val = csvread([lmmPathPerm thisName])';

        if strcmpi(thisName(end-3:end),'.txt') || ...
           strcmpi(thisName(end-3:end),'.csv')
            thisName = thisName(1:end-4);
        end
        splited = regexp(thisName,'_','split');

        val = splited{1};
        % Slopes or t_vals
        if ismember(val, 'pt')     
            if ismember('common', splited) || ismember('proverb', splited)
                vari = [splited{2} '_' splited{3}];
                iTime= splited{4}; 
            else
                vari = splited{2};
                vari = regexprep(vari, '(', '');
                vari = regexprep(vari, ')', '');
                vari = regexprep(vari, '\$', '_');
                vari = regexprep(vari, 'sntType-0.5', 'prov');
                vari = regexprep(vari, 'sntType0.5', 'common');
                iTime= splited{3}; 
            end
        elseif strcmpi('AIC', val) % AIC
            iTime  = splited{2}; 
            vari   = 'AIC';
        else 
            fprintf('No se cargó un archivo correcto %f\n', iFile)
            return
        end
        iTime = str2double(iTime(2:end));

        sizeVals   = size(t_val);

        if ~any(strcmpi(vari, fieldnames(values.(val))))
            nFiles   = lm_Conf.nTimes;             
            values.(val).(vari) = nan(sizeVals(1), nFiles, sizeVals(2));
        end
        
        values.(val).(vari)(:, iTime, :) = reshape(t_val, ...
                                                   [sizeVals(1), ...
                                                   1, ...
                                                   sizeVals(2)]);

    catch ME
        keyboard
    end
    end
    save([lm_Conf.matricesLoadedPath '/' permType], 'values')
end
    fprintf('Finished model loading\n')

end