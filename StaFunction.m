%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sys,x0,str,ts]=StaFunction(t,x,u,flag)
global Xstate;
switch flag
    case 0  
        [sys,x0,str,ts]=mdlInitializeSizes;
    case 2  
        sys=mdlUpdate(t,x,u);
    case 3  
        sys=mdlOutputs(t,x,u);
    case {1,4}
        sys=[];
    case 9   
        save('Xstate','Xstate');
    otherwise  
        error(['Unhandled flag = ',num2str(flag)]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;  
sizes.NumDiscStates  = 3; 
sizes.NumOutputs     = 3; 
sizes.NumInputs      = 6;   
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;  
sys = simsizes(sizes);
x0  = [1,0.01,0.01]';          
str = [];             
ts  = [-1 0];  
global Xstate;
Xstate=[];
Xstate=[Xstate,x0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sys=mdlUpdate(t,x,u)
Re = u(1);
Ce = u(2);
Rd = u(3);
Cd = u(4);
Q = u(5);

A = zeros(3,3);
A(1,1) = 1;
A(2,2) = exp(-0.5/(Re*Ce)); % ! be careful of ()
A(3,3) = exp(-0.5/(Rd*Cd));

Xnew = fffun(x,u);
sys = Xnew;
global Xstate;
Xstate = [Xstate, Xnew];

function sys=mdlOutputs(t,x,u)
sys = x;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
