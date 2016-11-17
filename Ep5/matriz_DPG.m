%%--------------------------------------------------------------------------------
%% Função para o cálculo da matrix DPG em função de alfa
%%--------------------------------------------------------------------------------
function DPG = matriz_DPG(alfa)

% Ângulos de Euler
a1 = alfa(1);
a2 = alfa(2);
a3 = alfa(3);

% Cálculo dos cossenos e senos
ca1 = cos(a1);ca2 = cos(a2);ca3 = cos(a3);
sa1 = sin(a1);sa2 = sin(a2);sa3 = sin(a3);

% Definição da matriz DPG
D1 = [ca3*ca2; -sa3*ca2; sa2];
D2 = [ca3*sa2*sa1 + sa3*ca1; -sa3*sa2*sa1 + ca3*ca1; -ca2*sa1];
D3 = [-ca3*sa2*ca1 + sa3*sa1; sa3*sa2*ca1 + ca3*sa1; ca2*ca1];

% DPG = [D1, D2, D3];
DPG = [D1, D2, D3];

end
