%% [Init   ]: Initialize user-defined parameters                           
mdl.label= ui.mdl.label;
mdl.mode = ui.mdl.mode;
mdl.case = ui.mdl.case;

%% [Init   ]: Load model, if not already loaded                            
if ~bdIsLoaded( mdl.label )
load_system(    mdl.label );
end

%% [Init   ]: Define general model parameters                              

mdl.object = get_param(mdl.label, 'Object');

switch mdl.mode
  case 0; mdl.T.sample = 0.005; % 0: normal
  case 1; mdl.T.sample = 0.030; % 1: external
end

%% End










