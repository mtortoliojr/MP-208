%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MP-208 : Filtragem Ótima com Aplicações Aeroespaciais                 
% Exercício Computacional 2                                     
% Aluno : Marcos Tortólio Junior                                                      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;

%% Definição da variável aleatória Wk
Q = diag([10^-2,4*10^-2]);

%% Definição da variável aleatória Vk
R = 0.01;

%% Definição da variável aleatória X1
m_x1 = [1;0];
P_x1 = diag([10^-4,10^-8]);

%% Definição do sistema dinâmico
A = [1 0.1; 0 1];
B = [0.005; 0.1];
C = [1 0];

%% Período de amostragem
T = 0.1;

%% Definição do sinal de controle
yk_ctrl = 5;
e1 = [1;0];
e2 = [0;1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Item a)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Número de realizações
r_max = 1000;

% Tempo de simulação t=0,...,t_max
t_max = 20;
k_max = length(0:T:t_max);

% Realizações r=1,...,r_max
XK = zeros(2,k_max,r_max);
UK = zeros(r_max,k_max);
YK = zeros(r_max,k_max);

rng(0,'twister');

for r = 1:r_max
	
	x1 = m_x1 + sqrtm(P_x1)*randn(2,1);
	XK(:,1,r) = x1;
	
	YK(r,1) = C * x1;	
	
	for k = 1:k_max
		
		% Vetor de estados anterior
		xk = XK(:,k,r);
				
		% Sinal de controle
		uk = 10 * (yk_ctrl - e1' * xk) - 2 * e2' * xk;
		UK(r,k) = uk;
		
		% Atualização do vetor de estados
		xk =  A * xk + B * uk + sqrtm(Q)*randn(2,1);
		XK(:,k+1,r) = xk;
		
		% Saída medida
		YK(r,k+1) = C * xk + sqrt(R)*randn();	
			
	end
end

%% Gráfico de Yk comando e Yk realizações
figure(1)
hold on
plot(YK','b','LineWidth',1)
plot(yk_ctrl*ones(1,k_max),'r','LineWidth',2);
title('Item a) Saídas medidas e sinal de comando.')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Item b) :  Filtro de Kalman convencional.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

XK_KF = zeros(2,k_max,r_max);
XK_Erro = zeros(2,k_max,r_max);
PK = zeros(2,k_max,r_max);
Erro_med = 0;
Erro_quad = 1;
Erro_RMS = 0;

for r = 1:r_max
	
	% Inicialização do filtro
	xk_est = m_x1;
	XK_KF(:,1,r) = xk_est;
	XK_Erro(:,1,r) = XK(:,1,r) - xk_est;
	
	Pk = P_x1;
	PK(:,1,r) = diag(Pk);
			
	for k = 1:k_max
		
		% Sinal de controle
		uk = UK(r,k);
				
		% Predição
		xk_est = A * xk_est + B * uk;				
		Pk = A * Pk * A' + Q;

		% Atualização
		Kk = Pk * C' * inv(C * Pk * C' + R);

		yk = YK(r,k+1);
		xk_est = xk_est + Kk * (yk - C * xk_est);
		XK_KF(:,k+1,r) = xk_est;

		Pk = Pk - Kk * C * Pk;				
		PK(:,k+1,r) = sqrt(diag(Pk));

		% Erro de estimação
		xk = XK(:,k+1,r);
		XK_Erro(:,k+1,r) = xk - xk_est;
				
	end
	
	Erro_med = Erro_med + XK_Erro(:,:,r);
	Erro_RMS = Erro_RMS  + XK_Erro(:,:,r) .* XK_Erro(:,:,r);	
end
Erro_med = Erro_med/r_max;
Erro_RMS = sqrt(Erro_RMS/r_max - Erro_med .* Erro_med);
%Erro_RMS = sqrt(Erro_RMS);

%% Gráficos dos erros de estimação das realizações para cada componente de X
figure(2)
for i=1:2
	subplot(2,1,i)
	title(['Item b) Erros de estimação verdadeiros para i=',num2str(i)])
	hold all
	for r = 1:r_max
		plot(XK_Erro(i,:,r),'b','LineWidth',1)
	end
	plot(Erro_med(i,:),'r','LineWidth',2);
	plot(PK(i,:,r),'r','LineWidth',2);plot(-PK(i,:,r),'r','LineWidth',2)
	plot(Erro_RMS(i,:),'g','LineWidth',2);plot(-Erro_RMS(i,:),'g','LineWidth',2)
end



