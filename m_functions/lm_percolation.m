%  [etFollow, percolMat] =  lm_percolation(percolMat, nhbr, ...
%                                          iEiT, thisPerm, ...
%                                          clusterId, etFollow, ...
%                                          cfg)
%
% perform a simple percolation starting in one index of time and electrode
% and return wich samples to follow up
%
% Inputs:
%       percolMat: Matrix with percolations results 
%
%       nhbr:      Neighbors matrix from lm_lookForNeighbors
%
%       iEiT:      Sample to start with
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

function [etFollow, percolMat] =  lm_percolation(percolMat, nhbr, ...
                                                 iEiT, ...
                                                 tvalsSig, ...
                                                 clusterId, ...
                                                 etFollow, ...
                                                 lm_Config)
    ie = iEiT(1);
    it = iEiT(2);
    if isnan(percolMat(ie,it)) && tvalsSig(ie,it)
        
        % search for spatial neighbors
        iNhbElec = nhbr(ie).ind_neigh;
        NhbElec  = tvalsSig(iNhbElec,it);

        % search for time neighbors (first and last are spetial cases)
        if it == 1 
            iNhbTime = it+1;
            elseif it == 2 
                iNhbTime = [it+1 it+2];
            elseif it == 3 
                iNhbTime = [it+1 it+2 it+3];
        elseif it == size(tvalsSig,2)
            iNhbTime =  it-1;
            elseif it == (size(tvalsSig,2)-1)
                iNhbTime = [it-2 it-1];
            elseif it == (size(tvalsSig,2)-2)
                iNhbTime = [it-3 it-2 it-1];
        else
            iNhbTime = [it-1,it+1];
            iNhbTime = [it-3,it-2,it-1,it+1,it+2,it+3];
        end
        NhbTime = tvalsSig(ie,iNhbTime);

        % Check if they form a cluster
        if sum(NhbTime) >= lm_Config.minnbtime || ...
           sum(NhbElec) >= lm_Config.minnbchan
            
            % Tag sample as part of this cluster
            percolMat(ie,it) = clusterId; 

            % look for all the nhb tuples
            T = iNhbTime(logical(NhbTime));
            newET = [];
            for i = 1:length(T)
                v = [ie, T(i)];
                if isnan(percolMat(v(1), v(2))) && tvalsSig(v(1), v(2))
                    newET = [newET; v];
                end
            end
            
            E = iNhbElec(logical(NhbElec));
            for i = 1:length(E)
                v = [E(i), it];
                if isnan(percolMat(v(1), v(2))) && tvalsSig(v(1), v(2))
                    newET = [newET; v];
                end
            end
            
            etFollow = [etFollow; newET];
        else
            % Tag as no-cluster sample
            percolMat(ie,it) = 0; 
        end
    end
end


                