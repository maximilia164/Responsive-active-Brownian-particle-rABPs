function GJF_ZOH_BWRD(obj,n)
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
alpha_thetat=obj.alphabox;
alphax_t=gamma;
alphay_t=gamma;

fx=gamma*v0*cos(obj.thetabox); %x-component of the active force
fy=gamma*v0*sin(obj.thetabox); %y-component of the active force
%TOR=W*gammar; %active Torque

b=(1+gamma*dt/(2*m))^(-1);
a=b*(1-gamma*dt/(2*m));



if tau>0
    c=floor(dt*n/tau);
    if n==1
        alpha_thetat=gammar/2*(obj.SQW(obj.xbox./(gap/2)*pi/2+pi/2).*obj.SQW(obj.ybox./(gap/2)*pi/2+pi/2))+gammar/2+gammar*1e-3;
        obj.alphabox=alpha_thetat;
        obj.alpha_future=alpha_thetat;
    else
        if dt*n==c*tau
            alpha_thetat=obj.alpha_future;
            obj.alphabox=alpha_thetat;
            obj.alpha_future=gammar/2*(obj.SQW(obj.xbox./(gap/2)*pi/2+pi/2).*obj.SQW(obj.ybox./(gap/2)*pi/2+pi/2))+gammar/2+gammar*1e-3;
        end
    end
    
else
    alpha_thetat=gammar/2*(obj.SQW(obj.xbox./(gap/2)*pi/2+pi/2).*obj.SQW(obj.ybox./(gap/2)*pi/2+pi/2))+gammar/2+gammar*1e-3;
    %obj.alphabox=alpha_thetat;
end


bt=(1+alpha_thetat.*dt./(2*I)).^(-1);
at=bt.*(1-alpha_thetat.*dt./(2*I));

boxx=randn(Np,1);
rx=obj.xbox+b*dt*obj.vxbox+b*dt^2/(2*m)*fx+b*dt/(2*m)*sqrt(2*alphax_t*kb*T*dt)*boxx;
vxx=a*obj.vxbox+dt/(2*m)*(a*fx+fx)+b/m*sqrt(2*alphax_t*kb*T*dt)*boxx;

boxy=randn(Np,1);
ry=obj.ybox+b*dt*obj.vybox+b*dt^2/(2*m)*fy+b*dt/(2*m)*sqrt(2*alphay_t*kb*T*dt)*boxy;
vyy=a*obj.vybox+dt/(2*m)*(a*fy+fy)+b/m*sqrt(2*alphay_t*kb*T*dt)*boxy;

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