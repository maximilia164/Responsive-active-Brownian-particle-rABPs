clear all; close all; clc

rng('shuffle','simdTwister')
pp=what('DR_Localisation_map');
path=pp.path;

%ideal for single tests or short-time sims e.g. TS analysis

%average for the lengthscale
v0 = 5; 
L = 10; %for L/v ratio - can make vector
gap = v0*L;%50*1e-6;%linspace(5,100,20).*1e-6; %gap/box size L/v = 22 for kappa test
tau = [0.1,0.5,1,3,5,10];%unique(round(logspace(-0.602,0,1000),4));

%tau(end) = [] %drop final element
% tau(1) = []; %drop first element
%
Np=10; %1e1 number particles 
dt=1e-3;%integration step
N = 2e5;  %1e5 total number of steps DEFAULT 1e8!! 
delta=50;%every data points saved
%!!! N/delta must be a whole number

W=0/180*pi; %angular velocity rad/s
PBC = 0; %turn PBC off for time series analysis
verbose = 0;

% kappa_Dr = 1000; %ratio between Dr_min, Dr_max 
% Dr_min = 0.010295335381257;
% Dr_max = Dr_min*kappa_Dr;

kappa_v0 = 10;
v0_min = 0.3e-6;
v0_max = v0_min*kappa_v0;

% W_min = 0;
% W_max = 10;

pathprova=[path];

for i = 1:numel(tau)
    Running_Sims_function(Np,dt,N,delta,gap,[gap*10 gap*10],v0,tau(i),v0_min,v0_max,W,verbose,pathprova,PBC);
end


