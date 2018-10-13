function rate = ValidacaoCruzada_GENETICO(X, k, k_folds)

%% habilitar pra testes

% tam = 40;
% n_classes = 5;
% 
% X = rand(tam, 20);
% k = floor((n_classes - 10^-16) * rand(tam, 1)); % igual probabilidade
% k_folds = 4;

%% Criação dos folds

[k, I] = sort(k,'descend'); % ordenar instancias pela classe
X = X(I, :); % ordenar instancias pela classe

[n_inst, ~] = size(X); % pega o numero de instancias

if k_folds == 0
    k_folds = n_inst;
end

v = zeros(n_inst, 1); % cria um vetor com as folds

% divisão dos folds
for i = 1 : k_folds
    for j = i : k_folds : n_inst
        v(j) = i; % 1 2 3 1 2 3 1 2 3 <-- exemplo k_folds = 3
    end
end

%% Validação Cruzada

c = zeros(n_inst, 1);

for i = 1 : k_folds
    %% Normalização
    X2 = X - repmat(mean(X(v ~= i, :)), n_inst, 1);
    X2 = X2 ./ repmat(std(X2(v ~= i, :)), n_inst, 1);
 
    %% Classificação
      
    Xtreino = X2(v ~= i, :);
    Ytreino = k(v ~= i);
    Xteste = X2(v == i, :);
    
    [COEFS, ~] = pca(Xtreino);
    Xtreino = Xtreino * COEFS;
    Xteste = Xteste * COEFS;
    
%     obj = fitcdiscr(Xtreino,Ytreino); % Fit discriminant analysis classifier

%     obj = fitcnb(Xtreino,Ytreino); % Train multiclass naive Bayes model

%     obj = fitcknn(Xtreino,Ytreino,'NumNeighbors', 1); % Fit k-nearest neighbor classifier

%     obj = fitcsvm(Xtreino,Ytreino); % Train binary support vector machine classifier

%     obj = fitctree(Xtreino,Ytreino); % Fit classification tree
        
%     Yteste = predict(obj,Xteste);
%     
%     c(v == i) = Yteste;

%     c(v==i) = classify(Xteste, Xtreino, Ytreino);
    [Yteste, ruim] = CLASSIFICADOR(Xteste, Xtreino, Ytreino);
    
    if ruim == 1
        break;
    else
        c(v==i) = Yteste;
    end
    
end

%% Avaliação

if ruim == 0
    M = confusionmat(c, k);
    rate = sum(diag(M)) / sum(M(:)) * 100;
else
    rate = -1;
end

end