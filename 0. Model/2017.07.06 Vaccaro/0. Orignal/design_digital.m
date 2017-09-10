load project_data
T=0.01;
C = [1 0 0 0 0 0;0 0 0 0 1 0];
D = zeros(2,2);
[phi,gamma]=c2d(A,B,T);
phia=eye(2);
gammaa=eye(2);
phid=[phi zeros(6,2);gammaa*C phia];
gammad=[gamma;zeros(2,2)];
Q=diag([0 0 0 0 0 0 2 1])*1e1;
Q(1,1)=5;
Q=Q+eye(8);
R=eye(2);
Kd=dlqr(phid,gammad,Q,R);
K1=Kd(:,1:6);
K2=Kd(:,7:8);
[delta1_LQR,delta2_LQR]=rb_regsf(phid,gammad,Kd,T)
K2\(K1*[0;0;0;0;pi/4;0]);


