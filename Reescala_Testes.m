% close all;
% close all hidden;
% close all force;
% clear all;
% clc;

load('ConfiguracoesIniciais.mat');
ConfigAplicacao = [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Configuracoes\', 'ConfiguracoesAplicacao.mat'];
load(ConfigAplicacao);

tam = Tam_Dim_min_reescala;

dir_Testes = [diretorio_principal, '\', nome_base, '\Testes\'];

%% Tipos possiveis de imagens

ti(1).nome = '.png';
ti(2).nome = '.bmp';
ti(3).nome = '.jpg';

%% Testa imagens de teste, uma por uma

% descobre as imagens de todos os tipos
files = [];
for iti = 1 : length(ti)
    files_ti = dir([dir_Testes, '*', ti(iti).nome]);
    files = [files; files_ti];
end

%% Teste tmp

dir_Testes_TMP = [diretorio_principal, '\', nome_base, '\Testes_TMP\'];
if exist(dir_Testes_TMP)
    rmdir(dir_Testes_TMP, 's')
end
mkdir(dir_Testes_TMP);

%%%%% Varrer todos as imagens de teste

for x = 1 : length(files)
    disp(files(x).name);
    I = imread([dir_Testes files(x).name]);
    [M, N, L] = size(I);
    escala = tam / min(M, N);
    I = imresize(I, escala);
    idx_pontos = find(files(x).name == '.');
    nome_original = files(x).name(1:(idx_pontos(end)-1));
    nome = sprintf('%s.png', nome_original);
    imwrite(I, [dir_Testes_TMP nome]);
end

if exist(dir_Testes)
    rmdir(dir_Testes, 's')
end

dir_Testes = [diretorio_principal, '\', nome_base, '\Testes'];
dir_Testes_TMP = [diretorio_principal, '\', nome_base, '\Testes_TMP'];

comando = ['move ', dir_Testes_TMP, ' ', dir_Testes];
res = 1;
while res ~= 0
    res = system(comando);
end
