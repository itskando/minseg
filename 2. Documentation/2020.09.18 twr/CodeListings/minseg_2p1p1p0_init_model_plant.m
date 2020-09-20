%% [Init   ]: Initialize user-defined parameters                           
plant.supply.  mode     = ui.plant.supply.  mode;
plant.dynamics.mode     = ui.plant.dynamics.mode;

plant.n.batteries       = ui.plant.n.batteries;
plant.x.bluetoothModule = ui.plant.x.bluetoothModule;

%% [Init   ]: Define general plant parameters                              

switch plant.supply.mode
  case 0; plant.supply.v = 9.00; % [V]
  case 1; plant.supply.v = 4.50; % [V]
end

a.gravity                = 9.81; % acceleration [m / s^2]

load( 'bessel poles.mat' )

%% [Init   ]: Verify legitimate operating modes                            

if plant.supply.mode == 0
assert( plant.n.batteries == 6,                                        ... 
      [                                                                ...
       'Battery power is enabled (plant.supply.mode == 0);\n'          ...
       'however, the number of batteries in use is not equal to\n'     ...
       'the number of batteries needed to operate in '                 ...
       'battery power mode (plant.n.batteries ~= 6)'                   ...
      ]                                                                ...
      );
end

%% [Init   ]: Define parameters based on user-specified plant dynamics     

switch plant.dynamics.mode
  case 0; minseg_2p1p1p1_init_model_plant_hardware
  case 1; minseg_2p1p1p2_init_model_plant_nonlinearDynamics
  case 2; minseg_2p1p1p3_init_model_plant_linearDynamics
end

%% End










