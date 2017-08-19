function [filtro_gramatical, filtro_voltaje, data_filtros, indbadepoch] = filtro(DATA, EEG, su)

    % Elimino epochs con los siguientes criterios:
       % Voltaje mayor a 80 en mas de 5 electrodos
       % Stopwprds
       % Pals de menos de 2 letras
       % Primera palabra
    data_filtros = [];   
    stopwords = 'tcisrRdpm'; 

    filtro_gramatical = ismember([DATA.catsimple], stopwords) | ...
                        [DATA.length] <=  2 | ...
                        [DATA.palnum] == 1;


    volt  = abs(EEG.data) > 60;  % Miro qué valores superan los 60uV
    sum_t = sum(volt, 2);         % Sumo en la dimensión tiempo
    sum_e = sum(sum_t > 0, 1);    % Sumo en la dimensión electrodos
    filtro_voltaje = (squeeze(sum_e) > 5)'; % Trials con +5 electrodos

    indbadepoch = filtro_voltaje | filtro_gramatical;

    data_filtros.n_voltaje(su)    = sum(filtro_voltaje & ~filtro_gramatical);
    data_filtros.n_gramatical(su) = sum(filtro_gramatical);
    data_filtros.n_total(su)      = sum(indbadepoch);

    % Éste índice lo uso para incluir, me quedo con el complemento
    indbadepoch = ~indbadepoch;


end
