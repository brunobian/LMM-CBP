function [BL_range, ERP, data_filtros, win, dist] = initialize_variables()

    BL_range = [-75 25];
    ERP = []; 
    data_filtros = [];
    
    win = [];
    
    % Calculado a partir de los topoplots
    win.P200r.time  = [200 300];
    win.P200r.elect = [36:45];
    
    win.P200l.time  = [200 300];
    win.P200l.elect = [7:12 125:128];
    
    win.N400.time   = [300 450];
    win.N400.elect  = [1:6 17:21 30:35 50:53  65 66 87 97 98 110:114 124];
    win.N400.elect  = [1:6 18:20 31:35 50:53  66 87 97 98 110:114 124];


    win.P600.time   = [500 650];
%     win.P600.time   = [600 700];
    win.P600.elect  = [3:9 16:22 29:32 34:38 44 45 47:51 112 113 121:126];
    win.P600.elect  = [3:9 16:22 29:32 35:38 44 45 125:126];
    
    
    dist.pred.preMJ_p = [];
    dist.pred.posMJ_p = [];
    dist.freq.preMJ_p = [];
    dist.freq.posMJ_p = [];
    dist.pos.preMJ_p  = [];
    dist.pos.posMJ_p  = [];
    dist.pred.preMJ_r = [];
    dist.pred.posMJ_r = [];
    dist.freq.preMJ_r = [];
    dist.freq.posMJ_r = [];
    dist.pos.preMJ_r  = [];
    dist.pos.posMJ_r  = [];
end