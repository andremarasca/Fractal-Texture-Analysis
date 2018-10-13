% close all;
% close all hidden;
% close all force;
% clear all;
% clc;

load('ConfiguracoesIniciais.mat');
ConfigAplicacao = [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Configuracoes\', 'ConfiguracoesAplicacao.mat'];
load(ConfigAplicacao);

%% Ambientacao

dir_origem = [diretorio_principal, '\', nome_base, '\Bruto\'];
dir_destino = [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Base\'];
dir_class = [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Class\'];

if exist(dir_destino)
    rmdir(dir_destino, 's');
end
mkdir(dir_destino);

if exist(dir_class)
    rmdir(dir_class, 's');
end
mkdir(dir_class);

%% Tipos possiveis de imagens

ti(1).nome = '.png';
ti(2).nome = '.bmp';
ti(3).nome = '.jpg';
ti(4).nome = '.tif';

%% Criacao da base

% Listagem das pastas de bruto
p = dir(dir_origem);
FIG = zeros(tam_sub_figuras, tam_sub_figuras, 3);
n_sub_fig = 1;
classe = 0;
for ip = 1 : length(p)
    nome_classe = p(ip).name;
    qtd_pontos = length(find(nome_classe == '.'));
    if qtd_pontos == 0
        disp(nome_classe);
        NomeClasses(classe+1).nome = nome_classe;
        NomeClasses(classe+1).numero = classe;
        diretorio_classe = [dir_origem, '\', nome_classe, '\'];
        files = [];
        for iti = 1 : length(ti)
            files_ti = dir([diretorio_classe, '*', ti(iti).nome]);
            files = [files; files_ti];
        end
        
        diretorio_classe_tmp = [dir_origem, '\', nome_classe, '_TMP\'];
        if exist(diretorio_classe_tmp)
            rmdir(diretorio_classe_tmp, 's')
        end
        mkdir(diretorio_classe_tmp);
        
        %%%%% Varrer cada pasta (cada pasta é uma classe)
        
        for x = 1 : length(files)
            disp(files(x).name);
            
            I = imread([diretorio_classe files(x).name]);
            
            tipo_figura = files(x).name;
            idx_pontos = find(tipo_figura == '.');
            tipo_figura = tipo_figura(idx_pontos(end) : end);
            
            novo_nome = sprintf('%s_%03d%s', nome_classe, x, tipo_figura);
            comando = ['move "', [diretorio_classe files(x).name], '" "', [diretorio_classe_tmp novo_nome], '"'];
            system(comando);
            
            %             comando = sprintf('ren %s %s_%03d%s', [diretorio_classe files(x).name], nome_classe, x, tipo_figura);
            %             comando(find(comando == '/')) = '\';
            %             system(comando);
            
            I = imresize(I, escala_imagem_original, 'Method', 'cubic');
            [M, N, L] = size(I);
            Mdiv = floor(M / tam_sub_figuras);
            Ndiv = floor(N / tam_sub_figuras);
            
            Mini = floor((M - Mdiv * tam_sub_figuras)/2);
            Nini = floor((N - Ndiv * tam_sub_figuras)/2);
            
            nome_file_in = files(x).name;
            
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
                    nome_saida = sprintf('%s/%04d_%04d_%04d.png', dir_destino, classe, x, nfig);
                    imwrite(uint8(FIG), nome_saida);
                    Y(n_sub_fig) = classe;
                    n_sub_fig = n_sub_fig + 1;
                    nfig = nfig + 1;
                end
            end
        end
        
        %%%%%%%%%%
        
        diretorio_classe = [dir_origem, '\', nome_classe];
        diretorio_classe_tmp = [dir_origem, '\', nome_classe, '_TMP'];
        
        if exist(diretorio_classe)
            rmdir(diretorio_classe, 's')
        end
        
        comando = ['move "', diretorio_classe_tmp, '" "', diretorio_classe, '"'];
        system(comando);
        
        classe = classe + 1;
    end
end

%%

k = Y;
nome_class = sprintf('class%s.mat', nome_base);

save([dir_class, '\', nome_class], 'k');
save([dir_class, '\', 'NomeClasses.mat'], 'NomeClasses');
