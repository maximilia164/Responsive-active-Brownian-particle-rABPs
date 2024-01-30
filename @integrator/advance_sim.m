function advance_sim(obj,sim,n)
rnx=sim.xbox;
rny=sim.ybox;
vnx=sim.vxbox;
vny=sim.vybox;
omegan=sim.omegabox;
thetan=sim.thetabox;
dt=sim.dt;
Np=sim.Np;
m=sim.m;
gamma=sim.gamma;
gammar=sim.gammar;
I=sim.I;
T=sim.T;
kb=sim.kb;

alphax_t=gamma; %the translational drag
alphay_t=gamma;

%rotational friction
if ~isempty(obj.response_DR) %empty if its not set
    sim.alpha_box=kb*T./obj.response_DR.output(rnx,rny,n);
else
    sim.alpha_box=gammar;
end

%active velocity
if ~isempty(obj.response_v) %if response is declared
    sim.v0_box=obj.response_v.output(rnx,rny,n); %input into simulation from output of response
else
    sim.v0_box=sim.v0;
end

%active torque
if ~isempty(obj.response_W)
    sim.W_box=obj.response_W.output(rnx,rny,n);
else
    sim.W_box=sim.W;
end

fx=gamma*sim.v0_box.*cos(thetan); %x-component of the active force
fy=gamma*sim.v0_box.*sin(thetan); %y-component of the active force
TOR=sim.W_box.*gammar; %active Torque



b=(1+gamma*dt/(2*m))^(-1); %enters the force equations
a=b*(1-gamma*dt/(2*m));

bt=(1+sim.alpha_box.*dt./(2*I)).^(-1); %for the orientations and so on
at=bt.*(1-sim.alpha_box.*dt./(2*I));


boxx=randn(Np,1); %noise in x
rx=rnx+b*dt*vnx+b*dt^2/(2*m)*fx+b*dt/(2*m)*sqrt(2*alphax_t*kb*T*dt)*boxx;
vxx=a*vnx+dt/(2*m)*(a*fx+fx)+b/m*sqrt(2*alphax_t*kb*T*dt)*boxx;

boxy=randn(Np,1);
ry=rny+b*dt*vny+b*dt^2/(2*m)*fy+b*dt/(2*m)*sqrt(2*alphay_t*kb*T*dt)*boxy;
vyy=a*vny+dt/(2*m)*(a*fy+fy)+b/m*sqrt(2*alphay_t*kb*T*dt)*boxy;

box_theta=randn(Np,1);

theta1=thetan+bt.*dt.*omegan+bt*dt^2/(2*I)*TOR+bt.*dt/(2*I).*sqrt(2*sim.alpha_box*kb*T*dt).*box_theta;
omega1=at.*omegan+dt/(2*I)*(a*TOR+TOR)+bt./I.*sqrt(2.*sim.alpha_box*kb*T*dt).*box_theta;

sim.xbox=rx;
sim.ybox=ry;
sim.vxbox=vxx;
sim.vybox=vyy;
sim.thetabox=theta1;
sim.omegabox=omega1;

%%
%Periodic boundary conditions

switch sim.PBC
    case 'periodic'        
        if numel(sim.L_box)>1
            Lx=sim.L_box(1);
            Ly=sim.L_box(2);
        else
            Lx=sim.L_box;
            Ly=sim.L_box;
        end
        sim.xbox(sim.xbox>=Lx) = sim.xbox(sim.xbox>=Lx)-2*Lx;
        sim.xbox(sim.xbox<=-Lx) = sim.xbox(sim.xbox<=-Lx)+2*Lx;
        
        sim.ybox(sim.ybox>=Ly) = sim.ybox(sim.ybox>=Ly)-2*Ly;
        sim.ybox(sim.ybox<=-Ly) = sim.ybox(sim.ybox<=-Ly)+2*Ly;
    case 'reflective'
        if numel(sim.L_box)>1
            Lx=sim.L_box(1);
            Ly=sim.L_box(2);
        else
            Lx=sim.L_box;
            Ly=sim.L_box;
        end
        sim.xbox(sim.xbox>=Lx) = sim.xbox(sim.xbox>=Lx)-2*(sim.xbox(sim.xbox>=Lx)-Lx);
        sim.xbox(sim.xbox<=-Lx) = sim.xbox(sim.xbox<=-Lx)+2*(-sim.xbox(sim.xbox<=-Lx)-Lx);       
        sim.ybox(sim.ybox>=Ly) = sim.ybox(sim.ybox>=Ly)-2*(sim.ybox(sim.ybox>=Ly)-Ly);
        sim.ybox(sim.ybox<=-Ly) = sim.ybox(sim.ybox<=-Ly)+2*(-sim.ybox(sim.ybox<=-Ly)-Ly);      
end

end