clc; clear all; close all
%Sinusoidal mapping

%set up the grid
Lx = 10;
Ly = Lx;
gridsz = 0.1;
period = 3;

meshx = -Lx*period:gridsz:Lx*period;
meshy = -Ly*period:gridsz:Ly*period;

[X,Y] = meshgrid(meshx,meshy);

scale = 10;
ymin = 1;
ymax = ymin*scale;

func = @(x,y,t) (ymin-ymax)/2*(1+sin(x./(Lx)*pi+pi/2)...
                .*sin(y./(Ly)*pi+pi/2))+ymax;

test = func(X,Y);
surf(X,Y,test)

%%

func_time = @(x,y,t) (ymin-ymax)/2*(1+sin((x+ymin*(t-1))/(Lx)*pi+pi/2)...
                .*sin((y+ymin*(t-1))./(Ly)*pi+pi/2))+ymax;

for t = 1:31
    test = func_time(X,Y,t);
    figure()
    imagesc(test)
    h = colorbar;
    h.Location = 'eastoutside';
    h.FontSize = 12;
    ylabel(h, 'V','Rotation',0,'FontSize',16)
    h.Label.Interpreter = 'latex';
    h.TickLabelInterpreter = 'latex';
    caption = ["t/$\frac{L}{V_{min}}$ = "+num2str((t-1)/Lx)];
    title(caption,'interpreter','latex','fontsize',18)
    exportgraphics(gcf,'testmap.gif','Append',true);
    close;
end
