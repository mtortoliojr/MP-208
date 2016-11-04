%%--------------------------------------------------------------------------------
%% Função para o cálculo da jacobiana de h(x)
%%--------------------------------------------------------------------------------
function H = jacobiana_h(x,pG)

% Parâmetros
f = 1;
DCP = diag([1,-1,-1]);
rPCP = [0 0 0]';

% Dimensão de x
nx = length(x);

% Número de landmarks
nl = size(pG,2);

% Jacobiana H = dh/dh
H = [];
for n = 1:nl
	Hi = jacobiana_hi(x,pG(:,n));
	H = [H; Hi];
end

end
