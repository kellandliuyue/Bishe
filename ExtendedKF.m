%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sys,x0,str,ts]=ExtendedKF(t,x,u,flag)
global Zsoc;
global Xekf; 
Q=diag([0.01,0.01,0.04]); 
R=1;
switch flag
    case 0 
        [sys,x0,str,ts]=mdlInitializeSizes;
    case 2
        sys=mdlUpdate(t,x,u,Q,R);
    case 3
        sys=mdlOutputs(t,x,u);
    case {1,4}
        sys=[];
    case 9  
        save('Xekf','Xekf');
        save('Zsoc','Zsoc');
    otherwise  
        error(['Unhandled flag = ',num2str(flag)]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sys,x0,str,ts]=mdlInitializeSizes(N)
sizes = simsizes;
sizes.NumContStates  = 0;  
sizes.NumDiscStates  = 3;  
sizes.NumOutputs     = 3;   
sizes.NumInputs      = 10;  
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;  
sys = simsizes(sizes);
% x0 and P init
x0  = [0.01,0.01,0.01]';           
str = [];              
ts  = [-1 0];
global Zsoc; 
Zsoc=[];
global Xekf; 
Xekf=  [x0];
global P;
P=zeros(3,3); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sys=mdlUpdate(t,x,u, Q, R)
global Zsoc; 
global Xekf;
global P;
Zsoc=[Zsoc,u]; 

%求A和C
Re = u(1);
Ce = u(2);
Rd = u(3);
Cd = u(4);
R0 = u(8);
I = u(9);
v = u(10);

A = zeros(3,3);
A(1,1)=1;
A(2,2)=exp(-0.5/(Re*Ce));
A(3,3)=exp(-0.5/(Rd*Cd));

C = zeros(1,3);
C(1,1) = 33.04 * 6 * x(1)^5 - 105.5 * 5 * x(1)^4 + 126.9 * 4 * x(1)^3 ...
         - 70.3 * 3 * x(1)^2 + 17.57 * 2 * x(1) - 0.9811;
C(1,2) = -1;
C(1,3) = -1;
%状态变量预测估算
Xpre = [u(5),u(6),u(7)]';
%观测预测
Zpre = hhfun(Xpre, u);
%均方误差估算
F = A;
H = C;
Ppre = F*P*F'+ Q;
%卡尔曼滤波增益
K=Ppre*H'*inv(H*Ppre*H'+R);
%状态估算更新
Xnew=Xpre+K*(v-Zpre);
%均方误差更新
P=(eye(3)-K*H)*Ppre;
Xekf=[Xekf,Xnew];
sys=Xnew; 

function sys=mdlOutputs(t,x,u)
sys = x; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
