%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simula��o MC de algoritmos de navega��o
% Problema: Inertial-Vision Navigation from Landmark Vector Measurements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Prof. Davi Ant�nio dos Santos
% Local: Instituto Tecnol�gico de Aerona�tica
% Data: 12/10/2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
close all;
clear;

warning('off','all')
warning

seed_offset = 1;

%% Matriz de landmarks
pG1 = [0 0 0]'; pG2 = [5 5 0]';
pG3 = [-5 5 0]'; pG4 = [-5 -5 0]';
pG = [pG1,pG2,pG3,pG4];

%% Parametros
N = 10;     % n�mero de realiza��es para a simula��o MC
tf = 60;   % tempo de simula��o
Ts = 0.05;  % per�odo de amostragem dos sensores

%% Loop de Simula��o Monte Carlo

% Inicializa��es de �ndices de desempenho
m_e = zeros(9,tf/Ts+1);          % m�dia do erro de estima��o de x 
sigma_e = zeros(9,tf/Ts+1);      % desvio padr�o do erro de estima��o de x

for j=1:N,
    
    %% Simula��o da plataforma
    
    sim('plataforma_ep3');

    % Estados verdadeiros
    
    x(1:3,:) = r.signals.values';
    x(4:6,:) = v.signals.values';
    x(7:9,:) = a.signals.values';

    % Medidas dos sensores
    
    u(1:3,:) = am.signals.values';
    u(4:6,:) = wm.signals.values';
    y(1:2,:) = y1.signals.values';
    y(3:4,:) = y2.signals.values';
    y(5:6,:) = y1.signals.values';
    y(7:8,:) = y2.signals.values';
    
    %% Estimador de estados (implemente o filtro aqui)

    %---------------------------------------------------------------------------------------------
	xe = filtro_ekf(u,y,pG,Ts);
    %---------------------------------------------------------------------------------------------
    
    %% Atualiza��o dos �ndices de desempenho
    m_e = m_e + (x-xe);
	sigma_e = sigma_e + (x-xe).^2;


end % loop da simula��o MC

m_e = m_e/N;
sigma_e = sqrt(sigma_e/N - m_e.^2);


% Gr�ficos
% erros de posi��o:
figure; hold; plot(m_e(1,:)','b'); plot(sigma_e(1,:)','r'); plot(-sigma_e(1,:)','r'); title('erro rx');
saveas(gcf,'Resultados/Fig_erro_rx.jpg');
figure; hold; plot(m_e(2,:)','b'); plot(sigma_e(2,:)','r'); plot(-sigma_e(2,:)','r'); title('erro ry');
saveas(gcf,'Resultados/Fig_erro_ry.jpg');
figure; hold; plot(m_e(3,:)','b'); plot(sigma_e(3,:)','r'); plot(-sigma_e(3,:)','r'); title('erro rz');
saveas(gcf,'Resultados/Fig_erro_rz.jpg');
% erros de velocidade:
figure; hold; plot(m_e(4,:)','b'); plot(sigma_e(4,:)','r'); plot(-sigma_e(4,:)','r'); title('erro vx');
saveas(gcf,'Resultados/Fig_erro_vx.jpg');
figure; hold; plot(m_e(5,:)','b'); plot(sigma_e(5,:)','r'); plot(-sigma_e(5,:)','r'); title('erro vy');
saveas(gcf,'Resultados/Fig_erro_vy.jpg');
figure; hold; plot(m_e(6,:)','b'); plot(sigma_e(6,:)','r'); plot(-sigma_e(6,:)','r'); title('erro vz');
saveas(gcf,'Resultados/Fig_erro_vz.jpg');
% erros de atitude:
figure; hold; plot(m_e(7,:)','b'); plot(sigma_e(7,:)','r'); plot(-sigma_e(7,:)','r'); title('erro alfa 1');
saveas(gcf,'Resultados/Fig_erro_a1.jpg');
figure; hold; plot(m_e(8,:)','b'); plot(sigma_e(8,:)','r'); plot(-sigma_e(8,:)','r'); title('erro alfa 2');
saveas(gcf,'Resultados/Fig_erro_a2.jpg');
figure; hold; plot(m_e(9,:)','b'); plot(sigma_e(9,:)','r'); plot(-sigma_e(9,:)','r'); title('erro alfa 3');
saveas(gcf,'Resultados/Fig_erro_a3.jpg');
