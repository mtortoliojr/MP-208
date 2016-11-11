%%--------------------------------------------------------------------------------
%% Função para o cálculo de hi(x,pGi)
%%--------------------------------------------------------------------------------
function hi = funcao_hi(x,pGi)

% Parâmetros físcos e do modelo
param = ler_parametros();

% Parâmetros
f = param.fisico.f;
DCP = param.fisico.DCP;
rPCP = param.fisico.rPCP;

% Componentes de x
rGPG = x(1:3);
alfa = x(7:9);

% Cálculo da matrix DPG e Alfa
DPG = matriz_DPG(alfa);

% --------------------------------------------------------------
% Vetor sCi
% --------------------------------------------------------------
sCi = DCP * DPG * (pGi - rGPG) - DCP * rPCP;

% --------------------------------------------------------------
% Vetor hi
% --------------------------------------------------------------
hi = f * [sCi(1);sCi(2)] / sCi(3);

end
