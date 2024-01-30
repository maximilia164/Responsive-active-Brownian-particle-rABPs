function yf = RK(f,dt,tn,y0)

k1 = f(tn,y0);
k2 = f(tn+0.5*dt,y0+0.5*dt.*k1);
k3 = f(tn+0.5*dt,y0+0.5*dt.*k2);
k4 = f(tn+dt,y0+dt.*k3);
yf = y0 + (dt/6).*(k1+ 2.*k2 + 2.*k3 + k4);
         
%yf = y0 + (dt/6).*(f(tn,y0)+ 2.*f(tn+0.5*dt,y0+0.5*dt.*f(tn,y0)) + 2.*f(tn+0.5*dt,y0+0.5*dt.*f(tn+0.5*dt,y0+0.5*dt.*f(tn,y0))) + f(tn+dt,y0+dt.*f(tn+0.5*dt,y0+0.5*dt.*f(tn+0.5*dt,y0+0.5*dt.*f(tn,y0)))));
end
