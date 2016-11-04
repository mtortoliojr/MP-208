%%--------------------------------------------------------------------------------
%% Função para o cálculo da Jacobiana de DPG em relação a alfa
%%--------------------------------------------------------------------------------
function dDPG = jacobiana_DPG(alfa)

% Ângulos de Euler
a1 = alfa(1);
a2 = alfa(2);
a3 = alfa(3);

% Cálculo dos cossenos e senos
ca1 = cos(a1);ca2 = cos(a2);ca3 = cos(a3);
sa1 = sin(a1);sa2 = sin(a2);sa3 = sin(a3);

% Definição da Jacobiana da matriz DPG
% d(DPG)/d(alfa) = [dD1, dD2, dD3];

% dD1 = d(D1)/d(alfa1)
dD1 = [ 0, ca3*sa2*ca1 - sa3*sa1, ca3*sa2*sa1 + sa3*ca1;
		0, -sa3*sa2*ca1 - ca3*sa1, -sa3*sa2*sa1 + ca3*ca1;
		0, -ca2*ca1, -ca2*sa1;
		]; 

% dD2 = d(D2)/d(alfa2)
dD2 = [ -ca3*sa2, ca3*ca2*sa1, -ca3*ca2*ca1;
		sa3*sa2, -sa3*ca2*sa1, sa3*ca2*ca1;
		ca2, sa2*sa1, -sa2*ca1;
		];

% dD3 = d(D3)/d(alfa3)
dD3 = [ -sa3*ca2, -sa3*sa2*sa1 + ca3*ca1, sa3*sa2*ca1 + ca3*sa1;
		-ca3*ca2, -ca3*sa2*sa1 - sa3*ca1, ca3*sa2*ca1 - sa3*sa1;
		0, 0, 0;
		];

% Jacobiana
dDPG = [dD1,dD2,dD3];

end
