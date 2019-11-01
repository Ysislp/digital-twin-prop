clear;
close('all');
clc;

% Datos
load('TestWorkspace.mat');
load('ValWorkspace.mat');

figure(1)
plot(Ti,DSA,'*');

% **** 1 ****

% Curve fit (solo Ti)
% y = a*x^3 + b*x^2 + c*x + d

a = -3.143e-7;
b = 0.0005606;
c = -0.01602;
d = 75.46;

md1 = a*(Ti).^3 + b*(Ti).^2 + c*(Ti) + d;
% -3.143e-7*(Ti)^3 + 0.0005606*(Ti).^2 - 0.01602*(Ti) + 75.46

RMSE1 = sqrt(mean((DSA - md1).^2));
Rsq1 = fR2(DSA,md1);

figure (2)
plot(md1)
hold on;
plot(DSA)

md1_val = a*(T_val).^3 + b*(T_val).^2 + c*(T_val) + d;
RMSE1_val = sqrt(mean((DSA_val - md1_val).^2));

figure (9)
plot(md1_val, 'r')
hold on;
plot(DSA_val)

% **** 2 ****

% Curve fit 3D
% Linear model Poly23:
%      f(x,y) = p00 + p10*x + p01*y + p20*x^2 + p11*x*y + p02*y^2 + p21*x^2*y +
%                      p12*x*y^2 + p03*y^3
% Coefficients (with 95% confidence bounds):
%        p00 =       76.44  (67.35, 85.54)
%        p10 =    -0.08533  (-0.5777, 0.4071)
%        p01 =   -0.003054  (-0.05978, 0.05368)
%        p20 =    0.004229  (-0.003103, 0.01156)
%        p11 =   -0.002185  (-0.004973, 0.0006022)
%        p02 =   0.0002724  (-2.441e-05, 0.0005692)
%        p21 =  -3.174e-06  (-1.024e-05, 3.893e-06)
%        p12 =   1.423e-06  (-8.626e-07, 3.708e-06)
%        p03 =  -1.513e-07  (-3.473e-07, 4.464e-08)
% 
% Goodness of fit:
%   SSE: 703.1
%   R-square: 0.9849
%   Adjusted R-square: 0.9782
%   RMSE: 6.25

md2 = 76.44 - 0.08533.*Ti - 0.003054.*Ci + 0.004229.*(Ti).^2 -  ...
      0.002185.*Ti.*Ci + 0.0002715.*(Ci).^2 - 3.174e-06.*(Ti).^2.*Ci ...
      + 1.423e-06.*Ti.*(Ci).^2 - 1.513e-07.*(Ci).^3;

RMSE2 = sqrt(mean((DSA - md2).^2));
Rsq2 = fR2(DSA,md2);

figure (3)
plot(md2, 'c')
hold on;
plot(DSA)

md2_val = 76.44 - 0.08533.*T_val - 0.003054.*C_val + 0.004229.*(T_val).^2 -  ...
      0.002185.*T_val.*C_val + 0.0002715.*(C_val).^2 - 3.174e-06.*(T_val).^2.*C_val ...
      + 1.423e-06.*T_val.*(C_val).^2 - 1.513e-07.*(C_val).^3;
RMSE2_val = sqrt(mean((DSA_val - md2_val).^2));

figure (10)
plot(md2_val, 'r')
hold on;
plot(DSA_val)

% **** 3 ****

% Regress
X = [ones(length(DSA),1), Ti, Phi, Ci];
[B,BINT,R,RINT,STATS] = regress(DSA, X);
md3 = 396.7713 + 0.0421.*Ti - 45.3508.*Phi + 0.0150.*Ci; %B
% md3 = 396.7713 + 0.0421.*Ti - 45.3508.*Phi + 0.0150.*Ci;
% X = |1|Ti|Phi|Ci|
% dsa = b0 + b1*Ti + b2*Phi + b3*Ci
% dsa = 396.7713 + 0.0321*Ti - 41.3508*Phi + 0,0160*Ci

RMSE3 = sqrt(mean((DSA - md3).^2));
Rsq3 = fR2(DSA,md3);

figure (4)
plot(md3, 'k')
hold on;
plot(DSA)

md3_val = 396.7713 + 0.0421.*T_val - 45.3508.*Ph_val + 0.0150.*C_val;
RMSE3_val = sqrt(mean((DSA_val - md3_val).^2));

corr = corrcoef([DSA Ti Ci Phi Ai]) %Ph correlación baja

% **** 4 ****

% Fitlm T, C

Xaux = [Ti, Ci];
mdl = fitlm(Xaux, DSA);
md4 = 75 + 0.02937.*Ti + 0.017344.*Ci;

RMSE4 = sqrt(mean((DSA - md4).^2));
Rsq4 = fR2(DSA,md4);

figure (5)
plot(md4, 'r')
hold on;
plot(DSA)

md4_val = 75 + 0.02937.*T_val + 0.017344.*C_val;
RMSE4_val = sqrt(mean((DSA_val - md4_val).^2));

% **** 5 ****

% Fitlm T, C, Ph, Ai

