%%--------------------------------------------------------------------------------
%% Função para inicialização dos parâmetros do modelo do filtro UKFCD
%%--------------------------------------------------------------------------------
function param = ler_parametros()

%----------------------------------------
% Parâmetros da equação de estado
%----------------------------------------

% nx: dimensão do vetor de estados X
nx = 9;

% nw: dimensão do vetor de ruído de estado W
nw = 6;

% Q: Matriz de covariância do ruído de estado
Qa = 1*1e-4*eye(3); Qg = 1*1e-7*eye(3);
Q = blkdiag(Qa,Qg);

% 1) Estrutura dos parâmetros de estado
e = struct('nx',nx,'nw',nw,'Q',Q);

%----------------------------------------
% Parâmetros da equação de medidas
%----------------------------------------

% pG: mapa de landmarks
pG1 = [0 0 0]'; pG2 = [5 5 0]';
pG3 = [-5 5 0]'; pG4 = [-5 -5 0]';
pG = [pG1,pG2,pG3,pG4];

% q: número de landmarks
q = size(pG,2);

% ny: dimensão do vetor de medidas
ny = 2*q;

% nv: dimensão do vetor de ruído de medida
nv = ny;

% Matriz de covariância do ruído de medida
Ri = 0.006^2*eye(2); R = [];
for i = 1:q;
	R = blkdiag(R,Ri);
end

% 2) Estrutura dos parâmetros de medida
m = struct('pG',pG,'q',q,'ny',ny,'nv',nv,'R',R);

%----------------------------------------
% Parâmetros do filtro
%----------------------------------------

% Média inicial
x_ = [1,5,10,0,0,0,0,0,0]'; nx = length(x_);

if(length(x_) ~= nx)
	x_ = zeros(nx,1);
end

% Matriz de covariância inicial
P_ = blkdiag(4*eye(3),2*eye(3),1*eye(3));

if(size(P_,1) ~= nx)
	P_ = eye(nx);
end

% 3) Estrutura dos parâmetros do filtro
f = struct('x0',x_,'nx',nx,'P0',P_);

%----------------------------------------
% Estrutura de todos parâmetros
%----------------------------------------
param = struct('e',e,'m',m,'f',f);

end
