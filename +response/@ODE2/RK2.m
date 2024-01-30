function yf = RK2(obj,y0,n)

%params
f = obj.dydt;
tn = n*obj.dt;
dt = obj.dt;
y_set = obj.y_set;
scale = 1e+6;

k1 = f(tn,y0.*scale,y_set.*scale);
k2 = f(tn+0.5*dt,y0.*scale+0.5*dt.*k1,y_set.*scale);
k3 = f(tn+0.5*dt,y0.*scale+0.5*dt.*k2,y_set.*scale);
k4 = f(tn+dt,y0.*scale+dt.*k3,y_set.*scale);
yf = y0.*scale + (dt/6).*(k1+ 2.*k2 + 2.*k3 + k4);
yf = yf*1e-6; 
%yf = yf*1e-12; 
%yf = y0 + (dt/6).*(f(tn,y0)+ 2.*f(tn+0.5*dt,y0+0.5*dt.*f(tn,y0)) + 2.*f(tn+0.5*dt,y0+0.5*dt.*f(tn+0.5*dt,y0+0.5*dt.*f(tn,y0))) + f(tn+dt,y0+dt.*f(tn+0.5*dt,y0+0.5*dt.*f(tn+0.5*dt,y0+0.5*dt.*f(tn,y0)))));
end
