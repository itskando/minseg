%% [Input  ]: User-specified                                               
r.wheel = 0.0210; % [m] 

T.sample = 00.001;
T.data   = 40.000;

p.x.pk = 1;
p.y.pk = 1;

p.x.T  = 15;
p.y.T  = p.x.T * 2;

%% [Process]: t                                                            
t   = (0 : T.sample : T.data)';

%% [Process]: p                                                            
p.x.f  = 1 / p.x.T;
p.y.f  = 1 / p.y.T;

p.x.w  = 2 * pi * p.x.f;
p.y.w  = 2 * pi * p.y.f;

p.x.t  = p.x.pk * sin( p.x.w * t );
p.y.t  = p.y.pk * sin( p.y.w * t );

%% [Process]: p.dot                                                        
p.xd.t = zeros( size(t) );
p.yd.t = zeros( size(t) );

for i0 = 2 : size(t,1)
p.xd.t(i0,01) = p.x.t(i0,01) - p.x.t(i0 - 1, 01);
p.yd.t(i0,01) = p.y.t(i0,01) - p.y.t(i0 - 1, 01);
end

p.xdot.t = p.xd.t / T.sample;
p.ydot.t = p.yd.t / T.sample;

%% [Process]: phi                                                          
% phia.t  = atan ( p.ydot.t ./ p.xdot.t);
  phi. t  = atan2( p.ydot.t,   p.xdot.t);
  phi2.t  = phi.t;

for i0 = 2 : size(t,1)
phi2d.t   (i0,01) = phi. t(i0,01) - phi2.t(i0 - 1, 01);
n.pi.phi2d(i0,01) = round( phi2d.t(i0,01) / pi );
phi2. t   (i0,01) = phi2.t(i0,01) - n.pi.phi2d(i0,01) * pi;
end

x.n.pi.phi2d.odd = mod( n.pi.phi2d, 2 );

%% [Process]: theta                                                        
thetadot.t = r.wheel \ sqrt( p.xdot.t.^2 + p.ydot.t.^2 );
theta.   t = zeros( size(t) );

for i0 = 2 : size(t,1)
theta.t(i0,01) = thetadot.t(i0,01) + theta.t(i0 - 1, 01);
end

theta.t = theta.t  * T.sample;

theta2.t = theta.t .* (-1).^( x.n.pi.phid.odd );

%% [Output ]: plot                                                         
figure(1)
plot(t, theta.t)
hold on
plot(t, theta2.t)
hold off

figure(2)
plot(t, phi.t)
hold on
plot(t, phi2.t)
hold off

legend( {'raw', 'checked'} )

figure(3)
stairs(t, n.pi.phi2d)

%% [End]










