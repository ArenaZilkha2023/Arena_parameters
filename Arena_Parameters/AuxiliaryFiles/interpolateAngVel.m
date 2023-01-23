function A=interpolateAngVel(TimeVec,TrajectoryX,TrajectoryY,isInArena,Params)

Cx=Params.ArenaLength/2;
Cy=Params.ArenaLength/2;
C=[Cx Cy];

t1=[TrajectoryX(1:end-1) TrajectoryY(1:end-1)];
t2=[TrajectoryX(2:end) TrajectoryY(2:end)];
n=size(t1,1);

t1=repmat(C,n,1)-t1;
t1=t1./repmat(sqrt(sum(t1(:,1).^2+t1(:,2).^2,2)),1,2);
t2=repmat(C,n,1)-t2;
t2=t2./repmat(sqrt(sum(t2(:,1).^2+t2(:,2).^2,2)),1,2);

%A=acos(dot((repmat(C,n,1)-t1),(repmat(C,n,1)-t2),2)./norm(t1-repmat(C,n,1))./norm(t2-repmat(C,n,1)));
A=dot(t1,t2,2);
A(A>1)=1;
A=acos(A);
A=A./TimeVec;
A(~isInArena)=0;
end