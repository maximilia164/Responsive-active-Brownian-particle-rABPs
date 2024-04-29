clear all; close all; clc

rng('shuffle','simdTwister')
pp=what('TEST');
path=pp.path;

%ideal for single tests or short-time sims e.g. TS analysis

%average for the lengthscale
v0 = 5e-6; 
L = 10; %for L/v ratio - can make vector
gap = v0*L;%50*1e-6;%linspace(5,100,20).*1e-6; %gap/box size L/v = 22 for kappa test
tau = [3];%unique(round(logspace(-0.602,0,1000),4));

%tau(end) = [] %drop final element
% tau(1) = []; %drop first element

Np=100; %1e1 number particles 
dt=1e-3;%integration step
N = 1e5;  %1e5 total number of steps DEFAULT 1e8!! 
delta=50;%every data points saved
%!!! N/delta must be a whole number

W=0/180*pi; %angular velocity rad/s
PBC = ''; %'periodic', turn PBC off for time series analysis
verbose = 0;
period = 5;

%default mu = 1, sigma = 0, for no change - gaussian distribution
mu = 1; %mean of gaussian multiplying the velocities 
sigma = 0; %stddev of gaussian multiplying the velocities
%place here - prevents different initialisations in each parallel pool
gauss = abs(normrnd(mu,sigma,[Np,1]));

% kappa_Dr = 1000; %ratio between Dr_min, Dr_max 
Dr_min = 0.1;%0.010295335381257;
Dr_max = 1;%Dr_min*kappa_Dr;

kappa_v0 = 10;
v0_min = 1e-6;%1e-6;%0.3e-6;
v0_max = v0_min*kappa_v0;%v0_min*kappa_v0;

W_min = [];
W_max = [];

y_min = {v0_min Dr_min W_min};
y_max = {v0_max Dr_max W_max};

env = 'checker'; %'checker', 'sinusoid' are the options for now

%Defining the ODE to be used and the landscape (whether it shifts with time)
ode = 'Hysteresis_Temporal'; %'Standard', 'Hysteresis', 'Standard_Temporal', 'Hysteresis_Temporal', 'ZOH', 'ZOH_delay'
% ODE2, ODE3, ODE2_Temporal, ODE3_Temporal respectively - where ODE3 allows for hysteretic response, ODE2 is classic fast RK solver,
%and X_temporal causes the landscape to shift with time. ODE3_temporal not yet implemented


rand_init = 1;

pathprova=[path];

for i = 1:numel(tau)
    Running_Sims_function(Np,dt,N,delta,gap,[gap*period gap*period],v0,tau(i),y_min,y_max,W,verbose,pathprova,PBC,gauss,env,ode,rand_init);
end


