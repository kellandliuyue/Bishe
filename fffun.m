function Xnew=fffun(x,u)
deltaT = 0.5;
tmp_exp1 = exp(-deltaT / (u(1) * u(2)));
tmp_exp2 = exp(-deltaT / (u(3) * u(4)));
Xnew(1,1) = x(1) - deltaT / u(5) * u(6);
Xnew(2,1) = tmp_exp1 * x(2) + (1 - tmp_exp1) * u(1) * u(6);
Xnew(3,1) = tmp_exp2 * x(3) + (1 - tmp_exp2) * u(3) * u(6);
