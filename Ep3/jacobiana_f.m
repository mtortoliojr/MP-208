%%--------------------------------------------------------------------------------
%% Função para o cálculo da jacobiana da função f(x,u)
%%--------------------------------------------------------------------------------
function F = jacobiana_f(x,u)

% Componente alfa de x
alfa = x(7:9);

% Componentes de u
ap_check = u(1:3);
wp_check = u(4:6);

% Cálculo da matrix DPG e de sua jacobiana em relação a alfa
DPG = matriz_DPG(alfa);
dDPG = jacobiana_DPG(alfa);

% Cálculo da matrix Alfa e de sua jacobiana em relação a alfa
Alfa = matriz_Alfa(alfa);
dAlfa = jacobiana_Alfa(alfa);

% --------------------------------------------------------------
% Inicialização da matriz jacobiana
% --------------------------------------------------------------
F = zeros(9,9);

% --------------------------------------------------------------
% Jacobiana F1 = df1/dx
% --------------------------------------------------------------
F1 = [zeros(3,3), eye(3,6)];

% --------------------------------------------------------------
% Jacobiana F2 = df2/dx
% --------------------------------------------------------------
F2 = [zeros(3,6), dDPG' * repmat(ap_check,1,3)];

% --------------------------------------------------------------
% Jacobiana df3/dx
% --------------------------------------------------------------
F3 = [zeros(3,6), dAlfa * repmat(w_check,1,3)];

% --------------------------------------------------------------
% Jacobiana F = df/dx
% --------------------------------------------------------------
F = [F1; F2; F3];

end
