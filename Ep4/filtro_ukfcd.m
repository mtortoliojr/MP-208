%%--------------------------------------------------------------------------------
%% Função para que implementa o filtro EKFCD
%%--------------------------------------------------------------------------------
function xe = filtro_ekf(u,y,Ts)

% Parâmetros do modelo e do filtro
param = ler_parametros();

% Mapa de landmarks
pG = param.m.pG;

% Matriz de covariância do ruído de estado
Q = param.e.Q;

% Matriz de covariância do ruído de medida
R = param.m.R;

% Número de medidas
nk = size(u,2);

% Dimensão do vetor de medidas
ny = param.m.ny;

% Parâmetros de inicialização do filtro
x_ = param.f.x0; nx = param.e.nx;
P_ = param.f.P0;

% Dimensão de W e V
nw = param.e.nw;
nv = param.m.nv;

% Inicialização do filtro
xe = zeros(nx,nk); xe(:,1) = x_;
P = P_;

% Inicialização do estado aumentado
na = nx + nw + nv;
%xa = zeros(na, 2*na + 1);
xa = zeros(na,1);

% Inicialização da média e covariância do estado aumentado
xa_m = [x_; zeros(nw+nv,1)];
Pa = blkdiag(P,Q,R);

% Inicialização dos sigma-pontos de x e y
xsp = zeros(nx, 2*na + 1);
ysp = zeros(ny, 2*na + 1);

% Loop de estimação
for k = 1:nk-1
	
	%----------------------------------------
	% Leituras
	%----------------------------------------
				
	uk = u(:,k);
	xk = xe(:,k);
	yk = y(:,k+1);

	%----------------------------------------
	% Obtenção dos sigma-pontos
	%----------------------------------------
	
	% Média do estado aumento
	xa_m(1:nx) = xk;

	% Covariância do estado aumento
	Pa(1:nx,1:nx) = P;

	% Matriz raiz quadrada de Pa
	Pa_sqrt = chol(Pa,'lower');
	
	% Para cada sigma-ponto, faz a transformação Xsp -> Ysp
	for i = 1:2*na+1	

		% Obtenção dos sigma-pontos do estado aumentado
		xa = sigma_pontos(xa_m,Pa_sqrt,i);

		%----------------------------------------
		% Transformação dos sigma-pontos
		%----------------------------------------		
		
		% Sigma-pontos de x, w e v de índices "i" do estado aumentado Xa 		
		xspi = xa(1:nx);
		wspi = xa(nx+1:nx+nw);
		vspi = xa(nx+nw+1:end);
		
		% Integração dos sigma-pontos xsp de tk a tk+1
		xspi = integral_edo_x(xspi,uk,wspi,Ts);

		% Transformação xsp -> ysp
		
		yspi = funcao_h(xspi,pG) + vspi;
		
		% Atualiza a matriz de sigma-pontos de x e y
		xsp(:,i) = xspi;
		ysp(:,i) = yspi;

	end
		
	%----------------------------------------
	% Predição
	%----------------------------------------	

	% Constantes kappa e ro
	kappa = 3 - na;
	r0 = kappa / (kappa + na); rn = 1 / (2*(kappa + na));
	
	% Sigma-ponto de índice 0
	xsp0 = xsp(:,1);
	ysp0 = ysp(:,1);
	
	% Sigma-pontos de índice 1,..,2na
	xspn = xsp(:,2:end);
	yspn = ysp(:,2:end);
	
	% X de predição
	xp = r0 * xsp0 + rn*sum(xspn,2); 
	
	% Pxx (P) de predição	
	P = r0 * (xsp0-xp) * (xsp0-xp)';
	for i = 1:2*na
		P = P + rn * (xspn(:,i)-xp) * (xspn(:,i)-xp)';
	end
	
	% Y de predição
	yp = r0 * ysp0 + rn * sum(yspn,2); 

	% Py de predição	
	PY = r0 * (ysp0-yp) * (ysp0-yp)';
	for i = 1:2*na
		PY = PY + rn * (yspn(:,i)-yp) * (yspn(:,i)-yp)';
	end

	% Pxy de predição	
	PXY = r0 * (xsp0-xp) * (ysp0-yp)';
	for i = 1:2*na
		PXY = PXY + rn * (xspn(:,i)-xp) * (yspn(:,i)-yp)';
	end

	%----------------------------------------
	% Atualização
	%----------------------------------------	

	% Ganho de Kalman
	K = PXY / PY;
	
	% x estimado	
	xe(:,k+1) = xp + K * (yk - yp);

	% Atualização de P
	P = P - K * PXY';

end


end
