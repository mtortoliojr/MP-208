%%--------------------------------------------------------------------------------
%% Função para que implementa o filtro EKFCD
%%--------------------------------------------------------------------------------
function [A2, B2] = teste(C)
C
A1 = C{1};
B1 = C{2};

A2 = 2 * A1;
B2 = 3 * B1;

end
