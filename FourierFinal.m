M1 = readtable("1.csv");
M2 = readtable("2.csv");
M3 = readtable("3.csv");
M4 = readtable("4.csv");
M5 = readtable("5.csv");
M6 = readtable("6.csv");
M7 = readtable("7.csv");
M8 = readtable("8.csv");
M9 = readtable("9.csv");
M10 = readtable("10.csv");
format long g
M1 = table(M1{:,"CH1Current"}, M1{:, "CH2Voltage"});
M2 = table(M2{:,"CH1Current"}, M2{:, "CH2Voltage"});
M3 = table(M3{:,"CH1Current"}, M3{:, "CH2Voltage"});
M4 = table(M4{:,"CH1Current"}, M4{:, "CH2Voltage"});
M5 = table(M5{:,"CH1Current"}, M5{:, "CH2Voltage"});
M6 = table(M6{:,"CH1Current"}, M6{:, "CH2Voltage"});
M7 = table(M7{:,"CH1Current"}, M7{:, "CH2Voltage"});
M8 = table(M8{:,"CH1Current"}, M8{:, "CH2Voltage"});
M9 = table(M9{:,"CH1Current"}, M9{:, "CH2Voltage"});
M10 = table(M10{:,"CH1Current"}, M10{:, "CH2Voltage"});
% take the average (it's linear?)
M1 = M1{:,:};
M2 = M2{:,:};
M3 = M3{:,:};
M4 = M4{:,:};
M5 = M5{:,:};
M6 = M6{:,:};
M7 = M7{:,:};
M8 = M8{:,:};
M9 = M9{:,:};
M10 = M10{:,:};
% avg store in M1
M1 = (M1+M2+M3+M4+M5+M6+M7+M8+M9+M10)/10;
% isolate
% goal is to get the minima, so it doesn't matter the current scale since
% that is irrelevant anyway. i.e. current doesn't tell us energy
% Thus, raise to 10^10 so that x,y on same order of mag., remove outliers
% by replacing any data pts with mag > e+10 with 0
M1_1= M1(:, 1)*10^10;
M1_1(M1_1 > 10^10) = 0;
M1_1(M1_1 < -10^10) = 0;
% Prune spikes (did not use)
% anoms = zeros(1001, 1);
% prevpt = zeros(1001,1);
% for i = 3:1001
%     if (abs(M1_1(i) - M1_1(i-1)) / abs(M1_1(i-1) - M1_1(i-2))) >= 100
%         anoms(i) = 1;
%     end
% end
% M1_1(anoms==1) = prevpt(anoms==1);

M1_2= M1(:,2);


% Observe that M1_2 is just 1001 data points spaced by 0.042


% define domain
L = 21;
N = 1001;
dx = 0.042;
x = 0:dx:42;
% define function = M1_1
plot(x, M1_1, '.'), hold on
title('Measured Current Vs. Acceleration Voltage');
xlabel('Voltage (V)');
ylabel('Current (e-10 A)');
% errorbar(x, M1_1, delta_y*ones(size(residuals)), '|black');
% errorbar(x, M1_1, 0.021*ones(size(residuals)), 'horizontal', '|');
% IMPORTANT: SAY ERROR BARS HAVE BEEN OMITTED HERE OTHERWISE ITS UNREADABLE

delta_y = (max(M1_1(1:47)) - min(M1_1(1:47)))/2; % note *10^-10

% compute series
CC = jet(20);
a0 = sum((M1_1.').*ones(size(x)))*dx/L;
fFS = a0/2;
for k = 1:25
    A(k) = sum((M1_1.').*cos(pi*k*x/L))*dx/L;
    B(k) = sum((M1_1.').*sin(pi*k*x/L))*dx/L;
    fFS = fFS + A(k)*cos(k*pi*x/L) + B(k)*sin(k*pi*x/L);
    dA(k) = sqrt(sum((dx/L*cos(k*pi*x/L)*delta_y).^2));
    dB(k) = sqrt(sum((dx/L*sin(k*pi*x/L)*delta_y).^2));
    % plot(x, fFS, '-', 'Color', CC(k,:));
    % pause(.1)
end

% UNCERTAINTIES FOR FITTING PARAM: stored in dA, dB
% ALL OF THE Propagation follows the formulae
% Sqrt( (x*da)^2+(a*dx)^2 + ...)
% da = 0
% simplifies to sqrt( (a*dx)^2 +...) i.e. sqrt( sum( (cos pi*k*x/L
% *delta_y)^2))

% function equivalent
syms theta
f = a0/2;
for k = 1:25
    f = f + A(k)*cos(k*pi*theta/L) + B(k)*sin(k*pi*theta/L);
end


plot(x, fFS, 'LineWidth', 3); % the function
% hold on
% figure;
% fplot(f, [0 42]);
% 
fprime = diff(f);
% fplot(fprime, [0 42]); % compare two


%FIND MINIMA
% Zeros: between:
% 12.7-13.5
% 17.7-18.4
% 22.8-23.7
% 28.2-28.8
% 33.5-33.9
% 38.4-38.8
% 7.6-8.4

minima = zeros(1,7);
ranges = [7.6 8.4; 12.7 13.5; 17.7 18.4; 22.8 23.7; 28.2 28.8; 33.5 33.9; 38.4 38.8];
for i = 1:7
    
    minima(i) = vpasolve(fprime, theta, ranges(i,:));
   
end
plot(minima, subs(f, minima), '.', 'MarkerSize', 16, 'Color', 'g');
legend({'Data','Fourier Fit','Minima'},'Location','northwest')


% Residuals
% Get the "experimental error, set thresh, find best k"
% goal: NO OVERFITTING

% TAKE DATA FROM 0-2V, first 47 data points. Before 2V, there is no
% significant troph or peak and the data is not correlated. We want to
% isolate a data sample small enough such that it does not represent the
% experiment's desired behavior and only showcases the experimental flux.

% Uncertainties of Voltage will be 0.5* measurement gap = 0.021V.

% Current Uncertainty will be range of first 47 data points/2
delta_y = (max(M1_1(1:47)) - min(M1_1(1:47)))/2; % note *10^-10

% 1. This will be used for finding troph locations (uncertainty of x axis will
% be when y axis meets this threshold). 
% 1.5 Or just take minima using dy/dx = 0 and add reading error. Both would
% be insane. Perhaps approach 1. is overkill because the model will alr be
% smaller than uncertainty. No need to double check its accuracy.
% 2. Determining How good fourier series fit is... experiment with term
% values, check if residuals are under uncertainty.

% Notes
% 1. Uncertainty of residuals will just be delta_y
% 2. Analyze residuals using chi square + even spread indicators
% 3. WE INTENTIOANLLY made the model fit smaller than uncertainty, so
% acknowledge that because your chi square ain't allat naturally. But this
% does mean your fit will objectively be good because you made it so

% Residuals = data-fit = M1_1 - fFS
figure;
residuals = M1_1.' - fFS;
plot(x, residuals, '.')
hold on
errorbar(x, residuals, delta_y*ones(size(residuals)), '|black');
errorbar(x, residuals, 0.021*ones(size(residuals)), 'horizontal', '|');
title('Residuals of Current Vs. Voltage of 25-Term Fourier Series Fit');
xlabel('Voltage (V)');
ylabel('Residual Current (e-10 A)');
% its gonna look ugly
% yline(delta_y);
% yline(-delta_y);
% Ratio of how many within uncertainty (maxed this for 25, but no need to
% yap ab why you chose 25 fit)
ratio = sum(residuals < delta_y & residuals > -delta_y)/length(residuals)

% Chi square

chisquare = sum(residuals.^2)/(delta_y^2)/(1001-51)
% chi square of 4.44, while most of the resids fall within the uncertainty,
% the start and the end the fit is not very good. This is not due to our
% data but it is because our fit deviates at the start which is difficult
% to be modelled by fourier, and near the end of the time period, as 25
% terms is insufficient to be accurate but we want to avoid overfitting.

% Discussion: while chi square indicates underfiting, it is difficult to
% fit the data even more without significantly overfitting some parts due
% to the sinusoids.

% Linear plot (voltage vs troph #)
% figure;
% indices = [1 2 3 4 5 6 7];
% plot(indices, minima, '.', 'MarkerSize', 10)
% title('Local Minima Voltage Vs. Troph Number')
% xlabel('Minima Voltage (V)')
% ylabel('Troph Number')
% hold on
% errorbar(indices, minima, 0.021*ones(size(indices)), '|black');
% % very hard to see, note they are only vertical
% [coefficients, S] = polyfit([1 2 3 4 5 6 7], minima, 1)
% plot(indices, polyval(coefficients, indices));
% legend({'Minima Voltages','5.11'})

% NVM i did it on excel