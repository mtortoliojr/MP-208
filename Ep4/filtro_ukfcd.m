%%--------------------------------------------------------------------------------
%% Função para que implementa o filtro EKFCD
%%--------------------------------------------------------------------------------
function xe = filtro_ekf(u,y,Ts)

% Parâmetros do modelo e do filtro
param = ler_parametros();

% Matriz de covariância do ruído de estado
Q = param.e.Q;

% Matriz de covariância do ruído de medida
R = param.m.R;

% Número de medidas
nk = size(u,2);

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
xa_m = [x_; zeros(nw+nv,1)];
Pa = blkdiag(P,Q,R);

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
	xa_m = [];

	% Covariância do estado aumento
	Pa(1:nx,1:nx) = P;

	% Para cada sigma-ponto, faz a transformação Xsp -> Ysp
	for i = 1:2*na+1	

		% Obtenção dos sigma-pontos do estado aumentado
		xa = sigma_pontos(Xa_m,Pa,i);

		%----------------------------------------
		% Transformação dos sigma-pontos
		%----------------------------------------		
		
		% Sigma-pontos de x de índice "i" do estado aumentado Xa 		
		xspi = xa(1:nx,i);
		
		% Integração dos sigma-pontos xsp de tk a tk+1
		xspi = integral_edo_x(xspi,uk);

		% Transformação xsp -> ysp
		yspi = funcao_h(xspi,pG);
		
		% Atualiza a matriz de sigma-pontos de x e y
		xsp(:,i) = xspi;
		ysp(:,i) = yspi;

	end
		
	%----------------------------------------
	% Predição
	%----------------------------------------	

	% Constantes kappa e ro
	kappa = 3 - na;
	r0 = kappa / (Kappa + na); rn = 1 / (2*(Kappa + na));
	
	% Sigma-ponto de índice 0
	xsp0 = xsp(:,1);
	ysp0 = ysp(:,1);
	
	% Sigma-pontos de índice 1,..,2na
	xspn = xsp(:,2:end);
	yspn = ysp(:,2:end);
	
	% X de predição
	xp = r0 * xsp0 + sum(r1*xspn,2); 
	
	% Pxx (P) de predição	
	P = r0 * xsp0 * xsp0';
	P = P + sum(r1*xsp*xsp');

	% Y de predição
	yp = r0 * ysp0 + sum(r1*yspn,2); 

	% Py de predição	
	PY = r0 * ysp0 * ysp0';
	PY = PY + sum(r1*ysp*ysp');

	% Pxy de predição	
	PXY = r0 * xsp0 * ysp0';
	PXY = PXY + sum(r1*xsp*ysp');
	
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
