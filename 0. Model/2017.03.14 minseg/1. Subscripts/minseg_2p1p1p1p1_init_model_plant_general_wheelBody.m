%% [Init   ]: Plant: Wheel   (single)                                      

% mass measurement precision: 0.01 lb
% note: this could be improved with a better scale.

plant.axle.m         = 0.000;     %                           [kg]       [note low precision.]

plant.wheel.r        = 0.021;     %  radius                   [m]        [source: howard]
plant.wheel.m        = 0.036 / 2; % (includes axle)           [kg]       [source: howard]
plant.wheel.J        = 7.460e-6;  %  moment of inertia        [kg / m^2] [source: howard]
                                  %  measured from center of mass of wheel

%% [Init   ]: Plant: Body: Masses                                          
% note: body does not include wheels.

% mass measurement precision: 0.01 lb
% note: this could be improved with a better scale.

% plant.board.     m   = 1.000 * k.lb2kg; %                   [kg]
% plant.motorCable.m   = 0.010 * k.lb2kg; % (quantity: 1)     [kg] [note low precision.]
% plant.motor.     m   = 0.220 * k.lb2kg; % (quantity: 1)     [kg] 
% plant.battery.   m   = 1.000 * k.lb2kg; % (quantity: 1)     [kg]

% plant.bluetooth. m   = 0.000 * k.lb2kg; % bluetooth module  [kg] [note low precision.]
% plant.usbCable.  m   = 0.040 * k.lb2kg; % (not included)    [kg]

% plant.body.m         =  plant.board.m                                      ...
%                      +  plant.motor.m      * 2                             ...
%                      +  plant.motorCable.m * 2                             ...
%                      +  plant.battery.m    * plant.n.battery               ...
%                      +  plant.bluetooth.m  * plant.x.bluetoothModule; 
%                               %  mass   [kg]

plant.body.m         =  1.030 * k.lb2kg; %                    [kg]
                                         % net measurement taken to reduce rounding errors.
                                         % [taken with 6 batteries].

%% [Init   ]: Plant: Body                                                  
% note: does not include wheels.

plant.body.l.h       =  8.00 * k.in2m; %  height [m]
plant.body.l.w       =  3.25 * k.in2m; %  width  [m]
plant.body.l.d       =  2.50 * k.in2m; %  depth  [m]

plant.body.l.h       =  0.2032;        %  height [m]
plant.body.l.w       =  0.0634500;     %  width  [m]
plant.body.l.d       =  0.0525825;     %  depth  [m]
plant.body.l.d       =  0.0400000;     %  depth  [m]

switch plant.pSupply.battery.n
case 6; plant.body.T.natural = 0.7349935;
end

plant.body.f.natural =       1 / plant.body.T.natural; %  natural linear  frequency [  1/s] 
plant.body.w.natural =  2 * pi * plant.body.f.natural; %  natural angular frequency [rad/s] 

plant.body.l.c       =  3 * (a.gravity - plant.body.w.natural^2 * plant.wheel.r) ...
                     / (4 *              plant.body.w.natural^2                ); 
                          %  wheel axle to center of mass of robot [m]

%plant.body.l.c       =  0.011;

plant.body.J.x       =  plant.body.m *  plant.body.l.c^2                   ...
                     /  3; 
                          %  moment of inertia (pitch) [kg / m^2]
                          % (measured from center of mass of robot)

plant.body.J.y       =  plant.body.m                                       ...
                     * (plant.body.l.w^2 + plant.body.l.d^2)               ...
                     /  12; 
                          %  moment of inertia (yaw)   [kg / m^2]
                          % (measured from center of mass of robot)

%% [Init   ]: Plant: Net (body + 2 * wheel)                                
plant.net.m          =  plant.body.m + 2 * plant.wheel.m; % [kg]

%% End










