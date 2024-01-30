function Plot(obj)
n=3;
x=linspace(-n*obj.L,n*obj.L,round(n*2*400));
[X,Y]=meshgrid(x,x);

colormap(flipud(gray))
s=surf(X,Y,obj.output(X,Y),'FaceColor','interp');
max(max(obj.output(X,Y)))
min(min(obj.output(X,Y)))
view(-15,80)
s.LineStyle='none';
alpha(1)

axis([-n*obj.L n*obj.L -n*obj.L n*obj.L obj.ymin obj.ymax])
xticks(-n*obj.L:obj.L:n*obj.L)
yticks(-n*obj.L:obj.L:n*obj.L)

colorbar
grid off
box on
title(['L = ' num2str(obj.L)])
set(gca,'color','w')
set(gcf,'color','w')
pbaspect([1 1 1])
end