function res = estimador_ls(k)

%% Estrutura para armazenar o resultado
erro_t = struct('rms_teor',[],'rms_real','vals');
theta_t = struct('est',[],'real',[]);
media_t = struct('est',0,'real',0);
res = struct('erro',erro_t,'theta',theta_t,'med',media_t,'k',0,'it',0);

%% Número de realizações
it_max = 100;

%% Definição da variável aleatória theta
m_theta = [1 2]';
P_theta = diag([0.01,0.04]);

%% Definição da variável aleatória vi
R = 0.01;

%% Implementação
theta_est = zeros(2,it_max);
theta_real = zeros(2,it_max);
theta_erro = zeros(2,it_max);
erro_rms = zeros(1,it_max);
erro_rms_teor = zeros(1,it_max);

rng(0,'twister');
for it=1:it_max
    
    % Realização da va theta
    theta = m_theta + chol(P_theta)*randn(2,1);
    
    % Geração das medidas yi
    y = zeros(1,k);
    Pk = 0;
    H_Wi_y = 0;
    H_R_H = 0;
    wi = 1;
    for i=1:k
        % Realização da va vi
        vi = sqrt(R)*randn;
        % Equação de medida
        hi = [i,1];
        yi = hi*theta + vi;
        % Fator Pk = hi'*wi*hi
        Pk = Pk + hi' * wi * hi;
        % Fator Hi'*Wi*yi
        H_Wi_y = H_Wi_y + hi'* wi *yi;
        % Fator Hi'*R*yi
        H_R_H = H_R_H + hi'* R * hi;
    end
    % Fator Pk
    Pk = inv(Pk);
    % Estimador LS batch
    theta_real(:,it) = theta;
    theta_est(:,it) = Pk * H_Wi_y;
    
    % Erro RMS
    erro = (theta - theta_est(:,it));
    theta_erro(:,it) = erro;
    erro_rms_real(it) = sqrt(erro'*erro);
    
    % Erro RMS teórico
    erro_rms_teor(it) = sqrt(trace(Pk*H_R_H*Pk));
end
it = 1:it_max;

%plot(it,erro_rms_real,it,erro_rms_teor,'r');
theta_med_est = mean(theta_est,2);
theta_med_real = mean(theta_real,2);

res.erro.rms_teor = erro_rms_teor;
res.erro.rms_real = erro_rms_real;
res.erro.vals = theta_erro;
res.theta.est = theta_est;
res.theta.real = theta_real;
res.med.est = theta_med_est;
res.med.real = theta_med_real;
res.k = k;
res.it = it_max;
