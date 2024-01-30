function video_maker(obj,filename,res,barebone)
if numel(res)>1
    figure('pos',[50 50 res(1) res(2)],'units','pixels','Visible','on');
else
    figure('pos',[10 10 res res],'Visible','on');
end

i=1;
obj.PLOT(i,barebone)

gif(filename,'DelayTime',0.1,'frame',gca,'LoopCount',1)
%gif(filename,'DelayTime',0.1,'frame',gca,'LoopCount',1)

for i=1:1:obj.N/obj.delta+1
obj.PLOT(i,barebone)
gif
end

end