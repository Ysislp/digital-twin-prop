clear;
close('all');

load('TestWorkspace.mat');
load('ValWorkspace.mat');

T1=[];T2=[];i=1;j=1;k=1;

while i <= length(Ti)
    if (Ti(i) < 97)
        T1(j)=Ti(i);
        C1(j)=Ci(i);
        DSA1(j)=DSA(i);
        j = j+1;
    else
        T2(k)=Ti(i);
        C2(k)=Ci(i);
        DSA2(k)=DSA(i);
        k=k+1;
    end
    i=i+1;
end

% **** 1 ****

% Regress
X = [ones(length(DSA1),1), T1, C1];
[B,BINT,R,RINT,STATS] = regress(DSA1, X);
md11 = 72.3645 - 0.0030.*T1 + 0.0253.*C1; %B

RMSE11 = sqrt(mean((DSA1 - md11).^2));
Rsq11 = fR2(DSA1,md11);

figure (1)
plot(md11, 'k')
hold on;
plot(DSA1)

% md3_val = 396.7713 + 0.0421.*T_val - 45.3508.*Ph_val + 0.0150.*C_val;
% RMSE3_val = sqrt(mean((DSA_val - md3_val).^2));

X = [ones(length(DSA2),1), T2, C2];
[B,BINT,R,RINT,STATS] = regress(DSA2, X);
md12 = 66.1549 + 0.0508.*T2 + 0.0300.*C2; %B
md122 = 93.3434 - 0.0274*T2 + 0.01438*C2;

md12 = (md12+md122)/2;

RMSE12 = sqrt(mean((DSA2 - md12).^2));
Rsq12 = fR2(DSA2,md12);

figure (2)
plot(md12, 'k')
hold on;
plot(DSA2)


% **** 2 ****

% Fitlm T, C

Xaux = [T1, C1];
mdl = fitlm(Xaux, DSA1);
md21 = 72.364 -0.0029748.*T1 + 0.025302.*C1;

RMSE21 = sqrt(mean((DSA1 - md21).^2));
Rsq21 = fR2(DSA1,md21);

figure (3)
plot(md21, 'r')
hold on;
plot(DSA1)

% md4_val = 75 + 0.02937.*T_val + 0.017344.*C_val;
% RMSE4_val = sqrt(mean((DSA_val - md4_val).^2));

Xaux = [T2, C2];
mdl = fitlm(Xaux, DSA2);
md22 = 72.364 -0.0029748.*T2 + 0.025302.*C2;

RMSE22 = sqrt(mean((DSA2 - md22).^2));
Rsq22 = fR2(DSA2,md22);

figure (4)
plot(md22, 'r')
hold on;
plot(DSA2)

% *** 3 ***

% Linear model Poly41:
%      f(x,y) = p00 + p10*x + p01*y + p20*x^2 + p11*x*y + p30*x^3 + p21*x^2*y +
%                      p40*x^4 + p31*x^3*y
% Coefficients (with 95% confidence bounds):
%        p00 =      -136.4  (-448.9, 176.2)
%        p10 =       27.99  (0.6699, 55.31)
%        p01 =       2.909  (-6.098, 11.92)
%        p20 =      -1.319  (-2.827, 0.1901)
%        p11 =     -0.2884  (-1.224, 0.6473)
%        p30 =     0.02669  (-0.02657, 0.07995)
%        p21 =     0.00865  (-0.02172, 0.03902)
%        p40 =  -0.0001926  (-0.0007768, 0.0003917)
%        p31 =  -8.122e-05  (-0.0003867, 0.0002242)
% 
% Goodness of fit:
%   SSE: 297.1
%   R-square: 0.6343
%   Adjusted R-square: 0.3683
%   RMSE: 5.197

p00 =      -136.4 ;
p10 =       27.99 ;
p01 =       2.909;
p20 =      -1.319;
p11 =     -0.2884;
p30 =     0.02669;
p21 =     0.00865;
p40 =  -0.0001926 ;
p31 =  -8.122e-05 ;

 x=T1;y=C1;

md31 = p00 + p10.*x + p01.*y + p20.*x.^2 + p11.*x.*y + p30.*x.^3 + p21.*x.^2.*y + p40.*x.^4 + p31.*x.^3.*y;

       
       
RMSE31 = sqrt(mean((DSA1 - md31).^2));
Rsq31 = fR2(DSA1,md31);

figure (5)
plot(md31, 'r')
hold on;
plot(DSA1)
       
% Media

md = (md11 + md31)./2;
RMSE = sqrt(mean((DSA1 - md).^2));
Rsq = fR2(DSA1,md);

figure (8)
plot(md,'r')
hold on;
plot(DSA1)
title(['Dosificación de Coagulante']);
xlabel('Muestra');
ylabel(['Sulfato de Aluminio (Kg/h)']);
grid on;
legend('Modelo md7','Dosis medida');

% Comparación de modelos

figure (8)
plot(md11, 'g')
hold on
plot(md2, 'r')
hold on
plot(md4, 'k')
hold on
plot(md5, 'm')
hold on
plot(DSA, '*')

x = load('falla');

i = 1; arrayDosis=[];
while i<=length(Ti)
    [dosis, status] = coagulantFunc(Ti(i), Ci(i));
    arrayDosis(i) = dosis;
    i = i+1;
end



RMSE = sqrt(mean((DSA - arrayDosis').^2));
Rsq = fR2(DSA,arrayDosis');

figure (1)
plot(arrayDosis, 'r')
hold on
plot(DSA)
title(['Dosificación de Coagulante']);
xlabel('Muestra');
ylabel(['Sulfato de Aluminio (Kg/h)']);
grid on;
legend('Modelo','Dosis real');
xlim([0 25])
