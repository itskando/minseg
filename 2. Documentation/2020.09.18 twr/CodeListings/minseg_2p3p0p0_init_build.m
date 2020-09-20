%% [Init   ]: Define serial transmission parameters                        
io.srl.read.rateTransition.initialCondition = uint8( zeros( srl.read{1,1}.n.Bytes, 1 ) );
io.srl.read.rateTransition.T.sample         = srl.T.sample;

%% [Init   ]: Initialize list of general parameters used within Simulink model

mdl.parameter.label = {};

% Specify parameters which will be used in model:
mdl.parameter.label = [...
mdl.parameter.label
{ 
  'k.intmax.uint8'

  'mdl.mode'
  'mdl.T.sample'
  
  'ctrl.mode.v.motor.input'
  'ctrl.v_motor_input.directFeedForward.var'
  'ctrl.v_motor_input.pid_angVel_motor.var'
  
  'plant.v.supply'
  
  'io.write.serial.var'
  'io.write.scopes.var'
  'io.write.serial.hardware.var'
  'io.write.serial.nonlinearDynamics.var'
  'io.write.serial.linearDynamics.var'
  
  'io.write.ctrl.v_mtr_input.cmd.tStart'
  'io.write.ctrl.v_mtr_input.cmd.val.x'
  'io.write.ctrl.v_mtr_input.cmd.val_norm.dx.max'
  'io.write.ctrl.v_mtr_input.cmd.val_norm.dx.min'
  
  'io.srl.read.rateTransition.initialCondition'
  'io.srl.read.rateTransition.T.sample'
  
%  cannot set certain hardware parameters via variables. [must hard-code.]

% 'srl.address';
% 'srl.f.baud';
% 'srl.n.transmits';
}];

%% [Init   ]: Append case-dependent parameters: Plant: Dynamics model      

switch plant.mode.dynamics

case 0 % hardware
mdl.parameter.label = [...
mdl.parameter.label
{ 
  'gyro.dlpf.mode'
  'gyro.k_raw2rps'
  
  'gyro.x.bias'
  'gyro.x.reset'
  'gyro.y.bias'
  'gyro.y.reset'
  'gyro.z.bias'
  'gyro.z.reset'
  
  'mtr.driver.left.pin.pos'
  'mtr.driver.left.pin.neg'
  'mtr.driver.middle.pin.pos'
  'mtr.driver.middle.pin.neg'

  'mtr.encoder.left.pin.A'
  'mtr.encoder.left.pin.B'
  'mtr.encoder.middle.pin.A'
  'mtr.encoder.middle.pin.B'

  'mtr.encoder.countPerRev'
  'mtr.encoder.radPerRev'
  
  'mtr.encoder.filter.z.ss.A'
  'mtr.encoder.filter.z.ss.B'
  'mtr.encoder.filter.z.ss.C'
  'mtr.encoder.filter.z.ss.D'
  
  'mtr.encoder.filter.z.num'
  'mtr.encoder.filter.z.den'
}];

case 1
mdl.parameter.label = [...
mdl.parameter.label
{ 
}];

case 2
mdl.parameter.label = [...
mdl.parameter.label
{ 
}];

end

%% [Init   ]: Append case-dependent parameters: Controller: v.motor.input

switch ctrl.mode.v.motor.input

case 0 % direct feed-forward: v.motor.input
mdl.parameter.label = [...
mdl.parameter.label
{ 

}];

case 1 % PID: w.motor
mdl.parameter.label = [...
mdl.parameter.label
{ 
  'ctrl.v_motor_input.pid.angVel.k.p'
  'ctrl.v_motor_input.pid.angVel.k.i'
  'ctrl.v_motor_input.pid.angVel.k.d'
  
  'ctrl.v_motor_input.pid.angVel.int.maxVal'
  'ctrl.v_motor_input.pid.angVel.int.minVal'
}];

end

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

%% End










