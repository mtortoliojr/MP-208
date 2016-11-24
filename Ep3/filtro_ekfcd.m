%%--------------------------------------------------------------------------------
%% Função para que implementa o filtro EKFCD
%%--------------------------------------------------------------------------------
function xe = filtro_ekfcd(u,y,Ts)

% Parâmetros do modelo e do filtro
param = ler_parametros();

% Mapa de landmarks
pG = param.medida.pG;

% Matriz de covariância do ruído de estado
Q = param.estado.Q;

% Matriz de covariância do ruído de medida
R = param.medida.R;

% Número de medidas
nk = size(u,2);

% Dimensão do vetor de estados
nx = param.estado.nx;

% Parâmetros de inicialização do filtro
x_ = param.filtro.x0; 
P_ = param.filtro.P0;

% Inicialização do filtro
xe = zeros(nx,nk); xe(:,1) = x_;
P = P_;

% Loop de estimação
for k = 1:nk-1
		
	%----------------------------------------
	% Leituras
	%----------------------------------------
				
	uk = u(:,k);
	xk = xe(:,k);
	yk = y(:,k+1);

	%----------------------------------------
	% Predição
	%----------------------------------------	
	
	% Integração de x de tk a tk+1
	xp = integral_edo_x(xk,uk,Ts);

	% Integração de P de tk a tk+1
	P = integral_edo_P(xk,uk,P,Q,Ts);
	
	% Jacobiana H
	H = jacobiana_h(xp,pG);

	% y de predição
	yp = funcao_h(xp,pG);
	
	% Covariâncias PY e PXY de predição	
	PY = H * P * H' + R;
	PXY = P * H';

	%----------------------------------------
	% Atualização
	%----------------------------------------	

	% Ganho de Kalman
	K = PXY / PY;

	% x estimado	
	xe(:,k+1) = xp + K * (yk - yp);

	% Atualização de P
	P = P - K * H * P;	
end


end
