function M=filter_files(path)
%check that files/parameters not duplicated
listing=dir([path '\*.mat']);
M=[];
for i=1:numel(listing)
    
    aux=open(listing(i).name);
    
    M=[M;[aux.S.v0 aux.S.gap aux.S.tau]]; %inserts in row below the saved auxiliary values for v0, gap, and tau
end
