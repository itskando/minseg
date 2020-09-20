%% [Init   ]: Define serial transmission parameters                        
io.srl.read.rateTransition.initialCondition = uint8( zeros( srl.read{1,1}.n.Bytes, 1 ) );
io.srl.read.rateTransition.T.sample         = srl.T.sample;

%% [Init   ]: Initialize list of general parameters used within Simulink model

mdl.parameter.label = {};

% Specify parameters which will be used in model:
mdl.parameter.label = [...
mdl.parameter.label
{ 
  'srl.port'
  
  'io.srl.read.rateTransition.initialCondition'
  'io.srl.read.rateTransition.T.sample'
  
%  cannot set certain hardware parameters via variables. [must hard-code.]

% 'srl.address';
% 'srl.f.baud';
}];

%% [Init   ]: Relabel parameters for use within Simulink model             

% Number of parameters specified
mdl.n.parameter        = size( mdl.parameter.label, 1);

% Indices which contain periods:
mdl.parameter.z.period = regexp(mdl.parameter.label, '\.');

% For each parameter:
for i0 = 1 : mdl.n.parameter

% Create a new label in which all periods have been set to underscores:
mdl.parameter.label0 = mdl.parameter.label   {i0,1};
mdl.parameter.label0 ( mdl.parameter.z.period{i0,1} ) = '_';

% Set the data for the new label equal to the data from the old label:
eval([ mdl.parameter.label0 ' = ' mdl.parameter.label{i0,1} ';' ]);
  
end

%% [Init   ]: Update model scan for errors                                 

set_param(mdl.label, 'SimulationCommand', 'update' )

%% End










