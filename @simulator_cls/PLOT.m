function PLOT(obj,n,barebone)
cla
hold on

if obj.plot_single==1
    %cmap=gray(obj.Np);
    cmap=cmocean('solar',obj.Np);
    %cmap=parula(obj.Np);
    x=obj.x(1:obj.Np,n)*1e6;
    y=obj.y(1:obj.Np,n)*1e6;
    %plot(obj.x(j,1:n)*1e6,obj.y(j,1:n)*1e6,'k')
    aa=scatter(x,y,2,cmap,'filled');
    %aa=scatter(x,y,2,'k','filled');
    %aa.MarkerEdgeColor='w';
    %aa=scatter(x,y,2,'k','filled');
    %aa.MarkerFaceAlpha=0.9;
    aa.MarkerFaceAlpha=0.2;

else
    cmap=repmat(parula(obj.Np),n,1);
    x=reshape(obj.x(1:obj.Np,1:n),1,obj.Np*n)*1e6;
    y=reshape(obj.y(1:obj.Np,1:n),1,obj.Np*n)*1e6;
    %plot(obj.x(j,1:n)*1e6,obj.y(j,1:n)*1e6,'k')
    aa=scatter(x,y,20,cmap,'filled');
    aa.MarkerFaceAlpha=1;
end

if barebone==0
    if ~isempty(obj.integrator.response_DR) || ~isempty(obj.integrator.response_v) || ~isempty(obj.integrator.response_W)
        endd=obj.Np;
        if ~isempty(obj.integrator.response_DR)
            gap=obj.integrator.response_DR.landscape.L;
        elseif ~isempty(obj.integrator.response_v)
            gap=obj.integrator.response_v.landscape.L;
        elseif ~isempty(obj.integrator.response_W)
            gap=obj.integrator.response_W.landscape.L;
        end
        xmin=min(reshape(obj.x(1:endd,1:n),1,n*endd).*1e6);
        xmax=max(reshape(obj.x(1:endd,1:n),1,n*endd).*1e6);
        ymin=min(reshape(obj.y(1:endd,1:n),1,n*endd).*1e6);
        ymax=max(reshape(obj.y(1:endd,1:n),1,n*endd).*1e6);
        maxXY=max([abs(xmin) abs(xmax) abs(ymax) abs(ymin)]);
        multiplier=(round(maxXY/gap/1e6));
        obj.checkerboard_3(gap*1e6,-gap*multiplier*1e6,gap*multiplier*1e6);
    end
end

hold off
% axis equal square

if barebone~=1
    if obj.W>0
        title(['v_0 = ' num2str(obj.v0*1e6) ' \mum/s, ', ...
            '\omega_0 = ' num2str(round(obj.W,1)) ' rad/s, ', ...
            'time = ', num2str(obj.dt*(n-1)*obj.delta) ' s'],'color','w')
    else
%         title(['v_0 = ' num2str(obj.v0*1e6) ' \mum/s, ', ...
%             'time = ', num2str(obj.dt*(n-1)*obj.delta) ' s'],'color','w')
    end
    xlabel('x [\mum]','color','w')
    ylabel('y [\mum]','color','w')
    ax = gca;
    ax.XColor='w';
    ax.YColor='w';
    box on
else
    axis off
end

%daspect([1 1 1])
% pbaspect([1 1 1])
set(gcf,'color','k');
set(gca,'color','k')

axis equal
drawnow();
end