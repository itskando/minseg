%% [Process]: Build (Normal mode or External mode)                         
  switch mdl.mode
  
  case 0 % Normal mode
  disp('Performing build:')
  mdl.T.build   = tic;
  set_param(mdl.label, 'SimulationMode',    'normal'  ) % put model into normal   mode
  rtwbuild (mdl.label                                 ) % build model into hardware
  disp('Build completed.')
  disp(' ')
  
  case 1 % External mode
  set_param(mdl.label, 'SimulationMode',    'external') % put model into external mode
  set_param(mdl.label, 'SimulationCommand', 'connect' ) % connect to the executable
  set_param(mdl.label, 'SimulationCommand', 'start'   ) % start      the executable
% set_param(mdl.label, 'SimulationCommand', 'stop'    ) % stop       the executable

  end

%% End










