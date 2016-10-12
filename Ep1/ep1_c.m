clear all;
close all;

res = estimador_ls(10);
erro_rms_teor_ls = res.erro.rms_teor;
erro_rms_real_ls = res.erro.rms_real;
theta_est_ls = res.theta.est;
theta_real_ls = res.theta.real;
theta_med_est_ls = res.med.est;
theta_med_real_ls = res.med.real;
k = 1:res.k;
it = 1:res.it;
it_max = res.it;
erro_rms_real_med_ls = mean(erro_rms_real_ls)*ones(1,it_max);

res = estimador_map(10);
erro_rms_teor_map = res.erro.rms_teor;
erro_rms_real_map = res.erro.rms_real;
theta_est_map = res.theta.est;
theta_real_map = res.theta.real;
theta_med_est_map = res.med.est;
theta_med_real_map = res.med.real;
erro_rms_real_med_map = mean(erro_rms_real_map)*ones(1,it_max);

theta1_med_real = theta_med_real_ls(1,:)*ones(1,it_max);
theta2_med_real = theta_med_real_ls(2,:)*ones(1,it_max);

figure(1)
hold on;
subplot(2,1,1)
plot(it,theta_real_ls(1,:),'g',it,theta1_med_real,'--g',it,theta_est_ls(1,:),'b',it,theta_med_est_ls(1)*ones(1,it_max),'b--',it,theta_est_map(1,:),'r',it,theta_med_est_map(1)*ones(1,it_max),'r--','LineWidth',2)
xlabel('Realizações');
ylabel('Valores estimados de theta 1');
legend('Theta 1 real (realização)','Theta 1 real médio','Theta 1 estimado LS','Theta 1 estimado médio LS','Theta 1 estimado MAP','Theta 1 estimado médio MAP');
title(['Comparação entre os estimadores LS e MAP']);
hold off;

hold on;
subplot(2,1,2)
plot(it,theta_real_ls(2,:),'g',it,theta2_med_real,'--g',it,theta_est_ls(2,:),'b',it,theta_med_est_ls(2)*ones(1,it_max),'b--',it,theta_est_map(2,:),'r',it,theta_med_est_map(2)*ones(1,it_max),'r--','LineWidth',2)
xlabel('Realizações');
ylabel('Valores estimados de theta 2');
legend('Theta 2 real (realização)','Theta 2 real médio','Theta 2 estimado LS','Theta 2 estimado médio LS','Theta 2 estimado MAP','Theta 2 estimado médio MAP');
title(['Comparação entre os estimadores LS e MAP']);
hold off;

saveas(gcf,'fig1_c', 'jpg' );


figure(2)
hold on;
plot(it,erro_rms_real_ls,it,erro_rms_real_med_ls,'b--',it,erro_rms_real_map,'r',it,erro_rms_real_med_map,'r--','LineWidth',2)
xlabel('Realizações');
ylabel('Erro RMS');
legend('Erro RMS do estimador LS','Erro RMS médio do estimador LS','Erro RMS do estimador MAP','Erro RMS médio do estimador MAP');
title(['Comparação entre os estimadores LS e MAP']);
hold off;
saveas(gcf,'fig2_c', 'jpg' );

