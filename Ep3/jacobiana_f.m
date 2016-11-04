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
Alfa = matriz_A(alfa);
dAlfa = jacobiana_A(alfa);

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
dDPG1 = dDPG(:,1:3); dDPG2 = dDPG(:,4:6); dDPG3 = dDPG(:,7:9);
F2 = [zeros(3,6), dDPG1' * ap_check, dDPG2' * ap_check, dDPG3' * ap_check];

% --------------------------------------------------------------
% Jacobiana df3/dx
% --------------------------------------------------------------
dAlfa1 = dAlfa(:,1:3); dAlfa2 = dAlfa(:,4:6); dAlfa3 = dAlfa(:,7:9); 
F3 = [zeros(3,6), dAlfa1 * wp_check, dAlfa2 * wp_check, dAlfa3 * wp_check];

% --------------------------------------------------------------
% Jacobiana F = df/dx
% --------------------------------------------------------------
F = [F1; F2; F3];

end
