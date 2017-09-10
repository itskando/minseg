clc
clearvars

mdl.name = 'lab5';

k_deg2rad = 2*pi / 360;
k_rad2deg = 1 / k_deg2rad;

bias      = -260;
k_raw2rps = +250 / 2^15;
reset     =    0;

switch 0
case 0; set_param(mdl.name, 'ExtMode', 'off')
case 1; set_param(mdl.name, 'ExtMode', 'on')
end

set_param(mdl.name, 'SimulationCommand', 'start')