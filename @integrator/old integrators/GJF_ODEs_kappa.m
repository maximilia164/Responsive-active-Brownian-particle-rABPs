function GJF_ODEs_kappa(obj,n)
dt=obj.dt;
Np=obj.Np;
m=obj.m;
gamma=obj.gamma;
gammar=obj.gammar;
I=obj.I;
v0=obj.v0;
T=obj.T;
kb=obj.kb;
gap=obj.gap;
tau=obj.tau;
alphax_t=gamma;
alphay_t=gamma;

kappa = obj.kappa;
Amp   = obj.Amp;

fx=gamma*v0*cos(obj.thetabox); %x-component of the active force
fy=gamma*v0*sin(obj.thetabox); %y-component of the active force
%TOR=W*gammar; %active Torque

b=(1+gamma*dt/(2*m))^(-1); %GJF coeffs
a=b*(1-gamma*dt/(2*m));


dydt=@(t,y,a_set)-1/tau*(y-a_set); %ode

if tau>0
    alpha_setpoint= 2e-3*gammar./(((Amp-kappa*Amp)*((sin(pi*obj.xbox./gap)).*(sin(pi*obj.ybox./gap)))) + (kappa*Amp) + Amp);
    %sin curve
    %alpha_setpoint - value set by checkerboard
    if n==1 %initial condition
            alpha_thetat=alpha_setpoint;
            obj.alphabox=alpha_thetat;     
%           [~,alpha_thetat] = ode45(@(t,y)dydt(t,y,alpha_setpoint),[0 dt],alpha_setpoint);   
    else
            alpha_thetat=obj.alphabox;
            obj.alphabox=obj.RK(@(t,y)dydt(t,y,alpha_setpoint),dt,n*dt,alpha_thetat);
%           [~,alpha_thetat] = ode45(@(t,y)dydt(t,y,alpha_setpoint),[0 dt],alpha_thetat);  
    end  
    %yf corresponds to the alpha values for each particle (RK solver)
else
    alpha_thetat=2e-3*gammar./(((Amp-kappa*Amp)*((sin(pi*obj.xbox./gap)).*(sin(pi*obj.ybox./gap)))) + (kappa*Amp) + Amp);
    %obj.alphabox=alpha_thetat;
    %alpha_thetat = alpha_setpoint if tau = 0
end

%rotational GJF coeffs
bt=(1+alpha_thetat.*dt./(2*I)).^(-1);
at=bt.*(1-alpha_thetat.*dt./(2*I));

%GJF solver position/velocity
boxx=randn(Np,1);
rx=obj.xbox+b*dt*obj.vxbox+b*dt^2/(2*m)*fx+b*dt/(2*m)*sqrt(2*alphax_t*kb*T*dt)*boxx;
vxx=a*obj.vxbox+dt/(2*m)*(a*fx+fx)+b/m*sqrt(2*alphax_t*kb*T*dt)*boxx;

boxy=randn(Np,1);
ry=obj.ybox+b*dt*obj.vybox+b*dt^2/(2*m)*fy+b*dt/(2*m)*sqrt(2*alphay_t*kb*T*dt)*boxy;
vyy=a*obj.vybox+dt/(2*m)*(a*fy+fy)+b/m*sqrt(2*alphay_t*kb*T*dt)*boxy;

%GJF solver theta/angular v
box_theta=randn(Np,1);
theta1=obj.thetabox+bt.*dt.*obj.omegabox+bt.*dt/(2*I).*sqrt(2*alpha_thetat*kb*T*dt).*box_theta;
omega1=at.*obj.omegabox+bt./I.*sqrt(2.*alpha_thetat*kb*T*dt).*box_theta;

obj.xbox=rx;
obj.ybox=ry;
obj.vxbox=vxx;
obj.vybox=vyy;
obj.thetabox=theta1;
obj.omegabox=omega1;

%%
%Periodic boundary conditions
if obj.PBC==1
    
    obj.xbox(obj.xbox>=obj.L_box) = obj.xbox(obj.xbox>=obj.L_box)-2*obj.L_box;
    obj.xbox(obj.xbox<=-obj.L_box) = obj.xbox(obj.xbox<=-obj.L_box)+2*obj.L_box;
    
    obj.ybox(obj.ybox>=obj.L_box) = obj.ybox(obj.ybox>=obj.L_box)-2*obj.L_box;
    obj.ybox(obj.ybox<=-obj.L_box) = obj.ybox(obj.ybox<=-obj.L_box)+2*obj.L_box;
end

end