function RaiosDiscretos = CalculaTodosRaiosDiscretos(Rmax)

u = 1;
for i = 0 : Rmax
    for j = 0 : Rmax
        for k = 0 : Rmax
            tmp = i^2 + j^2 + k^2;
            if tmp <= Rmax^2
                RaiosDiscretos(u) = tmp;
                u = u + 1;
            end
        end
    end
end

RaiosDiscretos = unique(RaiosDiscretos);
RaiosDiscretos = sort(RaiosDiscretos);

end

