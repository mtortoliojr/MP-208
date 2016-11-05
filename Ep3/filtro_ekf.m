%%--------------------------------------------------------------------------------
%% Função para que implementa o filtro EKFCD
%%--------------------------------------------------------------------------------
function xe = filtro_ekf(u,y,pG,Ts)

% Matriz de covariância do ruído de estado
Qa = 1*1e-4*eye(3);
Qg = 1*1e-7*eye(3);
Q = blkdiag(Qa,Qg);

% Matriz de covariância do ruído de medida
Ri = 0.006*eye(2);
R = blkdiag(Ri,Ri,Ri,Ri);

% Número de medidas
nk = size(u,2);

% Parâmetros de inicialização do filtro
x_ = [1,5,25,0,0,0,0,0,0]'; nx = length(x_);
P_ = blkdiag(4*eye(3),2*eye(3),1*eye(3));

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
	% Predição
	%----------------------------------------	

	% Ganho de Kalman
	K = PXY * inv(PY);

	% x estimado	
	xe(:,k+1) = xp + K * (yk - yp);

	% Atualização de P
	P = P - PXY * inv(PY) * PXY';	
	
	
end

end
