%%--------------------------------------------------------------------------------
%% Função para o cálculo da jacobiana de h(x)
%%--------------------------------------------------------------------------------
function H = jacobiana_h(x,pG)

% Número de landmarks
q = size(pG,2);

% Jacobiana H = dh/dh
H = [];
for i = 1:q
	Hi = jacobiana_hi(x,pG(:,i));
	H = [H; Hi];
end

end
