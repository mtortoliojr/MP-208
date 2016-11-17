%%--------------------------------------------------------------------------------
%% Função para o cálculo da matrix de cinemática de atitude em função de alfa
%%--------------------------------------------------------------------------------
function A = matriz_A(alfa)

% Ângulos de Euler
a1 = alfa(1);
a2 = alfa(2);
a3 = alfa(3);

% Cálculo dos cossenos e senos
ca1 = cos(a1); ca2 = cos(a2); ca3 = cos(a3);
sa1 = sin(a1); sa2 = sin(a2); sa3 = sin(a3);

% Definição da matriz A
A1 = [ca3/ca2; sa3; -ca3*sa2/ca2];
A2 = [-sa3/ca2; ca3; sa3*sa2/ca2];
A3 = [0; 0; 1];

% --------------------------------------------------------------
% A = [A1, A2, A3]
% --------------------------------------------------------------
A = [A1, A2, A3];

end
