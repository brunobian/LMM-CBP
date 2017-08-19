% [percol_mat N] = lm_completePercolations(tvalsSig, nhbr, lm_Config)
%
% Inputs:
%       tvalsSig:   Matrix of binarize t_values of present permutation
%
%       nhbr:       Neighbors structure from lm_lookForNeighbors
%
%       lm_Config:  Configuration matrix of the toolbox
%
% Outputs:
%       percolMat:  Percolation matrix with [0:N] 
%
%       clusterId:  Number of clusters in the tvalsSig
% 
% Children:
%       lm_percolation.m 
%       lm_followET.m
%
% Percolations
%   - Start from the first electrode (ie=1) and time (it=1)
%   - If I didn't checked it (isNaN):
%       - If non significant -> percolMat(ie,it) = 0.
%       - If significant     -> Start percolation
%         - This first percolation have 2 outputs:
%           - percolMat: where I mark (ie,it) checked samples
%               - If (ie,it) has no sign. neighbors -> percolMat(ie,it) = 0
%               - If (ie,it) has sign. neighbors    -> percolMat(ie,it) = N
%           - etFollow: electrode-time samples to follow
%
%   - Use etFollow to start again the percolations for each neighbor sample
%
% 2017-01-10 Bruno Bianchi

function [percolMat, clusterId] = lm_completePercolations(tvalsSig, nhbr, lm_Config)
    percolMat = nan(size(tvalsSig));
    clusterId = 1;
    for ie = 1:size(tvalsSig,1)
        for it = 1:size(tvalsSig,2)
            noTag = isnan(percolMat(ie,it)); % Does it has tag?
            isSign    = tvalsSig(ie, it);    % Is it significant?
            
            if noTag && ~isSign % If both NO, then:
                percolMat(ie,it) = 0;            
            elseif noTag && isSign % If noTag, and sign -> percolation
                etFollow = [];
                iEiT = [ie it];
                % First percolation for this (ie it)
                [etFollow, percolMat] = lm_percolation( percolMat, ...
                                                        nhbr, ...
                                                        iEiT, ...
                                                        tvalsSig, ...
                                                        clusterId,...
                                                        etFollow, ...
                                                        lm_Config);

                
                % Keep running percolation for each possible nhbr 
                while ~isempty(etFollow)
                    [etFollow, percolMat] = lm_FollowET(percolMat,...
                                                        nhbr, ...
                                                        tvalsSig, ...
                                                        clusterId , ...
                                                        etFollow, ...
                                                        lm_Config);               
                end
                clusterId = clusterId+1;
            end
        end
    end
end