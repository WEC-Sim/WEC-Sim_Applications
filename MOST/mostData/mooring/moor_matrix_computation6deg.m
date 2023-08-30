function moor_matrix = moor_matrix_computation6deg(X,Y,Z,RX,RY,RZ,moorlineName,AN_X,AN_Z,FL_X,FL_Z,number_lines,beta)

load(moorlineName);
beta=deg2rad(beta);
AnchorBase = [-AN_X;0;-AN_Z];
FairleadRBase = [-FL_X;0;FL_Z];
V=zeros(number_lines,1);
Hx=zeros(number_lines,1);
Hy=zeros(number_lines,1);
FX=zeros(length(X),length(Y),length(Z),length(RX),length(RY),length(RZ));
FY=zeros(length(X),length(Y),length(Z),length(RX),length(RY),length(RZ));
FZ=zeros(length(X),length(Y),length(Z),length(RX),length(RY),length(RZ));
MX=zeros(length(X),length(Y),length(Z),length(RX),length(RY),length(RZ));
MY=zeros(length(X),length(Y),length(Z),length(RX),length(RY),length(RZ));
MZ=zeros(length(X),length(Y),length(Z),length(RX),length(RY),length(RZ));

for i=1:length(X)
    for l=1:length(Y)
    for j=1:length(Z)
        for n=1:length(RX)
        for k=1:length(RY)
            for o=1:length(RZ)
            for m=1:number_lines                
                Anchor = [AnchorBase(1)*cos(beta(m));AnchorBase(1)*sin(beta(m));AnchorBase(3)]; 
                FairleadR = [FairleadRBase(1)*cos(beta(m));FairleadRBase(1)*sin(beta(m));FairleadRBase(3)];                
                TransformVector = [X(i),Y(l),Z(j),RX(n),RY(k),RZ(o)];                
                RxC = [1 0 0; 0 cos(TransformVector(4)) -sin(TransformVector(4)); 0 sin(TransformVector(4)) cos(TransformVector(4))];
                RyC = [cos(TransformVector(5)) 0 sin(TransformVector(5)); 0 1 0; -sin(TransformVector(5)) 0 cos(TransformVector(5))];
                RzC = [cos(TransformVector(6)) -sin(TransformVector(6)) 0; sin(TransformVector(6)) cos(TransformVector(6)) 0; 0 0 1];            
                RC = RzC*RyC*RxC;
                FairleadRC = RC*FairleadR+TransformVector(1:3)';            
                LineLength = norm(Anchor-FairleadRC);
                gamma = asin((FairleadRC(3)-Anchor(3))/LineLength);
                h = LineLength*sin(gamma);
                r = LineLength*cos(gamma);
                alpha=(atan2((FairleadRC(2)-Anchor(2)),(FairleadRC(1)-Anchor(1))));
                FairleadNotrasl = RC*FairleadR;                
                H=-interp2(moor_line.z,moor_line.x,moor_line.fx,h,r,"spline");
                V(m)=-interp2(moor_line.z,moor_line.x,moor_line.fz,h,r,"spline"); 
                Hx(m)=H*cos(alpha);
                Hy(m)=H*sin(alpha);
                HVvec = [H*cos(alpha),H*sin(alpha),V(m)]';
                mtotp = cross(FairleadNotrasl,HVvec);
                mx(m) = mtotp(1);
                my(m) = mtotp(2);
                mz(m) = mtotp(3);
            end            
            FX(i,l,j,n,k,o)=sum(Hx);
            FY(i,l,j,n,k,o)=sum(Hy);
            FZ(i,l,j,n,k,o)=sum(V);
            MX(i,l,j,n,k,o)=sum(mx);
            MY(i,l,j,n,k,o)=sum(my);
            MZ(i,l,j,n,k,o)=sum(mz);
            end
        end
        end
    end
    end
end
moor_matrix.X=X;
moor_matrix.Y=Y;
moor_matrix.Z=Z;
moor_matrix.RX=RX;
moor_matrix.RY=RY;
moor_matrix.RZ=RZ;

moor_matrix.FX=FX;
moor_matrix.FY=FY;
moor_matrix.FZ=FZ;
moor_matrix.MX=MX;
moor_matrix.MY=MY;
moor_matrix.MZ=MZ;
% Preload = moor_matrix.FZ(ceil(length(moor_matrix.X)/2),ceil(length(moor_matrix.Y)/2),ceil(length(moor_matrix.Z)/2),...
%     ceil(length(moor_matrix.RX)/2),ceil(length(moor_matrix.RY)/2),ceil(length(moor_matrix.RZ)/2))
end
