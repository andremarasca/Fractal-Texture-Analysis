%% Carregar as configuracoes iniciais

load('ConfiguracoesIniciais.mat');
ConfigAplicacao = [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Configuracoes\', 'ConfiguracoesAplicacao.mat'];
load(ConfigAplicacao);
dir_DataSets_dessa_Base = [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\DataSets\'];
dir_class_dessa_Base = [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Class\'];
dir_otimizacao = [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Otimizacao\'];
mkdir(dir_otimizacao);
%% Definicoes iniciais

kfold = 10;%[0 2:20]%2 : 20

%% Calcula todos os raios discretos

RaiosDiscretos = CalculaTodosRaiosDiscretos(Rmax);

%%

n_atrib = length(RaiosDiscretos) - 1; % -1 por causa do 0
qtd_Camadas_analisadas = length(Camadas_analisadas);

n_atrib_Rates = zeros(qtd_Camadas_analisadas, 1);
Rates = zeros(qtd_Camadas_analisadas, 1);
Melhores_DataSets(qtd_Camadas_analisadas).X = [];

fprintf('Base: %s\n', nome_base);

% Para cada numero de camadas
for idx_Camadas_analisadas = 1 : length(Camadas_analisadas)
    fprintf('Numero de camadas: %g\n', Camadas_analisadas(idx_Camadas_analisadas));
    nome_Dataset = sprintf('%03d.mat', Camadas_analisadas(idx_Camadas_analisadas));
    load([dir_DataSets_dessa_Base, '\', nome_Dataset]);
    load([dir_class_dessa_Base, '\class', nome_base, '.mat']);
    Y = k;
    
    n_instancias = length(DataSet); % Numero instancias
    n_classes = length(unique(Y));
    [n_labels, n_atrib] = size(DataSet(1).VetLabel);
    

    Rate = zeros(1, n_atrib);
    
    for n_atrib_pl = 1 : n_atrib
        
        X = zeros(n_instancias, n_labels  * n_atrib_pl);
        for ini = 1 : n_instancias
            ia = 1;
            VetLabel = DataSet(ini).VetLabel;
            
            for inl = 1 : n_labels
                for ina = 1 : n_atrib_pl
                    X(ini, ia) = VetLabel(inl, ina);
                    ia = ia + 1;
                end
            end
        end
          
        X = log(X);
        
        Rate(n_atrib_pl) = ValidacaoCruzada_GENETICO(X, Y, kfold);
        fprintf('AtributosPorLabel: %g -> %02.2f\n', n_atrib_pl, Rate(n_atrib_pl));
    end
    
    [RateMax, n_atrib_RateMax] = max(Rate);
    
    fprintf('AtributosPorLabelMax: %g\n', n_atrib_RateMax);
    X = zeros(n_instancias, n_labels  * n_atrib_RateMax);
    for ini = 1 : n_instancias
        ia = 1;
        VetLabel = DataSet(ini).VetLabel;
        for inl = 1 : n_labels
            for ina = 1 : n_atrib_RateMax
                X(ini, ia) = VetLabel(inl, ina);
                ia = ia + 1;
            end
        end
    end

    X = log(X);
    
    n_atrib_Rates(idx_Camadas_analisadas) = n_atrib_RateMax;
    Rates(idx_Camadas_analisadas) = RateMax;
    Melhores_DataSets(idx_Camadas_analisadas).X = X;
end

[RateMaxGeral, idx_Camadas_RateMaxGeral] = max(Rates);
n_atrib_RateMax = n_atrib_Rates(idx_Camadas_RateMaxGeral);

X = Melhores_DataSets(idx_Camadas_RateMaxGeral).X;

%% Normalizacao

media_z_score = mean(X);
desvio_z_score = std(X);

[n_inst, ~] = size(X);
X = X - repmat(media_z_score, n_inst, 1);
X = X ./ repmat(desvio_z_score, n_inst, 1);

%% Gerar modelo e salvar

Modelo = fitcdiscr(X,Y); % Fit discriminant analysis classifier

save([dir_otimizacao, '\', 'Otimizacao.mat'], 'n_atrib_RateMax', 'idx_Camadas_RateMaxGeral','Modelo', 'media_z_score', 'desvio_z_score', 'RateMaxGeral');