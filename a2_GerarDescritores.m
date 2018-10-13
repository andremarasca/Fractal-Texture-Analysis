%% Carregar as configuracoes iniciais

load('ConfiguracoesIniciais.mat');
ConfigAplicacao = [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Configuracoes\', 'ConfiguracoesAplicacao.mat'];
load(ConfigAplicacao);

nome_base_saida = [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\DataSets\'];
mkdir(nome_base_saida);
nome_base_saida = [nome_base_saida, '%03d.mat'];
nome_base_saida(nome_base_saida == '\') = '/';

%% Tipos possiveis de imagens

ti(1).nome = '.png';
ti(2).nome = '.bmp';
ti(3).nome = '.jpg';

%% Calcula todos os raios discretos

RaiosDiscretos = CalculaTodosRaiosDiscretos(Rmax);

%% Análise de textura


fprintf('Base: %s\n', nome_base);
dir_base = [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Base\'];
% Obter imagens de todos os tipos
files = [];
for iti = 1 : length(ti)
    files_ti = dir([dir_base, '*', ti(iti).nome]);
    files = [files; files_ti];
end
% Para cada numero de camadas, percorrer todos os arquivos
for N_Camadas = Camadas_analisadas
    fprintf('Numero de camadas: %g\n', N_Camadas);
    clearvars DataSet;
    for x = 1 : length(files)
        disp(x);
        I = imread([dir_base files(x).name]);
        [M, N, ~] = size(I);
        VetLabel = ChamaEDT(I, N_Camadas, Rmax);
        VetLabel = Filtro_Raio_Descritores(VetLabel, RaiosDiscretos);
        DataSet(x).VetLabel = VetLabel;
    end
    % salvar DataSet dentro de sua devida pasta
    nome_saida = sprintf(nome_base_saida, N_Camadas);
    save(nome_saida, 'DataSet');
end

a3_CalculaRateAutomatico;