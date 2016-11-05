%%--------------------------------------------------------------------------------
%% Função para o cálculo da matrix de cinemática de atitude em relação de alfa
%%--------------------------------------------------------------------------------
function dA = jacobiana_A(alfa)

% Ângulos de Euler
a1 = alfa(1);
a2 = alfa(2);
a3 = alfa(3);

% Cálculo dos cossenos e senos
ca1 = cos(a1);ca2 = cos(a2);ca3 = cos(a3);
sa1 = sin(a1);sa2 = sin(a2);sa3 = sin(a3);

% dA1 = d(A)/d(alfa1)
dA1 = zeros(3,3);

% dA2 = d(A)/d(alfa2)
dA2 = [ ca3*sa2/ca2^2, -sa3*sa2/ca2^2, 0;
		0, 0, 0;
		-ca3/ca2^2, sa3/ca2^2, 0;		
	   ];

% dA3 = d(A)/d(alfa3)
dA3 = [-sa3/ca2, -ca3/ca2, 0;
	   ca3, -sa3, 0;
	   sa3*sa2/ca2, ca3*sa2/ca2, 0;
	   ];

% Definição da Jacobiana da matriz A
% d(A)/d(alfa) = [dA1, dA2, dA3];
dA = [dA1,dA2,dA3];

end
