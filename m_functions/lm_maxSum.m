function sumMaxIter = lm_maxSum(tval_r, iter, percol_mat, N, cfg)
    
    if strcmpi(cfg.clusterstatistic, 'maxsum')
        this_iter_vals = tval_r(:,:,iter);
        sums = [];
        for iN = 1:N
            sums(iN) = sum(this_iter_vals(percol_mat == iN));
        end

        sumMaxIter = max(sums);
    else
        fprinf('ERROR: Check for clusters statistics\n')
        return
    end
    
end
