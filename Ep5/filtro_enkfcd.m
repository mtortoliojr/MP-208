%%--------------------------------------------------------------------------------
%% Função para que implementa o filtro EKFCD
%%--------------------------------------------------------------------------------
function xe = filtro_enkfcd(x,u,y,Ts)

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

% Dimensão do vetor de medidas
ny = param.medida.ny;

% Dimensão do vetor de estados
nx = param.estado.nx;

% Parâmetros de inicialização do filtro
x_ = param.filtro.x0; 
P_ = param.filtro.P0;

% Número de amostras
N = 201;
N = 60;

% Dimensão de W e V
nw = param.estado.nw;
nv = param.medida.nv;

% Inicialização do filtro
xe = zeros(nx,nk); xe(:,1) = x_;
P = zeros(nx,nx);

% Inicialização da matriz de amostras xi
Xi = zeros(nx,N);
for i = 1:N
	Xi(:,i) = x_ + sqrtm(P_) * randn(nx,1);
	%Xi(:,i) = x(:,1);
end

% Inicialização da matriz de amostras yi
Yi = zeros(ny,N);
Vi = zeros(ny,N);
% Inicialização das matrizes de PY e PXY
PY = zeros(ny,ny); PXY = zeros(nx,ny);

% Loop de estimação
for k = 1:nk-1

	%disp(['k: ',num2str(k)]);
	%----------------------------------------
	% Leituras
	%----------------------------------------

	uk = u(:,k);
	yk = y(:,k+1);

	%----------------------------------------
	% Amostras de índice i
	%----------------------------------------

	for i = 1:N 

		% Amostra anterior xi
		xi = Xi(:,i);
		
		% Amostra do ruído de estado
		wi = sqrtm(Q) * randn(nw,1);

		% Amostra do ruído de medida
		vi = sqrtm(R) * randn(nv,1);
		
		% Amostra do estado predito
		xi = integral_edo_x(xi,uk,wi,Ts);

		% Amostra da saída predita
		yi = funcao_h(xi,pG) + vi;	
		Vi(:,i) = vi;
		
		% Atualização das matrizes de amostras de x e y
		Xi(:,i) = xi;
		Yi(:,i) = yi;
		
	end

	%----------------------------------------
	% Esperanças preditas
	%----------------------------------------
	
	% x de predição	
	xp = sum(Xi,2) / N;

	% y de predição	
	yp = sum(Yi,2) / N;

	% Zera as matrizes PY e PXY
	PY = 0 * PY;
	PXY = 0 * PXY;
	
	% Matriz PY e PXY de predição
	for i = 1:N	
		
		% Erros de predição de x e y
		ex = Xi(:,i) - xp;
		ey = Yi(:,i) - yp;

		% Soma acumulada de PY e PXY
		PY = PY + (ey * ey');
		PXY = PXY + (ex * ey');
		
	end	
	
	% PY e PXY
	PY = PY / (N - 1);
	PXY = PXY / (N - 1);
	
	%----------------------------------------
	% Atualização
	%----------------------------------------	

	% Ganho de Kalman
	Kk = PXY / PY;
	
	% Amostras do estado atualizado
	for i = 1:N
		Xi(:,i) = Xi(:,i) + Kk * (yk + Vi(:,i) - Yi(:,i));	
		xe(:,k+1) = xe(:,k+1) + Xi(:,i);
	end

	% Estado estimado
	xe(:,k+1) = xe(:,k+1) / N;

end

end
