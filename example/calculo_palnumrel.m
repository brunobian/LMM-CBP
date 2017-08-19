function DATA = calculo_palnumrel(DATA)
    for ind_DATA = 1:length(DATA)
        DATA(ind_DATA).indOrac = repmat(DATA(ind_DATA).ind, ...
                                        1, length(DATA(ind_DATA).palabras));
        if DATA(ind_DATA).tipo == 0
            DATA(ind_DATA).palnum_rel = DATA(ind_DATA).palnum - ...
                                        DATA(ind_DATA).indMaxJump;
            DATA(ind_DATA).palnum_rel_final = nan(1,length(DATA(ind_DATA).palnum));

        else
            DATA(ind_DATA).palnum_rel = nan(1,length(DATA(ind_DATA).palnum));
            DATA(ind_DATA).palnum_rel_final = DATA(ind_DATA).palnum - ...
                                              DATA(ind_DATA).palnum(end);
        end
    end
end