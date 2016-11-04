%%--------------------------------------------------------------------------------
%% Função para o cálculo da jacobiana de hi(x)
%%--------------------------------------------------------------------------------
function Hi = jacobiana_hi(x,pGi)

% Parâmetros
f = 1;
DCP = diag([1,-1,-1]);
rPCP = [0 0 0]';

% Componente rGPG e alfa de x
rGPG = x(1:3);
alfa = x(7:9);

% Cálculo da matrix DPG e sua jacobiana
DPG = matriz_DPG(alfa);
dDPG = jacobiana_DPG(alfa);

% Cálculo de sCi
sCi = DCP * DPG(alfa) * (pGi - rGPG) - DCP * rPCP

% --------------------------------------------------------------
% dsCi = d(sCi)/d(rGPG)
% dhir = d(hi)/d(rGPG)
% --------------------------------------------------------------
dsCi = -(DCP * DPG);

dhir = zeros(2,3);
dhir(1,1) = [dsCi(1,1) * sCi(3) - sCi(1) * dsCi(3,1)];
dhir(1,2) = [dsCi(1,2) * sCi(3) - sCi(1) * dsCi(3,2)];
dhir(1,3) = [dsCi(1,3) * sCi(3) - sCi(1) * dsCi(3,3)];
dhir(2,1) = [dsCi(2,1) * sCi(3) - sCi(2) * dsCi(3,1)];
dhir(2,2) = [dsCi(2,2) * sCi(3) - sCi(2) * dsCi(3,2)];
dhir(2,3) = [dsCi(2,3) * sCi(3) - sCi(2) * dsCi(3,3)];
dhir = f * dhir / sci(3)^2;

% --------------------------------------------------------------
% dsci = d(sCi)/d(alfa)
% dhia = d(hi)/d(alfa)
% --------------------------------------------------------------
dsCi = (DCP * dDPG) * repmat(pGi - rGPG,1,3);

dhia = zeros(2,3);
dhia(1,1) = [dsCi(1,1) * sCi(3) - sCi(1) * dsCi(3,1)];
dhia(1,2) = [dsCi(1,2) * sCi(3) - sCi(1) * dsCi(3,2)];
dhia(1,3) = [dsCi(1,3) * sCi(3) - sCi(1) * dsCi(3,3)];
dhia(2,1) = [dsCi(2,1) * sCi(3) - sCi(2) * dsCi(3,1)];
dhia(2,2) = [dsCi(2,2) * sCi(3) - sCi(2) * dsCi(3,2)];
dhia(2,3) = [dsCi(2,3) * sCi(3) - sCi(2) * dsCi(3,3)];
dhia = f * dhia / sci(3)^2;

% --------------------------------------------------------------
% Jacobiana
% --------------------------------------------------------------
Hi = [dhir, zeros(2,3), dhia];

end
