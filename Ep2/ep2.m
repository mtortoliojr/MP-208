%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MP-208 : Filtragem Ótima com Aplicações Aeroespaciais                 
% Exercício Computacional 2                                     
% Aluno : Marcos Tortólio Junior                                                      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;

% Definição da variável aleatória Wk
Q = diag([10^-2,4*10^-2]);

% Definição da variável aleatória Vk
R = 0.01;

% Definição da variável aleatória X1
m_x1 = [1;0];
P_x1 = diag([10^-4,10^-8]);

% Definição do sistema dinâmico
A = [1 0.1; 0 1];
B = [0.005; 0.1];
C = [1 0];

% Período de amostragem
T = 0.1;

% Definição do sinal de controle
yk_ctrl = 5;
e1 = [1;0];
e2 = [0;1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Item a) Simulação do sistema dinâmico.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Número de realizações
r_max = 10;

% Tempo de simulação t=0,...,t_max
t_max = 20;
k_max = length(0:t_max/T);

% Realizações r=1,...,r_max
XK = zeros(2,k_max,r_max);
UK = zeros(r_max,k_max);
YK = zeros(r_max,k_max);

rng(0,'twister');

for r = 1:r_max
	
	x1 = m_x1; + sqrtm(P_x1)*randn(2,1);
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

% Gráfico de Yk comando e Yk realizações
figure(1)
hold on
p1 = plot(YK','b','LineWidth',1); p1 = p1(1);
p2 = plot(yk_ctrl*ones(1,k_max),'r','LineWidth',2);
title('Item a) Saídas medidas e sinal de comando.')
xlabel('k');ylabel('yk');
legend([p1 p2],'Realizações da saída medida.','Comando.');
saveas(gcf,'Fig_a.jpg');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Item b) Filtro de Kalman convencional.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

XK_KF = zeros(2,k_max,r_max);
XK_Erro = zeros(2,k_max);
PK = zeros(2,k_max);

Erro_med = 0;
Erro_RMS = 0;

figure(2)

for r = 1:r_max
	
	% Inicialização do filtro
	xk_est = m_x1;
	XK_KF(:,1,r) = xk_est;
	XK_Erro(:,1) = XK(:,1,r) - xk_est;
	
	Pk = P_x1;
	PK(:,1) = diag(Pk);
			
	for k = 1:k_max
		
		% Sinal de controle
		uk = UK(r,k);
				
		% Predição
		xk_pred = A * xk_est + B * uk;				
		Pk = A * Pk * A' + Q;

		% Atualização
		Kk = Pk * C' * inv(C * Pk * C' + R);
		KK(:,k) = Kk;
		
		yk = YK(r,k+1);
		xk_est = xk_pred + Kk * (yk - C * xk_pred);
		XK_KF(:,k+1,r) = xk_est;

		Pk = Pk - Kk * C * Pk;				
		PK(:,k+1) = sqrt(diag(Pk));

		% Erro de estimação
		xk = XK(:,k+1,r);
		XK_Erro(:,k+1) = xk - xk_est;
				
	end
	
	min_ = min(XK_Erro')';
	max_ = max(XK_Erro')';
	
	
	Erro_med = Erro_med + XK_Erro;
	Erro_RMS = Erro_RMS  + XK_Erro .* XK_Erro;
	
	subplot(2,1,1);plot(XK_Erro(1,:),'b','LineWidth',1);hold on
	subplot(2,1,2);plot(XK_Erro(2,:),'b','LineWidth',1);hold on
end

Erro_med = Erro_med/r_max;
Erro_RMS = sqrt(Erro_RMS/r_max - Erro_med .* Erro_med);

% Gráficos dos erros de estimação das realizações para cada componente de X
for i=1:2
	subplot(2,1,i)
	title(['Item b) Erros de estimação para i=.',num2str(i)])
	p1 = plot(Erro_med(i,:),'black','LineWidth',2);
	p2 = plot(Erro_RMS(i,:),'r','LineWidth',2);plot(-Erro_RMS(i,:),'r','LineWidth',2);
	p3 = plot(PK(i,:),'g','LineWidth',2);plot(-PK(i,:),'g','LineWidth',2);
	legend([p1 p2 p3],'Erro médio amostral.','Erro RMS amostral.','Desvio padrão teórico.');
	xlabel('k');ylabel('Erro de estimação');
end

saveas(gcf,'Fig_b.jpg');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Item c) Filtro informação.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ZK = zeros(2,k_max,r_max);
XK_Erro = zeros(2,k_max);
PK = zeros(2,k_max);

Erro_med = 0;
Erro_RMS = 0;

figure(3)

I = eye(size(A,2));

for r = 1:r_max
	
	% Inicialização do filtro
	XK_Erro(:,1) = XK(:,1,r) - m_x1;
	
	Lk = inv(P_x1);
	zk_est = Lk * m_x1;
	PK(:,1) = diag(Pk);
			
	for k = 1:k_max
		
		% Sinal de controle
		uk = UK(r,k);
				
		% Predição
		PIk = inv(A') * Lk * inv(A);
		Kk = PIk * inv(PIk + inv(Q));
		
		zk_pred = (I - Kk) * inv(A') * zk_est + (I - Kk) * PIk * B * uk;				
		Lk = (I - Kk) * PIk;

		% Atualização
		yk = YK(r,k+1);
		zk_est = zk_pred + C' * inv(R) * yk;
		Lk = Lk + C' * inv(R) * C;
				
		xk_est = inv(Lk) * zk_est;
		PK(:,k+1) = sqrt(diag(inv(Lk)));

		% Erro de estimação
		xk = XK(:,k+1,r);
		XK_Erro(:,k+1) = xk - xk_est;
				
	end
		
	Erro_med = Erro_med + XK_Erro;
	Erro_RMS = Erro_RMS  + XK_Erro .* XK_Erro;
	
	subplot(2,1,1);plot(XK_Erro(1,:),'b','LineWidth',1);hold on
	subplot(2,1,2);plot(XK_Erro(2,:),'b','LineWidth',1);hold on
end

Erro_med = Erro_med/r_max;
Erro_RMS = sqrt(Erro_RMS/r_max - Erro_med .* Erro_med);

% Gráficos dos erros de estimação das realizações para cada componente de X
for i=1:2
	subplot(2,1,i)
	title(['Item c) Erros de estimação para i=.',num2str(i)])
	p1 = plot(Erro_med(i,:),'black','LineWidth',2);
	p2 = plot(Erro_RMS(i,:),'r','LineWidth',2);plot(-Erro_RMS(i,:),'r','LineWidth',2);
	p3 = plot(PK(i,:),'g','LineWidth',2);plot(-PK(i,:),'g','LineWidth',2);
	legend([p1 p2 p3],'Erro médio amostral.','Erro RMS amostral.','Desvio padrão teórico.');
	xlabel('k');ylabel('Erro de estimação');
end

saveas(gcf,'Fig_c.jpg');

