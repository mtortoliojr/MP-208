%%--------------------------------------------------------------------------------
%% Função para que implementa o filtro EKFCD
%%--------------------------------------------------------------------------------
function f = filtro_ekf(x,u,y)

% Dimensão do vetor de estado e medida
nx = size(x,1);
ny = size(y,1);

% Número de medidas
nk = size(x,2);

% Inicialização do filtro
xe = zeros(nx,nk);
xe(:,1) = x_med;
Pe = Px;

for k = 1:nk
	
	uk = u(:,k);
	xk = xe(:,k);
	
	% Predição
	F = jacobiana_f(xk,uk);
	
	% Integral de x(tk) a x(tk+1)
	xp = x(:,k); % Obtido por RK4
	% Integral de P(tk) a P(tk+1)
	P = P;
	
	
	yp = funcao_h(xp);
	H = jacobiana_h(xp);
	PY = H * P * H' + R;
	PXY = P * H';
	
	% Atualização
	K = PXY * inv(PY);
	yk1 = y(:,k+1);
	xe(:,k+1) = xp + K * (yk1 -yp);
	P = P - k * PXY';	
		
end

end
