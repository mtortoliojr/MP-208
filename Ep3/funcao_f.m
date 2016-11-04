%%--------------------------------------------------------------------------------
%% Função para o cálculo de f(x,u)
%%--------------------------------------------------------------------------------
function f = funcao_f(x,u)

% Componentes de u
ap_check = u(1:3);
wp_check = u(4:6);

% Vetor g
g = 9.81;
gG = [0 0 -g];

% Cálculo da matrix DPG e A
DPG = Matriz_DPG(x(7:9));
A = Matriz_A(x(7:9));

% --------------------------------------------------------------
% f1
% --------------------------------------------------------------
f1 = x(4:6);

% --------------------------------------------------------------
% f2
% --------------------------------------------------------------
f2 = DPG' * ap_check + gG;

% --------------------------------------------------------------
% f3
% --------------------------------------------------------------
f3 = A * wp_check;

% --------------------------------------------------------------
% f(x)
% --------------------------------------------------------------
f = [f1; f2; f3];

end
