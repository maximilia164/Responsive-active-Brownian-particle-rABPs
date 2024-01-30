function yf = update3(obj,y)
%Fabio redid the RK method to be hard-coded for the single function eval
%do not call this if possible?
k1 = -1/obj.tau*(y-obj.y_set);
k2 = -1/obj.tau*(y+0.5*obj.dt.*k1-obj.y_set);   

k3 = -1/obj.tau*(y+0.5*obj.dt.*k2-obj.y_set);
k4 = -1/obj.tau*(y+obj.dt.*k3-obj.y_set);  
yf = y + (obj.dt/6).*(k1+ 2.*k2 + 2.*k3 + k4);
         
%yf = y0 + (dt/6).*(f(tn,y0)+ 2.*f(tn+0.5*dt,y0+0.5*dt.*f(tn,y0)) + 2.*f(tn+0.5*dt,y0+0.5*dt.*f(tn+0.5*dt,y0+0.5*dt.*f(tn,y0))) + f(tn+dt,y0+dt.*f(tn+0.5*dt,y0+0.5*dt.*f(tn+0.5*dt,y0+0.5*dt.*f(tn,y0)))));
end
