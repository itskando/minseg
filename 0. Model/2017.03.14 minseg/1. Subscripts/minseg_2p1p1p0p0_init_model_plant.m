%% [Init   ]: Plant: User-defined                                          
plant.dynamics.mode     = ui.plant.dynamics.mode;

%% [Init   ]: Plant: Variants                                              
plant.hardware.         var = Simulink.Variant( 'plant_dynamics_mode == 0' );
plant.nonlinearDynamics.var = Simulink.Variant( 'plant_dynamics_mode == 1' );
plant.linearDynamics.   var = Simulink.Variant( 'plant_dynamics_mode == 2' );

%% [Init   ]: Plant: Timing                                                

switch ui.plant.dynamics.mode
  case 0;    plant.T.init = 1; % [s] 0: hardware   [allows  for sensor calibration.]
  otherwise; plant.T.init = 0; % [s] 1: simulation [no need for sensor calibration.]
end

%% [Init   ]: Plant: Power supply                                          

plant.pSupply.battery.v.nominal = 1.50; % [V]
plant.pSupply.battery.n         = 6;    % [-] [range: 0 - 6]
plant.pSupply.battery.v.actual  = 7.36; % [V] [check frequently]

plant.pSupply.usb.v.nominal     = 4.50; % [V]
plant.pSupply.usb.v.actual      = plant.pSupply.usb.v.nominal              ...
                                * 0.95; % [V]

plant.pSupply.mode = 0; % [default: 0]
% 0: 9.00 [V] (battery pack)
% 1: 4.50 [V] (usb cable) 

switch plant.pSupply.mode

case 0 % battery power
plant.pSupply.v = plant.pSupply.battery.v.actual % [V]

assert( plant.pSupply.battery.n == 6,                                      ... 
      ['Battery power is enabled (plant.pSupply.mode == 0);\n'             ...
       'however, the number of batteries in use is not equal to\n'         ...
       'the number of batteries needed to operate in '                     ...
       'battery power mode (plant.pSupply.battery.n ~= 6)'                 ...
      ]                                                                    ...
      );

case 1 % usb power
plant.pSupply.v = plant.pSupply.usb.v.actual; % [V]
  
end

%% [Init   ]: Plant: General                                               

minseg_2p1p1p1p1_init_model_plant_general_wheelBody
minseg_2p1p1p1p2_init_model_plant_general_motor
minseg_2p1p1p1p3_init_model_plant_general_motorGearboxEncoder

%% [Init   ]: Plant: Initial Condition                                     

plant.linear.ss.stateIC =                                                  ...
[         ...   x[0]:     | state initial condition:
    +0    ... [ theta     | angular position: wheel           ]
    +0.05 ... [ phi.x     | angular position: body: x (pitch) ]
    +0    ... [ theta.dot | angular velocity: wheel           ]
    +0    ... [ phi.x.dot | angular velocity: body: x (pitch) ]
    +0    ... [ phi.y     | angular position: body: y (yaw)   ]
    +0    ... [ phi.y.dot | angular velocity: body: y (yaw)   ]
]';

switch plant.dynamics.mode
  case 0; plant.linear.ss.stateIC = zeros(6,1);
end

%% [Init   ]: Plant: Mode-specific                                         

minseg_2p1p1p2p0_init_model_plant_hardware
minseg_2p1p1p3p0_init_model_plant_nonlinearDynamics
minseg_2p1p1p4p0_init_model_plant_linearDynamics

%% End










