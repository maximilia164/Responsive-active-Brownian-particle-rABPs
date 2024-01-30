function yf = RK3(obj,y0,n)

%params 
f = obj.dydt; %function called
% f_inst = obj.dydt_inst;
tn = n*obj.dt; %simulation time
dt = obj.dt; %time step
y_set = obj.y_set; %environmental value set in ODE3 of each particle 
scale = 1e+6; %for solver numerical integration problems vanishing gradients
yf = zeros(length(y_set),1); %initialise array - final particle values after response

%y0 = the previous stored particle value of V or DR

for i = 1:length(y_set)
    
    if y_set(i) < y0(i) %instant update if slowing down
    %can also consider hard code simple update, but this seems better
      yf(i) = y_set(i);
    %issue is that we have vector of values for each particle
%     k1 = f_inst(tn,y0.*scale,y_set.*scale);
%     k2 = f_inst(tn+0.5*dt,y0.*scale+0.5*dt.*k1,y_set.*scale);
%     k3 = f_inst(tn+0.5*dt,y0.*scale+0.5*dt.*k2,y_set.*scale);    
%     k4 = f_inst(tn+dt,y0.*scale+dt.*k3,y_set.*scale);
%     yf = y0.*scale + (dt/6).*(k1+ 2.*k2 + 2.*k3 + k4);
%     yf = yf*1e-6; 
    else %delay if increasing speed
        k1 = f(tn,y0(i)*scale,y_set(i)*scale);
        k2 = f(tn+0.5*dt,y0(i)*scale+0.5*dt.*k1,y_set(i)*scale);
        k3 = f(tn+0.5*dt,y0(i)*scale+0.5*dt.*k2,y_set(i)*scale);
        k4 = f(tn+dt,y0(i)*scale+dt.*k3,y_set(i)*scale);
        yf(i) = y0(i)*scale + (dt/6).*(k1+ 2.*k2 + 2.*k3 + k4);
        yf(i) = yf(i)*1e-6; 
    end
    
end
%yf = yf*1e-12; 
%yf = y0 + (dt/6).*(f(tn,y0)+ 2.*f(tn+0.5*dt,y0+0.5*dt.*f(tn,y0)) + 2.*f(tn+0.5*dt,y0+0.5*dt.*f(tn+0.5*dt,y0+0.5*dt.*f(tn,y0))) + f(tn+dt,y0+dt.*f(tn+0.5*dt,y0+0.5*dt.*f(tn+0.5*dt,y0+0.5*dt.*f(tn,y0)))));
end
