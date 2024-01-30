function GJF_ODEs(obj,n)
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

variable = obj.variable;

%TOR=W*gammar; %active Torque

b=(1+gamma*dt/(2*m))^(-1); %GJF coeffs
a=b*(1-gamma*dt/(2*m));

kappa = obj.kappa;
Amp   = obj.Amp;

% dydt=@(t,y,a_set)-1/tau*(y-a_set); %ode
if variable == 0
    if tau>0
        alpha_setpoint= 2e-3*gammar./(((Amp-kappa*Amp)*((sin(pi*obj.xbox./gap)).*(sin(pi*obj.ybox./gap)))) + (kappa*Amp) + Amp);
        if n==1 %initial condition
            alpha_thetat=alpha_setpoint;
            obj.alphabox=alpha_thetat;     
%           [~,alpha_thetat] = ode45(@(t,y)dydt(t,y,alpha_setpoint),[0 dt],alpha_setpoint);   
        else
            alpha_thetat=obj.alphabox;
            obj.alphabox=obj.RK(@(t,y)obj.dydt(t,y,alpha_setpoint),dt,n*dt,alpha_thetat);
%           [~,alpha_thetat] = ode45(@(t,y)dydt(t,y,alpha_setpoint),[0 dt],alpha_thetat);  
        end  
    %yf corresponds to the alpha values for each particle (RK solver)
    else
    alpha_thetat= 2e-3*gammar./(((Amp-kappa*Amp)*((sin(pi*obj.xbox./gap)).*(sin(pi*obj.ybox./gap)))) + (kappa*Amp) + Amp);
    %obj.alphabox=alpha_thetat;
    %alpha_thetat = alpha_setpoint if tau = 0
    end
    
end

if variable == 1
    alpha_thetat=gammar;
    obj.alphabox = alpha_thetat;
    if tau>0
        v0_setpoint=(v0/2).*(((Amp)*((sin(pi*obj.xbox./gap)).*(sin(pi*obj.ybox./gap)))) + Amp);
        if n==1 %initial condition
            v0_t=v0_setpoint;
            obj.v0_box=v0_t;     
        else
            v0_t=obj.v0_box;
            obj.v0_box=obj.RK(@(t,y)obj.dydt(t,y,v0_setpoint),dt,n*dt,v0_t);  
        end

    else
    v0_t=(v0/2).*(((Amp)*((sin(pi*obj.xbox./gap)).*(sin(pi*obj.ybox./gap)))) + Amp);
    end
end

if variable ==1
    fx=gamma*v0_t.*cos(obj.thetabox); %x-component of the active force
    fy=gamma*v0_t.*sin(obj.thetabox); %y-component of the active force
else
    fx=gamma*v0*cos(obj.thetabox); %x-component of the active force
    fy=gamma*v0*sin(obj.thetabox); %y-component of the active force
end

%rotational GJF coeffs
bt=(1+alpha_thetat.*dt./(2*I)).^(-1);
at=bt.*(1-alpha_thetat.*dt./(2*I));

%GJF solver position/velocity
boxx=randn(Np,1); %Dt random
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