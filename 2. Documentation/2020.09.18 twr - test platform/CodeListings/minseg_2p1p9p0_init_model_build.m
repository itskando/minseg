%% [Init   ]: Initialize list of general parameters used within Simulink model

mdl.parameter.label = {};

% Specify parameters which will be used in model:
mdl.parameter.label = [...
mdl.parameter.label
{ 
  'k.intmax.uint8'

  'mdl.mode'
  'mdl.case'
  'mdl.T.sample'
  
  'plant.dynamics.mode'
  'plant.supply.v'
  
  'ctrl.motor_v.mode'
  'ctrl.motor_v.ff.motor_v.var'
  'ctrl.motor_v.pid.motor_w.var'
  
  'io.write.serial.var'
  'io.write.scopes.var'
  
  'io.write.serial.hardware.var'
  'io.write.serial.hardware.ff.var'
  'io.write.serial.hardware.ff.standard.var'
  'io.write.serial.hardware.ff.motorCharacterization.var'
  'io.write.serial.hardware.pid.var'
  'io.write.serial.hardware.pid.standard.var'
  'io.write.serial.hardware.pid.sensorCalibration.var'
  
  'io.write.serial.nonlinearDynamics.var'
  'io.write.serial.nonlinearDynamics.ff.var'
  'io.write.serial.nonlinearDynamics.ff.standard.var'
  'io.write.serial.nonlinearDynamics.pid.var'
  'io.write.serial.nonlinearDynamics.pid.standard.var'
  
  'io.write.serial.linearDynamics.var'
  'io.write.serial.linearDynamics.ff.var'
  'io.write.serial.linearDynamics.ff.standard.var'
  'io.write.serial.linearDynamics.pid.var'
  'io.write.serial.linearDynamics.pid.standard.var'
  
  'io.write.ctrl.motor_v.cmd.tStart'
  'io.write.ctrl.motor_v.cmd.val.x'
  'io.write.ctrl.motor_v.cmd.val_norm.dx.max'
  'io.write.ctrl.motor_v.cmd.val_norm.dx.min'
  
}];

%% [Init   ]: Append case-dependent parameters: Plant: Dynamics model      

switch plant.dynamics.mode

case 0 % hardware
mdl.parameter.label = [...
mdl.parameter.label
{ 
  'gyro.dlpf.mode'
  'gyro.k_raw2actual'
  
  'gyro.x.bias'
  'gyro.x.reset'
  'gyro.y.bias'
  'gyro.y.reset'
  'gyro.z.bias'
  'gyro.z.reset'
  
  'gyro.filter.z.ss.A'
  'gyro.filter.z.ss.B'
  'gyro.filter.z.ss.C'
  'gyro.filter.z.ss.D'
  
  'gyro.filter.z.num'
  'gyro.filter.z.den'
  
  'accel.k_raw2actual'
  
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

switch ctrl.motor_v.mode

case 0 % feed-forward (input: motor.v)
mdl.parameter.label = [...
mdl.parameter.label
{ 

}];

case 1 % PID          (input: motor.w)
mdl.parameter.label = [...
mdl.parameter.label
{ 
  'ctrl.motor_v.pid.motor_w.k.p'
  'ctrl.motor_v.pid.motor_w.k.i'
  'ctrl.motor_v.pid.motor_w.k.d'
  
  'ctrl.motor_v.pid.motor_w.int.maxVal'
  'ctrl.motor_v.pid.motor_w.int.minVal'
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

%% [Init   ]: Refresh model to update variant blocks                       

mdl.object.refreshModelBlocks

%% End










