%%--------------------------------------------------------------------------------
%% Função para integração da EDO de x
%%--------------------------------------------------------------------------------
function P2 = integral_edo_P(x1,uk,P1,Q,Ts)

% Cálculo da matriz G(t)
G = funcao_g(x1);

% Cálculo de G*Q*G'
GQG = G * Q * G';

% Cálculo da matriz F(t)
F = jacobiana_f(x1,uk);

% ------------------------------------
% Método de Runge-Kutta de Ordem 4
% ------------------------------------

% Passo de integração
h = Ts;

% Termo k1
k1 = F * P1 + P1 * F' + GQG;

% Termo k2
k2 = F * (P1 + 0.5*h*k1) + (P1 + 0.5*h*k1) * F' + GQG;

% Termo k3
k3 = F * (P1 + 0.5*h*k2) + (P1 + 0.5*h*k2) * F' + GQG;

% Termo k4
k4 = F * (P1 + h*k3) + (P1 + h*k3) * F' + GQG;

% Integração
P2 = P1 + (h/6) * (k1 + 2*k2 + 2*k3 + k4);

end
