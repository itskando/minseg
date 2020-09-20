function [xref,yref,theta,phi,time] = figureeight(theta_init,phi_init)

samplerate = 0.01;
startdelay = 0;

% xbound = 50;
% ybound = 100;
% yfreq = 1/10;
xbound = 35; %use in controls lab
ybound = 70;
yfreq = 1/5;
% xbound = 20; % use at Mackal
% ybound = 40;
% yfreq = 1/1.5;
xfreq = 2*yfreq;
onecycle = 1/yfreq*2*pi;
profilerepeat = 1;

timearray = 0:samplerate:onecycle*profilerepeat;
time=timearray;

dxprofile = xbound*xfreq/100*cos(timearray*xfreq);
dyprofile = ybound*yfreq/100*cos(timearray*yfreq);
xref=samplerate*cumsum(dxprofile);
yref=samplerate*cumsum(dyprofile);

phi = atan2(dyprofile,dxprofile);
%unwrap phi
for n = 1:length(phi)-1
  while((phi(n+1)-phi(n))>= pi/2)
    phi(n+1) = phi(n+1) - pi;
  end
  while((phi(n+1)-phi(n))<= -pi/2)
    phi(n+1) = phi(n+1) + pi;
  end
end 

theta_dot = sqrt(dxprofile.^2+dyprofile.^2)/0.04;
theta = theta_init;

for n = 1:length(theta_dot)-1
    theta(n+1) = theta(n)+theta_dot(n)*samplerate;
end

start_phi = ones(round(startdelay/samplerate),1)*phi(1);
start_theta = ones(round(startdelay/samplerate),1)*theta_init;

endphi = phi(1,length(phi))*ones(1000,1);
endtheta = theta(1,length(theta))*ones(1000,1);

% phi = [start_phi; phi';endphi];
% theta = [start_theta; theta';endtheta];

