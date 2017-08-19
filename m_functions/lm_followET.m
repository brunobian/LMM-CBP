% function [etFollow, percolMat] = lm_followET(percolMat, ...
%                                              nhbr, ...
%                                              tvalsSig, ...
%                                              clusterId, ...
%                                              etFollow, ...
%                                              lm_Config)
%
% Inputs:
%       percolMat: Matrix with percolations results 
%
%       nhbr:      Neighbors matrix from lm_lookForNeighbors
%
%       tvalsSig:  Matrix of binirize t-values 
%
%       clusterId: Current cluster id
%
%       etFollow:  indexes of possible Elect-Times samples of the cluster
%
%       lm_Config: Configuration matrix of the toolbox
%
% Outputs:
%       etFollow:  indexes of possible Elect-Times samples of the cluster
%
%       percolMat: Matrix with percolations results 
%
% Children:
%       lm_percolation.m
%
% lm_followET 
% take a vector of tuples and perform percolation for each tuple, 
% storing possible new samples for the cluster, until the vector is
% empty.
                                            
function [etFollow, percolMat] = lm_followET(percolMat, ...
                                             nhbr, ...
                                             tvalsSig, ...
                                             clusterId, ...
                                             etFollow, ...
                                             lm_Config)
                                                  
    while ~isempty(etFollow)
        iEiT = etFollow(1,:);
        [etFollow, percolMat] = lm_percolation(percolMat, nhbr, ...
                                                 iEiT, ...
                                                 tvalsSig, ...
                                                 clusterId, ...
                                                 etFollow, ...
                                                 lm_Config);
          etFollow   = etFollow(2:end,:);
    end
    
end