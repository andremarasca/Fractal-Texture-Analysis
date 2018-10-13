function Atributos = ChamaEDT(I, N_Camadas, Rmax)

[M, N, L] = size(I);

N_labels = L;

X = zeros(M * N * L, 1);
Y = zeros(M * N * L, 1);
Z = zeros(M * N * L, 1);
Lab = zeros(M * N * L, 1);

u = 1;
for k = 1 : L
    for i = 1 : M
        for j = 1 : N
            X(u, 1) = i - 1;
            Y(u, 1) = j - 1;
            Z(u, 1) = double(I(i, j, k)) / 255.0;
                        
            Lab(u, 1) = bitshift(1, k - 1); % 3 bits
            
            u = u + 1;
        end
    end
end

Camadas = N_Camadas;
Z = Z * (Camadas - 1);
Z = Z - min(Z(:));
Camadas = max(Z(:)) + 1;

Atributos = EDT_FRACTAL(double(X), double(Y), double(Z), double(Lab), [M, N, Camadas], Rmax, N_labels);

end