Xaux = [Ti, Ci, Phi, Ai];
mdl2 = fitlm(Xaux, DSA);
md5 = 425.0 + 0.045635.*Ti + 0.01423.*Ci - 56.60.*Phi + 2.12700.*Ai;
% 426.44 + 0.0035805.*Ti + 0.020846.*Ci - 56.528.*Phi + 2.1107.*Ai
% 12,3296  .56.525*ph
RMSE5 = sqrt(mean((DSA - md5).^2));
Rsq5 = fR2(DSA,md5);

figure (6)
plot(md5, 'r')
hold on;
plot(DSA)

md5_val = 425.0 + 0.045635.*T_val + 0.01423.*C_val - 56.60.*Ph_val + 2.12700.*A_val;
RMSE5_val = sqrt(mean((DSA_val - md5_val).^2));
% 11,5470
% 425.0 + 0.045635.*T_val + 0.01423.*C_val - 56.60.*Ph_val + 2.12700.*A_val;

figure (13)
plot(md5_val, 'r')
hold on;
plot(DSA_val)

% **** 6 ****

% Linear model Poly42:
%      f(x,y) = p00 + p10*x + p01*y + p20*x^2 + p11*x*y + p02*y^2 + p30*x^3 + p21*x^2*y 
%                     + p12*x*y^2 + p40*x^4 + p31*x^3*y + p22*x^2*y^2
% Coefficients (with 95% confidence bounds):
%        p00 =       95.72  (74.59, 116.9)
%        p10 =       -1.33  (-3.125, 0.465)
%        p01 =    -0.07005  (-0.3456, 0.2055)
%        p20 =     0.04464  (0.005466, 0.08381)
%        p11 =    -0.01072  (-0.02209, 0.0006438)
%        p02 =    0.001403  (-0.0005393, 0.003346)
%        p30 =  -0.0004819  (-0.0009181, -4.569e-05)
%        p21 =   0.0002204  (-3.855e-07, 0.0004412)
%        p12 =  -2.532e-05  (-5.374e-05, 3.106e-06)
%        p40 =   9.191e-07  (9.498e-09, 1.829e-06)
%        p31 =  -4.637e-07  (-1.065e-06, 1.378e-07)
%        p22 =   5.269e-08  (-2.561e-08, 1.31e-07)
% 
% Goodness of fit:
%   SSE: 512.3
%   R-square: 0.989
%   Adjusted R-square: 0.9809
%   RMSE: 5.844

x = Ti;
y = Ci;

       p00 =       95.72;
       p10 =       -1.33;
       p01 =    -0.07005;
       p20 =     0.04464;
       p11 =    -0.01072;
       p02 =    0.001403;
       p30 =  -0.0004819;
       p21 =   0.0002204;
       p12 =  -2.532e-05;
       p40 =   9.191e-07;
       p31 =  -4.632642e-07;
       p22 =   5.263e-08;

md6 = p00 + p10.*x + p01.*y + p20.*x.^2 + p11.*x.*y + p02.*y.^2 + p30.*x.^3 ... 
      + p21.*x.^2.*y + p12.*x.*y.^2 + p40.*x.^4 + p31.*x.^3.*y + p22.*x.^2.*y.^2;

RMSE6 = sqrt(mean((DSA - md6).^2));
Rsq6 = fR2(DSA,md6);

figure (7)
plot(md6)
hold on;
plot(DSA)
xlim([0 26])

x = T_val;
y = C_val;
p12 =  -2.532e-05;
p30 =  -0.0004819;
md6_val = p00 + p10.*x + p01.*y + p20.*x.^2 + p11.*x.*y + p02.*y.^2 + p30.*x.^3 ... 
      + p21.*x.^2.*y + p12.*x.*y.^2 + p40.*x.^4 + p31.*x.^3.*y + p22.*x.^2.*y.^2;
RMSE6_val = sqrt(mean((DSA_val - md6_val).^2));

figure (14)
plot(md6_val, 'r')
hold on;
plot(DSA_val)

% **** 7 ****

% Media

md7 = (md2 + md1)./2;
RMSE7 = sqrt(mean((DSA - md7).^2));%8,1013 %7,2029
Rsq7 = fR2(DSA,md7);%0,9620 %0,9699

figure (8)
plot(md7,'r')
hold on;
plot(DSA)
title(['Dosificación de Coagulante']);
xlabel('Muestra');
ylabel(['Sulfato de Aluminio (Kg/h)']);
grid on;
legend('Modelo md7','Dosis medida');

md7_val = (md2_val + md1_val)./2;
RMSE7_val = sqrt(mean((DSA_val - md7_val).^2));%7,9741 %7,6543

figure (15)
plot(md7_val,'r')
hold on;
plot(DSA_val)
title(['Dosificación de Coagulante']);
xlabel('Muestra');
ylabel(['Sulfato de Aluminio (Kg/h)']);
grid on;
legend('Modelo md7','Dosis medida');

% 2 y 1 7,6543

% 2 y 5 8,9138

% Comparación de modelos

figure (8)
plot(md1, 'g')
hold on
plot(md2, 'r')
hold on
plot(md4, 'k')
hold on
plot(md5, 'm')
hold on
plot(DSA, '*')
