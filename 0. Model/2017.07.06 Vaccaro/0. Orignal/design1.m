load project_data
C = [1 0 0 0 0 0;0 0 0 0 1 0];
D = zeros(2,2);
Aa=zeros(2,2);
Ba=eye(2);
Ad=[A zeros(6,2);Ba*C Aa];
Bd=[B;zeros(2,2)];
Q=diag([0 0 0 0 0 0 2 1])*1e1;
Q(1,1)=5;
R=eye(2);
Kd=lqr(Ad,Bd,Q,R);
K1=Kd(:,1:6);
K2=Kd(:,7:8);
[delta1_LQR,delta2_LQR]=rb_regsf(Ad,Bd,Kd,0)


