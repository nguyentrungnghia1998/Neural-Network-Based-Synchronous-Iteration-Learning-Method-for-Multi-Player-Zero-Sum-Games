%% Simulation of novel actor-critic-identifier - Bhashin 2013
clear; close all; clc;
%% Time interval and simulation time
Step = 0.0001;T_end = 5;
t = 0:Step:T_end;
%% Variable
x=cell(1,size(t,2));
u=cell(1,size(t,2));
d=cell(1,size(t,2));
W=cell(1,size(t,2));
%% Parameter
eta=50000;
%% Initial value
x{1}=1;
% W{1}=[0.6294    0.8116   -0.7460    0.8268    0.2647   -0.8049]';
W{1}=[0.5 0 0.7 0 -0.5 0]';
%% Simulation
for i=1:size(t,2)
    u{i}=-0.9*x{i}+0.1*sin(t(i));
    d{i}=0;
    Wa=W{1}(1:2);
    Wu=W{1}(3:4);
    Wd=W{1}(5:6);
    um=[x{i} x{i}^3]*Wu;
    dm=[x{i} x{i}^3]*Wd;
    if i==size(t,2)
        break
    end
    %% Update
    x{i+1}=x{i}+Step*(-x{i}+u{i}+d{i});
end

figure(1);
xm=cell2mat(x);
plot(t,xm);
figure(2);
uplot=cell2mat(u);
plot(t,uplot);
figure(3);
dplot=cell2mat(d);
plot(t,dplot);

for i=1:50001-25
    xdata=xm(i:i+25);
    udata=uplot(i:i+25);
    ddata=dplot(i:i+25);
    piV=[xdata(1)^2-xdata(end)^2 xdata(1)^4-xdata(end)^4];
    Wa=W{i}(1:2);
    Wu=W{i}(3:4);
    Wd=W{i}(5:6);
    um=Wu'*[xdata;xdata.^3];
    dm=Wd'*[xdata;xdata.^3];
    rmau=xdata.^2+um.^2-dm.^2;
    pi=Step*(sum(rmau)-rmau(1)/2-rmau(end)/2);
    piu1mau=-2.*(udata-um).*xdata;
    piu2mau=-2.*(udata-um).*xdata.^3;
    piU1=Step*(sum(piu1mau)-piu1mau(1)/2-piu1mau(end)/2);
    piU2=Step*(sum(piu2mau)-piu2mau(1)/2-piu2mau(end)/2);
    piU=[piU1 piU2];
    pid1mau=2.*(ddata-dm).*xdata;
    pid2mau=2.*(ddata-dm).*xdata.^3;
    piD1=Step*(sum(pid1mau)-pid1mau(1)/2-pid1mau(end)/2);
    piD2=Step*(sum(pid2mau)-pid2mau(1)/2-pid2mau(end)/2);
    piD=[piD1 piD2];
    pipi=[piV piU piD];
    dW=-eta*pipi'*(pipi*W{i}-pi);
    W{i+1}=W{i}+Step*dW;
end
% for i=0:1999
%     xdata=xm(25*i+1:25*i+26);
%     udata=uplot(25*i+1:25*i+26);
%     ddata=dplot(25*i+1:25*i+26);
%     piV=[xdata(1)^2-xdata(end)^2 xdata(1)^4-xdata(end)^4];
%     Wa=W{i+1}(1:2);
%     Wu=W{i+1}(3:4);
%     Wd=W{i+1}(5:6);
%     um=Wu'*[xdata;xdata.^3];
%     dm=Wd'*[xdata;xdata.^3];
%     rmau=xdata.^2+um.^2-dm.^2;
%     pi=Step*(sum(rmau)-rmau(1)/2-rmau(end)/2);
%     piu1mau=-2.*(udata-um).*xdata;
%     piu2mau=-2.*(udata-um).*xdata.^3;
%     piU1=Step*(sum(piu1mau)-piu1mau(1)/2-piu1mau(end)/2);
%     piU2=Step*(sum(piu2mau)-piu2mau(1)/2-piu2mau(end)/2);
%     piU=[piU1 piU2];
%     pid1mau=2.*(ddata-dm).*xdata;
%     pid2mau=2.*(ddata-dm).*xdata.^3;
%     piD1=Step*(sum(pid1mau)-pid1mau(1)/2-pid1mau(end)/2);
%     piD2=Step*(sum(pid2mau)-pid2mau(1)/2-pid2mau(end)/2);
%     piD=[piD1 piD2];
%     pipi=[piV piU piD];
%     dW=-eta*pipi'*(pipi*W{i+1}-pi);
%     W{i+2}=W{i+1}+Step*dW;
% end