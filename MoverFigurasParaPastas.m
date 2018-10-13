% close all;
% close all hidden;
% close all force;
% clear all;
% clc;

load('ConfiguracoesIniciais.mat');

%% Ambientacao

dir_origem = [diretorio_principal, '\', nome_base, '\Bruto\'];

%% Coloca cada imagem dentro de uma pasta

p = dir(dir_origem);
classe = 0;
for ip = 1 : length(p)
    nome_classe = p(ip).name;
    if length(nome_classe) > 2
        nome_pasta = sprintf('%04d', classe);
        mkdir([dir_origem nome_pasta]);
        comando = ['move "', [dir_origem nome_classe], '" "', [dir_origem nome_pasta], '"'];
        res = 1;
        while res ~= 0
            res = system(comando);
        end
        classe = classe + 1;
    end
end
