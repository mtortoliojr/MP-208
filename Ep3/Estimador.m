%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simula��o MC de algoritmos de navega��o
% Problema: Inertial-Vision Navigation from Landmark Vector Measurements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Prof. Davi Ant�nio dos Santos
% Local: Instituto Tecnol�gico de Aerona�tica
% Data: 12/10/2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear;

seed_offset = 0;

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
    
    sim('Plataforma2');

    % Estados verdadeiros
    
    x(1:3,:) = r.signals.values';
    x(4:6,:) = v.signals.values';
    x(7:9,:) = a.signals.values';

    % Medidas dos sensores
    
    u(1:3,:) = am.signals.values';
    u(4:6,:) = wm.signals.values';
    y(1:2,:) = y1.signals.values';
    y(3:4,:) = y2.signals.values';
    
    %% Estimador de estados (implemente o filtro aqui)

    %---------------------------------------------------------------------------------------------
	filtro_ekf(x,u,y,tf,TS)
    %xe = x + randn(9,tf/Ts+1); % estimador fake s� para testar os �ndices
    xe = x(:,1) + randn(9,1); % estimador fake s� para testar os �ndices
    
    % inicializa��o do estimador
    % ...
	% ...
    % loop de estima��o
    % for k=1:tf/Ts,
    %    xe = ...             % estado estimado
    %...
    

    %---------------------------------------------------------------------------------------------
    
    %% Atualiza��o dos �ndices de desempenho
    %m_e = m_e + (x-xe);
	%sigma_e = sigma_e + (x-xe).^2;


end % loop da simula��o MC

m_e = m_e/N;
sigma_e = sqrt(sigma_e/N - m_e.^2);


% Gr�ficos
% erros de posi��o:
figure; hold; plot(m_e(1,:)','b'); plot(sigma_e(1,:)','r'); plot(-sigma_e(1,:)','r'); title('erro rx');
figure; hold; plot(m_e(2,:)','b'); plot(sigma_e(2,:)','r'); plot(-sigma_e(2,:)','r'); title('erro ry');
figure; hold; plot(m_e(3,:)','b'); plot(sigma_e(3,:)','r'); plot(-sigma_e(3,:)','r'); title('erro rz');
% erros de velocidade:
figure; hold; plot(m_e(4,:)','b'); plot(sigma_e(4,:)','r'); plot(-sigma_e(4,:)','r'); title('erro vx');
figure; hold; plot(m_e(5,:)','b'); plot(sigma_e(5,:)','r'); plot(-sigma_e(5,:)','r'); title('erro vy');
figure; hold; plot(m_e(6,:)','b'); plot(sigma_e(6,:)','r'); plot(-sigma_e(6,:)','r'); title('erro vz');
% erros de atitude:
figure; hold; plot(m_e(7,:)','b'); plot(sigma_e(7,:)','r'); plot(-sigma_e(7,:)','r'); title('erro alfa 1');
figure; hold; plot(m_e(8,:)','b'); plot(sigma_e(8,:)','r'); plot(-sigma_e(8,:)','r'); title('erro alfa 2');
figure; hold; plot(m_e(9,:)','b'); plot(sigma_e(9,:)','r'); plot(-sigma_e(9,:)','r'); title('erro alfa 3');
% erros de biases dos aceler�metros:
figure; hold; plot(m_e(10,:)','b'); plot(sigma_e(10,:)','r'); plot(-sigma_e(10,:)','r'); title('erro beta_a x');
figure; hold; plot(m_e(11,:)','b'); plot(sigma_e(11,:)','r'); plot(-sigma_e(11,:)','r'); title('erro beta_a y');
figure; hold; plot(m_e(12,:)','b'); plot(sigma_e(12,:)','r'); plot(-sigma_e(12,:)','r'); title('erro beta_a z');
% erros de biases dos gir�metros:
figure; hold; plot(m_e(13,:)','b'); plot(sigma_e(13,:)','r'); plot(-sigma_e(13,:)','r'); title('erro beta_g x');
figure; hold; plot(m_e(14,:)','b'); plot(sigma_e(14,:)','r'); plot(-sigma_e(14,:)','r'); title('erro beta_g y');
figure; hold; plot(m_e(15,:)','b'); plot(sigma_e(15,:)','r'); plot(-sigma_e(15,:)','r'); title('erro beta_g z');






