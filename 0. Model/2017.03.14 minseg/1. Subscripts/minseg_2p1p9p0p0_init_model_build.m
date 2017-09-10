%% [Init   ]: Initialize list of general parameters used within Simulink model

mdl.parameter.label = {};

% Specify parameters which will be used in model:
mdl.parameter.label = [...
mdl.parameter.label
{ 
  'k.intmax.uint8'

  'mdl.T.sample'
  'mdl.mode'
  
  'mdl.case'
  'mdl.standard.var'
  'mdl.motorCharacterization.var'
  'mdl.sensorCalibration.var'
  
  'plant.T.init'
  'plant.pSupply.v'
  
  'plant.wheel.r'
  'plant.body.l.w'
  'plant.body.l.c'
  
  'plant.dynamics.mode'
  'plant.hardware.var'
  'plant.nonlinearDynamics.var'
  'plant.linearDynamics.var'
  
  'ctrl.motorDriver_v.T.init'
  'ctrl.motorDriver_v.T.cmd'
  
  'ctrl.motorDriver_v.mode'
  'ctrl.motorDriver_v.ff.var'
  'ctrl.motorDriver_v.pid.var'
  'ctrl.motorDriver_v.sfr.var'
  'ctrl.motorDriver_v.sfr_rts.var'
  'ctrl.motorDriver_v.SFR.var'
  
  'ctrl.motorDriver_v.output.max'
  'ctrl.motorDriver_v.output.min'
  
}];

%% [Init   ]: Append case-dependent parameters: Plant: Dynamics model      

switch plant.dynamics.mode

case 0 % hardware
mdl.parameter.label = [...
mdl.parameter.label
{ 
  'plant.mtr.driver.left.pin.pos'
  'plant.mtr.driver.left.pin.neg'
  'plant.mtr.driver.middle.pin.pos'
  'plant.mtr.driver.middle.pin.neg'

  'plant.mtr.encoder.left.pin.A'
  'plant.mtr.encoder.left.pin.B'
  'plant.mtr.encoder.middle.pin.A'
  'plant.mtr.encoder.middle.pin.B'

  'plant.mtr.encoder.count2wheelRad'
  
  'plant.mtr.encoder.filter.z.num'
  'plant.mtr.encoder.filter.z.den'
  
  'plant.gyro.dlpf.mode'
  'plant.gyro.k_digital2analog'
  
  'plant.gyro.bias.movingAverage.n.pts'
  
% 'plant.gyro.filter.z.ss.A'
% 'plant.gyro.filter.z.ss.B'
% 'plant.gyro.filter.z.ss.C'
% 'plant.gyro.filter.z.ss.D'
  
  'plant.gyro.filter.z.num'
  'plant.gyro.filter.z.den'
  
  'plant.accel.k_digital2analog'
  
  'plant.hardware.calculation.phi.x.mode'
  'plant.hardware.calculation.phi.x.gyro.var'
  'plant.hardware.calculation.phi.x.accel.var'
  'plant.hardware.calculation.phi.x.gyroAndAccel.var'

  'plant.hardware.calculation.phi.y.mode'
  'plant.hardware.calculation.phi.y.gyro.var'
  'plant.hardware.calculation.phi.y.wheelPosition.var'

  'plant.hardware.calculation.phi.z.mode'
  'plant.hardware.calculation.phi.z.gyro.var'
  'plant.hardware.calculation.phi.z.accel.var'
  'plant.hardware.calculation.phi.z.gyroAndAccel.var'
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
  'plant.linear.ss.t.A'
  'plant.linear.ss.t.B'
  'plant.linear.ss.t.C'
  'plant.linear.ss.t.D'
  'plant.linear.ss.stateIC'
}];

end

%% [Init   ]: Append case-dependent parameters: Controller: v.motor.input

switch ctrl.motorDriver_v.mode

case 0 % feed-forward
mdl.parameter.label = [...
mdl.parameter.label
{ 
  'ctrl.motorDriver_v.ff.cmd.v.val'
  'ctrl.motorDriver_v.ff.cmd.v.val_norm.dx.max'
  'ctrl.motorDriver_v.ff.cmd.v.val_norm.dx.min'
}];

case 1 % PID
mdl.parameter.label = [...
mdl.parameter.label
{ 
  'ctrl.motorDriver_v.pid.cmd.thetaDot.val'
  'ctrl.motorDriver_v.pid.cmd.thetaDot.val_norm.dx.max'
  'ctrl.motorDriver_v.pid.cmd.thetaDot.val_norm.dx.min'

  'ctrl.motorDriver_v.pid.k.p'
  'ctrl.motorDriver_v.pid.k.i'
  'ctrl.motorDriver_v.pid.k.d'

  'ctrl.motorDriver_v.pid.int.maxVal'
  'ctrl.motorDriver_v.pid.int.minVal'
}];

case 2 % SFR
mdl.parameter.label = [...
mdl.parameter.label
{ 
  'ctrl.motorDriver_v.sfr.cmd.p.x.mag'
  'ctrl.motorDriver_v.sfr.cmd.p.y.mag'
  'ctrl.motorDriver_v.sfr.cmd.p.x.f'
  'ctrl.motorDriver_v.sfr.cmd.p.y.f'
  
  'ctrl.motorDriver_v.sfr.K'
}];

case 3 % SFR with RTS
mdl.parameter.label = [...
mdl.parameter.label
{ 
  'ctrl.motorDriver_v.sfr.cmd.p.x.mag'
  'ctrl.motorDriver_v.sfr.cmd.p.y.mag'
  'ctrl.motorDriver_v.sfr.cmd.p.x.f'
  'ctrl.motorDriver_v.sfr.cmd.p.y.f'
    
  'ctrl.motorDriver_v.rts.ss.k.A'
  'ctrl.motorDriver_v.rts.ss.k.B'
  'ctrl.motorDriver_v.rts.ss.k.C'
  'ctrl.motorDriver_v.rts.ss.k.D'
  'ctrl.motorDriver_v.rts.ss.stateIC'
  
  'ctrl.motorDriver_v.sfr.K_plant'
  'ctrl.motorDriver_v.sfr.K_rts'
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










