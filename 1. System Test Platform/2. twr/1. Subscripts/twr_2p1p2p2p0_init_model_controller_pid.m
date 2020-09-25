%% [Init   ]: Controller: PID                                              

% reference command: wheel.omega [rad/s]
ctrl.motorDriver_v.pid.cmd.thetaDot.val             =  3.00;
ctrl.motorDriver_v.pid.cmd.thetaDot.val_norm.dx.max = +0.01 * inf;
ctrl.motorDriver_v.pid.cmd.thetaDot.val_norm.dx.min = -0.01 * inf;

ctrl.motorDriver_v.pid.k.p = 0.500;
ctrl.motorDriver_v.pid.k.i = 1.000;
ctrl.motorDriver_v.pid.k.d = 0.000;

ctrl.motorDriver_v.pid.int.maxVal = +plant.pSupply.v;
ctrl.motorDriver_v.pid.int.minVal = -plant.pSupply.v;

%% End










