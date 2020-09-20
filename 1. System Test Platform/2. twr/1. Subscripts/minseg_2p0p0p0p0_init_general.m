%% [Init   ]: Conversions                                                  
k.intmax.uint8 = double( intmax('uint8') );
k.intmax.int16 = double( intmax('int16') );

k_deg2rad      = 2*pi / 360;
k_rad2deg      = 1 / k_deg2rad;

k.byte2bit     = 8;
k.bit2byte     = 1 / k.byte2bit;

k.lb2kg        = 0.45359233;
k.kg2lb        = 1 / k.lb2kg;

k.in2m         = 0.0254;
k.m2in         = 1 / k.in2m;

k.Rev2rad      = 2*pi;
k.rad2Rev      = 1 / k.Rev2rad;

%% [Init   ]: Parameters                                                   

a.gravity      = 9.81; % acceleration of gravity [earth] [m / s^2]

load( 'bessel poles.mat' )

%% End










