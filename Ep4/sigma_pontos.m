%%--------------------------------------------------------------------------------
%% Função para gerar o sigma-ponto de índice i
%%--------------------------------------------------------------------------------
function xai = sigma_pontos(xa_,Pa_sqrt,i)

% Dimensão do estado aumentado
na = length(xa_);

% Constante Kappa
kappa = 3 - na;

% Sigma-ponto

if i == 1
	xai = xa_;
else if i <= na+1
	xai = xa_ + sqrt(na + kappa) * Pa_sqrt(:,i-1);
else
	i = i - na;
    xai = xa_ - sqrt(na + kappa) * Pa_sqrt(:,i-1);
end

end
