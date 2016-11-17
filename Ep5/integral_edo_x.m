%%--------------------------------------------------------------------------------
%% Função para integração da EDO de x
%%--------------------------------------------------------------------------------
function x2 = integral_edo_x(x1,uk,wk,Ts)

% ------------------------------------
% Método de Runge-Kutta de Ordem 4
% ------------------------------------

% Passo de integração
h = Ts;

% Termos k1, k2, k3 e k4
k1 = funcao_f(x1,uk) + funcao_g(x1)*wk;
k2 = funcao_f(x1+0.5*h*k1,uk) + funcao_g(x1+0.5*h*k1)*wk;
k3 = funcao_f(x1+0.5*h*k2,uk) + funcao_g(x1+0.5*h*k2)*wk;
k4 = funcao_f(x1+h*k3,uk) + funcao_g(x1+h*k3)*wk;

% Integração
x2 = x1 + (h/6) * (k1 + 2*k2 + 2*k3 + k4);

end
