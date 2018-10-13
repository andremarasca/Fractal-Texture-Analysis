function VetLabel = Filtro_Raio_Descritores(VetLabel, RaiosDiscretos)

RaiosDiscretos(1) = [];
indices = RaiosDiscretos + 1; % Ajustando Hash, somando 1 porque o raio 1 esta na posicao 2...

VetLabel = VetLabel(:, indices);

% [M, ~] = size(VetLabel);
% 
% RaiosDiscretos = sqrt(RaiosDiscretos).^3;
% 
% for i = 1 : M
%     VetLabel(i, :) = VetLabel(i, :) ./ RaiosDiscretos;
% end

end