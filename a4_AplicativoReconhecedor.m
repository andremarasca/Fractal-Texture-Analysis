% close all;
% close all hidden;
% close all force;
% clear all;
% clc;

load('ConfiguracoesIniciais.mat');
ConfigAplicacao = [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Configuracoes\', 'ConfiguracoesAplicacao.mat'];
load(ConfigAplicacao);

dir_Testes = [diretorio_principal, '\', nome_base, '\Testes\'];
dir_class = [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Class\'];
dir_otimizacao = [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Otimizacao\'];
load([dir_otimizacao, 'Otimizacao.mat']);

load([dir_class, 'NomeClasses.mat']);

%% Tipos possiveis de imagens

ti(1).nome = '.png';
ti(2).nome = '.bmp';
ti(3).nome = '.jpg';

%% Testa imagens de teste, uma por uma

% Listagem das pastas de bruto
FIG = zeros(tam_sub_figuras, tam_sub_figuras, 3);

% descobre as imagens de todos os tipos
files = [];
for iti = 1 : length(ti)
    files_ti = dir([dir_Testes, '*', ti(iti).nome]);
    files = [files; files_ti];
end

RaiosDiscretos = CalculaTodosRaiosDiscretos(Rmax);

%%%%% Varrer todos as imagens de teste

for x = 1 : length(files)
    disp(files(x).name);
    I = imread([dir_Testes files(x).name]);
    I = imresize(I, escala_imagem_original);
    [M, N, L] = size(I);
    Mdiv = floor(M / tam_sub_figuras);
    Ndiv = floor(N / tam_sub_figuras);
    Mini = floor((M - Mdiv * tam_sub_figuras)/2);
    Nini = floor((N - Ndiv * tam_sub_figuras)/2);
    
    clearvars DataSetTeste;
    nfig = 1;
    for u = 1 : Mdiv
        for v = 1 : Ndiv
            for i = 1 : tam_sub_figuras
                for j = 1 : tam_sub_figuras
                    for k = 1 : L
                        FIG(i, j, k) = I(round(tam_sub_figuras * (u - 1) + i + Mini), round(tam_sub_figuras * (v - 1) + j + Nini), k);
                    end
                end
            end
            
            % Extrair as caracteristicas de cada subfigura
            
            disp(nfig);
            
            VetLabel = ChamaEDT(FIG, Camadas_analisadas(idx_Camadas_RateMaxGeral), Rmax);
            VetLabel = Filtro_Raio_Descritores(VetLabel, RaiosDiscretos);
            DataSetTeste(nfig).VetLabel = VetLabel;
            
            
            nfig = nfig + 1;
            
            if nfig > N_sub_fig_analisadas
                break;
            end
        end
        if nfig > N_sub_fig_analisadas
            break;
        end
    end
    
    n_instancias = length(DataSetTeste); % Numero instancias
    [n_labels, n_atrib] = size(DataSetTeste(1).VetLabel);
    
    Rate = zeros(1, n_atrib);
    
    fprintf('AtributosPorLabel: %g\n', n_atrib_RateMax);
    X = zeros(n_instancias, n_labels  * n_atrib_RateMax);
    for ini = 1 : n_instancias
        ia = 1;
        VetLabel = DataSetTeste(ini).VetLabel;
        
        for inl = 1 : n_labels
            for ina = 1 : n_atrib_RateMax
                X(ini, ia) = VetLabel(inl, ina);
                ia = ia + 1;
            end
        end
    end
    
    X = log(X);
    
    [n_inst, ~] = size(X);
    X = X - repmat(media_z_score, n_inst, 1);
    X = X ./ repmat(desvio_z_score, n_inst, 1);
    
    [Yteste,score,cost] = predict(Modelo, X);
    [MM, NN] = size(score);
    
    if MM > 1
        score = sum(score) / MM;
    end
    
    [Probabilidade_classificacao, idx_class] = max(score);
    Probabilidade_classificacao = round(Probabilidade_classificacao * 100);
    
    classe = NomeClasses(idx_class).nome;
    disp(classe);
    
    %% renomear
    
    tipo_figura = files(x).name;
    idx_pontos = find(tipo_figura == '.');
    tipo_figura = tipo_figura(idx_pontos(end) : end);
    
    comando = sprintf('ren "%s%s" " %s (%d%%) %s"', dir_Testes, files(x).name, classe, Probabilidade_classificacao, files(x).name);
    comando(find(comando == '/')) = '\';
    system(comando);
    
end
