%%--------------------------------------------------------------------------------
%% Função para que implementa o filtro EKFCD
%%--------------------------------------------------------------------------------
function xe = filtro_ekf(x,u,y,pG,Ts)

% Matriz de covariância do ruído de estado
Qa = 1*1e-4*eye(3);
Qg = 1*1e-7*eye(3);
Q = blkdiag(Qa,Qg);

% Matriz de covariância do ruído de medida
Ri = 0.006^2*eye(2);
R = blkdiag(Ri,Ri,Ri,Ri);

% Número de medidas
nk = size(u,2);

% Parâmetros de inicialização do filtro
x_ = [1,4,10,0,0,0,0,0,0]'; nx = length(x_);
P_ = blkdiag(4*eye(3),2*eye(3),1*eye(3));

% Dimensão de W e V
nw = 6; nv = 8;

% Inicialização do filtro
xe = zeros(nx,nk); xe(:,1) = x_;
P = P_;

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
	Xa_m = [];

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