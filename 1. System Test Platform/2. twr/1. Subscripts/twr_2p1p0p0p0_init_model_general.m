%% [Init   ]: General: User-defined                                        
mdl.mode = ui.mdl.mode;
mdl.case = ui.mdl.case;

%% [Init   ]: General: Variants                                            
mdl.standard.             var = Simulink.Variant( 'mdl_case == 0' );
mdl.motorCharacterization.var = Simulink.Variant( 'mdl_case == 1' );
mdl.sensorCalibration.    var = Simulink.Variant( 'mdl_case == 2' );

%% [Init   ]: General: Load model, if not already loaded                   
mdl.label = 'twr_2020a';

if ~bdIsLoaded( mdl.label )
load_system(    mdl.label );
end

%% [Init   ]: General: Timing                                              

mdl.object = get_param(mdl.label, 'Object');

switch mdl.mode
  case 0; mdl.T.sample = 0.015; % 0: normal
  case 1; mdl.T.sample = 0.030; % 1: external
end

switch ui.plant.dynamics.mode
  case 0;    mdl.T.duration =   inf; % 0: hardware
  otherwise; mdl.T.duration = 002.0; % 1: simulation
end

%% [Init   ]: General: Mode-specific                                       

switch ui.plant.dynamics.mode
case 0     % hardware
  set_param(mdl.label, 'SolverType', 'Fixed-step'             );
  set_param(mdl.label, 'Solver'    , 'FixedStepDiscrete'      );
  set_param(mdl.label, 'StopTime'  , 'inf'                    );

otherwise % simulation
  set_param(mdl.label, 'SolverType', 'Variable-step'          );
  set_param(mdl.label, 'Solver'    , 'ode45'                  );
  set_param(mdl.label, 'StopTime'  ,  num2str(mdl.T.duration) );
end

%% End










