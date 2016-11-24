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

%% Parametros da simulação
N = 10;     % n�mero de realiza��es para a simula��o MC
tf = 60;   % tempo de simula��o
Ts = 0.05;  % per�odo de amostragem dos sensores

%% Loop de Simula��o Monte Carlo

% Inicializa��es de �ndices de desempenho
m_e = zeros(9,tf/Ts+1);          % m�dia do erro de estima��o de x 
sigma_e = zeros(9,tf/Ts+1);      % desvio padr�o do erro de estima��o de x

% Arquivo de realizações
filename = ['realizacao_',num2str(N),'_',num2str(tf),'s.mat'];

for j=1:N

	disp(['Realização ',num2str(j),'/',num2str(N),'.']);
    	
    % Estados verdadeiros e medida dos sensores
	[x,u,y] = ler_realizacao(filename,j,tf);
        
    %% Estimador de estados (implemente o filtro aqui)
	xe = filtro_ekfcd(u,y,Ts);
    
    %% Atualiza��o dos �ndices de desempenho
    m_e = m_e + (x-xe);
	sigma_e = sigma_e + (x-xe).^2;


end % loop da simula��o MC

m_e = m_e/N;
sigma_e = sqrt(sigma_e/N - m_e.^2);

filename = ['ekfcd_',num2str(N),'_',num2str(tf),'s.mat'];
save(filename,'N','tf','x','xe','m_e','sigma_e');
