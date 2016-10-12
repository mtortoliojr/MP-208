clear all;
close all;

res = estimador_map(10);
erro_rms_teor = res.erro.rms_teor;
erro_rms_real = res.erro.rms_real;
theta_est = res.theta.est;
theta_real = res.theta.real;
theta_med_est = res.med.est;
theta_med_real = res.med.real;
k = 1:res.k;
it = 1:res.it;
it_max = res.it;


erro_rms_real_med = mean(erro_rms_real)*ones(1,it_max);

figure(1)
hold on;
plot(it,erro_rms_teor,it,erro_rms_real,'r',it,erro_rms_real_med,'r--','LineWidth',2)
xlabel('Realizações');
ylabel('Erro RMS');
legend('Erro RMS teórico','Erro RMS do estimador MAP','Erro RMS médio do estimador MAP');
title(['Estimador MAP: Erros RMS para 100 realizações de theta e para k igual a 10.']);
hold off;
saveas(gcf,'fig1_b', 'jpg' );

figure(2)
hold on
subplot(2,1,1)
plot(it,theta_real(1,:),'b',it,theta_med_real(1)*ones(1,it_max),'b--',it,theta_est(1,:),'r',it,theta_med_est(1)*ones(1,it_max),'r--','LineWidth',2)
xlabel('Realizações');
ylabel('Valor de theta 1');
legend('Valor de theta 1 real','Valor médio de theta 1 real','Valor de theta 1 estimado','Valor médio de theta 1 estimado');
title(['Estimador MAP: Valores de theta 1 para 100 realizações e para k igual a 10.']);
hold off;

subplot(2,1,2)
hold on
plot(it,theta_real(2,:),'b',it,theta_med_real(2)*ones(1,it_max),'b--',it,theta_est(2,:),'r',it,theta_med_est(2)*ones(1,it_max),'r--','LineWidth',2)
xlabel('Realizações');
ylabel('Valor de theta 2');
legend('Valor de theta 2 real','Valor médio de theta 2 real','Valor de theta 2 estimado','Valor médio de theta 2 estimado');
title(['Estimador MAP: Valores de theta 2 para 100 realizações e para k igual a 10.']);
hold off;

saveas(gcf,'fig2_b', 'jpg' );
