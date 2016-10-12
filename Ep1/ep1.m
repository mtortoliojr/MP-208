%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 		MP-208 : Filtragem Ótima com Aplicações Aeroespaciais                 
% 			Exercício Computacional 1                                     
%
%
% Aluno : Marcos Tortólio Junior                                                      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;

%% Definição da variável aleatória theta
m_theta = [1 2]';
P_theta = diag([0.01,0.04]);

%% Definição da variável aleatória vi
R = 0.01;

%% Número de medidas
k = 10;

%% Número de realizações de theta
r_max = 100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cálculos preliminares
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Realizações de theta e yi, i = 1,..k
rng(0,'twister');
y = zeros(r_max,k);
for r=1:r_max
    % Realização de theta
    theta_r = m_theta + chol(P_theta)*randn(2,1);
    theta(:,r) = theta_r;
    
    % Realização das medidas y1,..,yk
    for i=1:k
        % Realização da va vi
        vi = sqrt(R)*randn;
	% Realização de yi
	hi = [i,1];
        y(r,i) = hi*theta_r + vi;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Item a)
%
% Foi utilizado o estimador LS com k=10, ou seja, i=1,...,10.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%
% Estimador LS
%%%%%%%%%%%%%%%%%%%

theta_est_ls = zeros(2,r_max); % vetor de theta estimado
erro_ls = zeros(2,r_max);
wi = 1;


% Fator Pk = hi'*wi*hi, i=1,..,k
Pk = 0;
for i=1:k
    hi = [i,1];
    Pk = Pk + hi' * wi * hi;
end
Pk = inv(Pk);

for r=1:r_max
    
    H_Wi_y = 0;
    H_R_H = 0;
    for i=1:k
        % Fator Hi'*Wi*yi
	hi = [i,1];
        H_Wi_y = H_Wi_y + hi'* wi *y(r,i);
    end
    
    % Estimador LS batch
    theta_est_ls(:,r) = Pk * H_Wi_y;
    
    % Erro de estimação
    erro_ls(:,r) = theta_est_ls(:,r) - theta(:,r);
    
end

%%%%%%%%%%%%%%%%%%%%
% Resultados
%%%%%%%%%%%%%%%%%%%%

% Média das realizações
med_ls = mean(theta_est_ls,2)

% Erro RMS das realizações
erro_rms_ls = sqrt(diag(erro_ls*erro_ls')/r_max)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Item b)
%
% Foi utilizado o estimador MAP com k=10, ou seja, i=1,...,10.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%
% Estimador MAP
%%%%%%%%%%%%%%%%%%%

theta_est_map = zeros(2,r_max); % vetor de theta estimado
erro_map = zeros(2,r_max);

% Fator Pk = soma(hi'*R_inv*hi) + P_theta_inv, i=1,..,k
P_theta_inv = inv(P_theta);
R_inv = inv(R);
Pk = P_theta_inv;

for i=1:k
    hi = [i,1];
    Pk = Pk + hi' * R_inv * hi;
end
Pk = inv(Pk);

for r=1:r_max

    H_Rinv_y = 0;
    for i=1:k
	hi = [i,1];
        H_Rinv_y = H_Rinv_y + hi'* R_inv *y(r,i);
    end
    
    % Estimador MAP batch
    theta_est_map(:,r) = Pk*P_theta_inv*m_theta + Pk*H_Rinv_y;
    
    % Erro de estimação
    erro_map(:,r) = theta_est_map(:,r) - theta(:,r);    
end

%%%%%%%%%%%%%%%%%%%%
% Resultados
%%%%%%%%%%%%%%%%%%%%

% Média das realizações
med_map = mean(theta_est_map,2)

% Média teórica das estimativas
med_teor_map = m_theta

% Erro RMS das realizações
erro_rms_map = sqrt(diag(erro_map*erro_map')/r_max)

% Erro RMS teórico
erro_rms_teor_map = sqrt(diag(Pk))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Item c)
%
% Comparação entre as estimativas LS e MAP.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

r = 1:r_max;

figure(1)
subplot(2,1,1)
plot(r,theta(1,:),'b--',r,theta_est_ls(1,:),'b',r,theta_est_map(1,:),'r')
xlabel('Realizações');
ylabel('theta 1');
legend('Theta 1 real (realização)','Theta 1 estimado LS','Theta 1 estimado MAP');

subplot(2,1,2)
plot(r,theta(2,:),'b--',r,theta_est_ls(2,:),'b',r,theta_est_map(2,:),'r')
xlabel('Realizações');
ylabel('theta 2');
legend('Theta 2 real (realização)','Theta 2 estimado LS','Theta 2 estimado MAP');
