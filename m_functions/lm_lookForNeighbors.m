function neighbours = lm_lookForNeighbors(chans)
    % elec.pnt -> N x 3 matrix -> electrode positions
    % elec.label - > 1 x N cell -> electrode label
    
    elec = [];
    elec.pnt    = [[chans.chanlocs.X]' [chans.chanlocs.Y]' [chans.chanlocs.Z]'];
    elec.label  = {chans.chanlocs.labels};

    cfg                 = [];
    cfg.method          = 'distance';
    cfg.elec            = elec;
    cfg.neighbourdist   = 0.40;

    neighbours = ft_prepare_neighbours(cfg);
    labels = {chans.chanlocs.labels};
    for i = 1:length(neighbours)

        neighbours(i).ind_neigh = cellfun(@(x) find(strcmpi(labels, x)), ...
                                          neighbours(i).neighblabel);

    end
end