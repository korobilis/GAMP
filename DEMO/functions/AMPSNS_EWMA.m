function [beta_means,beta_vars,sigma2,lambdas] = AMPSNS_EWMA(X,y,maxiter,delta)

upalpha = 0;
uplambda = 0;

% Define prior variance alpha
alpha = 100;

% Prior probability for spike and slab prior
lambda = 0.1;
 
% Define prior moments of sigma2 ~ iGamma(a0,b0)
a0 = 0.1;
b0 = 0.1;

% Initialization
[n,p]        =  size(X);
Thresholding =  1.0e-5;
time         =  0;
mu_hat       =  zeros(1,p);       % Initialize vector of parameter estimates at prior mean
tau_hat      =  (1./alpha)*ones(1,p);  % Initialize vector of variances at prior variance
mu_prior     =  ones(1,p);
s            =  zeros(n,1);
pip          =  rand(1,p);
sigma2       =  zeros(n,1);
fprintf('Now you are running AMPSNS_EWMA')
fprintf('\n')
fprintf('Iteration 0000')
% ====================| ESTIMATION |=================
while time < maxiter && norm(mu_hat-mu_prior) > Thresholding
%     clc
    time   =  time + 1;
    if mod(time,500) == 0
        fprintf('%c%c%c%c%c%c%c%c%c%c%c%c%c%c%s%4d',8,8,8,8,8,8,8,8,8,8,8,8,8,8,'Iteration ',time)
    end  
    mu_prior = mu_hat;
    for jj = 1:2
        % Step 1
        z       = X*mu_hat';
        tau_p   = (X.^2)*tau_hat';
        p_hat   = z - tau_p.*s;
    
        % Set sigma.sq equal to rough estimate of posterior mode
        sigma0  = 10*(2*b0 + (y-z)'*(y-z))/(2*a0 + n);
        sigma2(1,:) = delta*sigma0 + (1-delta)*((y(1)-z(1))^2);
        for it = 2:n
            sigma2(it,:) = delta*sigma2(it-1,:) + (1-delta)*((y(it)-z(it))^2);
        end
        
        % Step 2
        tau_z   = (tau_p.*sigma2)./(tau_p + sigma2);     % Var(z(i) | y,p_hat(k,i),tau_p(k,i))
        z_hat   =  tau_z.*(y./sigma2 + p_hat./tau_p);    % E(z(i) | y,p_hat(k,i),tau_p(k,i))

        s       = (z_hat-p_hat)./tau_p;		
        tau_s   = (1 - tau_z./tau_p) ./ tau_p;
            
        % Step 3
        tau_l   = tau_s'*(X.^2);
        tau_r   = 1./(tau_l + 1e-50);
        r_hat   = mu_hat + tau_r.*(s'*X);

        % Step 4
        pip     = 1./( 1 + (1-lambda).*(normpdf(zeros(1,p), r_hat, sqrt(tau_r)) + 1e-50)./((lambda.*normpdf(zeros(1,p), zeros(1,p)-r_hat, sqrt(alpha + tau_l))) + 1e-50) );
        nu      = 1./(alpha + tau_l);
        gam     = (r_hat./(tau_r + 1e-50)).*nu;
        
        if sum(isnan(pip))>0; pip(find(isnan(pip))) = 0.5; end
        
        mu_hat  = pip.*gam;                               % E(mu(i) | y,r_hat(k,i),tau_r(k,i))
        tau_hat = pip.*(gam.^2 - pip.*gam.^2 + nu);       % Var(mu(i) | y,r_hat(k,i),tau_r(k,i))
    end
    
    if uplambda == 1   
        lambda = mean(pip);
    end
    if upalpha == 1
        psi    = (1./lambda)*mean( pip.*(gam.^2) + nu);
        alpha  = 1./(psi + 1e-50);
        alpha(alpha>1e10) = 1e10;
        alpha(alpha<10) = 10;
    end
end
fprintf('%c%c%c%c%c%c%c%c%c%c%c%c%c%c',8,8,8,8,8,8,8,8,8,8,8,8,8,8)

beta_means   = mu_hat';
beta_vars    = tau_hat';
lambdas      = pip';
