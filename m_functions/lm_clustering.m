% lm_clustering(permToLoad, lm_Conf, chans)
% Inputs: 
%   permToLoad  = cell with the names of the models (subfolders of 
%                 lm_Conf.lmmOutPath) to clusterize
%
%   lm_Conf     = config struct from the toolbox
%
% Outputs:
%   clusters    = electro x time matrix with cluster indexes
%
%   pval        = pval of each cluster in "clusters"
%
% Children:
%   lm_cbpt.m
% 
% lm_clustering load matrices from lm_loadLmmData and clusterize both the
% original data matrix and the permutation matrices, performing the
% statistics for the clusters (i.e. maxSum)
%

function [clusters, pval] = lm_clustering(permToLoad, lm_Conf, chans)

    for iPerm=1:length(permToLoad)
        
        permType = permToLoad{iPerm};
        fprintf('Loading "%s" model\n', permType)
        
        load([lm_Conf.matricesLoadedPath '/' permType]);
        
        close all
        tails = {'neg', 'pos'};

        fields = fieldnames(values.t);
        
        for iVar = 1:length(fields)
            v = fields{iVar};
            
            fprintf('Startig to clurterize %s\n', v)
            
            % Results from data original 
            tval   = values.t.(v)(:, :, 1);
			% Results from permutations
            tval_r = values.t.(v)(:, :, 2:end);
            
            cfg.tail = 1;
            cfg.clusteralpha   = 0.05;
            
            if cfg.tail == -1
                tn = tails{1}; 
            else
                tn = tails{2}; 
            end
            
            [clusters.(v).(tn) pval.(v).(tn) sumMaxIter.(v).(tn)] = lm_cbpt(tval_r, tval, lm_Conf, chans);
        end
        
        save([lm_Conf.matricesLoadedPath '/clustersNum_' permType], 'clusters')
        save([lm_Conf.matricesLoadedPath '/pvalsClust_' permType], 'pval')
    end
    fprintf('Finished all the clusterizations\n')
end
