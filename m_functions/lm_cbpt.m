% [clusters_out pval] = permutation_lmer(tval_r, tval)
% Input:
%       tval_r:     channels x times x number of permutations.
%                   t-values obtained from the shuffled data.
%
%       tval:       channels x times. t-values obtained with the real data.
%
%       lm_Config:  configuration structure of the whole toolbox
%
%       chans:      structure with information of the electrode
%                   distribution
%
% Outputs:
%       clustersOut: Significant clusters.
%       pval:         p-values of the significant clusters.
%
% Children
%       lm_percolation.m
%       lm_followET.m
%       lm_completePercolaciones.m
%
%
% - For each randomization ([1:lm_Config.numrandomization])
%   - Start from the first electrode (ie=1) and time (it=1)
%   - If I didn't checked it (isNaN):
%       - If non significant -> percolMat(ie,it) = 0.
%       - If significant     -> Start percolation
%         - This first percolation have 3 outputs:
%           - percolMat: where I mark (ie,it) checked samples
%               - If (ie,it) has no sign. neighbors -> percolMat(ie,it) = 0
%               - If (ie,it) has sign. neighbors    -> percolMat(ie,it) = N
%           - Start following significant neighbors
%
% - From now, I follow significant neighbors with lm_followET.m
%     - Start with all the electrodes and mark all the significant ones
%     - For each significant electrode, look for significant times
%
% - When the cluster is over (no mor neighbors), N = N + 1
%
% - Calculate MaxSum of this permutation with lm_maxSum.m
%
%
% 2017-01-10 Bruno Bianchi
% 2017-01-12 Juan Kamienkowski. cfg was included as new optional input.

function [clusters_out, pval, thisSumMaxIter] = lm_cbpt( tval_r, tval, ....
                                                        lm_Conf, chans)


%% Inicializo las variables de cfg

if ~isfield(lm_Conf,'clustertail')
    lm_Conf.clustertail = 0;    % Creo que no lo estamos usando
end
if ~isfield(lm_Conf,'tail')
    lm_Conf.tail = 1;           % negative tail: -1,
                                % possitive tail: 1 (defaul)
                                % both tails:     0 (not implemented)
end
if ~isfield(lm_Conf,'alpha')
    lm_Conf.alpha = 1.86;      % alpha level of the permutation test
                            % This is not p-value (0.05) like in FieldTrip,
                            % but t-values.

end

% checkOrDefault(lm_config.numrandomization, size(tval_r, 3))

if ~isfield(lm_Conf,'numrandomization')
    % Number of draws from the permutation distribution
    lm_Conf.numrandomization = size(tval_r,3);
end
if ~isfield(lm_Conf,'clusterstatistic')
    % Test statistic that will be evaluated under the permutation distribution.
    % 'maxsum' is the only one implemented
    lm_Conf.clusterstatistic = 'maxsum';
end
if ~isfield(lm_Conf,'clusteralpha')
    % alpha level for significant clusters selection in the maxsum
    % distributions.
    lm_Conf.clusteralpha   = 0.05;
end
if ~isfield(lm_Conf,'minnbchan')
    % minimum number of neighborhood channels that is required for a
    % selected sample to be included in the clustering algorithm.
    lm_Conf.minnbchan = 2;
end
if ~isfield(lm_Conf,'minnbtime')
    % minimum number of neighborhood times that is required for a
    % selected sample to be included in the clustering algorithm.
    lm_Conf.minnbtime = 1;
end
if lm_Conf.tail == 1
    alpha = 1-lm_Conf.clusteralpha;
elseif lm_Conf.tail == -1
    alpha = 1-lm_Conf.clusteralpha;
else
    fprintf('ERROR: lm_config.tail -> have to be 1 o -1')
end



%% 2. Binarize t-vals (NS = 0 | S = 1)
% No matter wich tail, allways possitive
tval_r = tval_r * lm_Conf.tail;
tval   = tval   * lm_Conf.tail;

tvalRSig = tval_r > lm_Conf.alpha ;

%% 3 - 4 - 5. Run percolations and performe cluster statistics
% 3. Search for clusters
% 4. Calculate Sum of each cluster from each permutation
% 5. Calculate MaxSum of each permutaion

% Look for neighbors
nhbr = lm_lookForNeighbors(chans);

thisSumMaxIter = [];
for iter = 1:lm_Conf.numrandomization
    fprintf('Percolation %d of %d \n', iter, lm_Conf.numrandomization)

    thisIter                = tvalRSig(:,:,iter);
    [percolMat, N]         = lm_completePercolations(thisIter, nhbr, lm_Conf);
    thisSumMaxIter(iter)    = lm_maxSum(tval_r, iter, percolMat, N, lm_Conf);
end

maxsum_perm = quantile(thisSumMaxIter, alpha);

%% 6. Busco clusters para los datos posta (repito 1-4)
tval_sig = tval > lm_Conf.alpha;
[percolMat, N] = lm_completePercolations(tval_sig, nhbr, lm_Conf);

sums = [];
for iN = 1:N
    sums(iN) = sum(tval(percolMat == iN));
end


%% 7. Busco clusters significativo
clusters_out    = zeros(size(percolMat));
cluster_sig     = find(sums >= maxsum_perm);

N = length(cluster_sig);
pval = nan(N,1);
c = 1;
for i = 1:N
    inds_sign = percolMat == cluster_sig(i);
    if sum(sum(inds_sign,2)>0) > 1 % Chequeo que un cluster esté formados
                                   % por al menos 2 electrodos
        clusters_out(inds_sign) = i;
        pval(c) = sum(sums(cluster_sig(i)) < thisSumMaxIter) / length(thisSumMaxIter);
        c = c+1;
    end
end




end
