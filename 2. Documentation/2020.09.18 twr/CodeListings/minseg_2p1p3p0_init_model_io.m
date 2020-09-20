%% [Init   ]: Setup board i/o variant subsystems                           

% general

io.write.serial.                                  var = Simulink.Variant( 'mdl_mode == 0' );
io.write.scopes.                                  var = Simulink.Variant( 'mdl_mode == 1' );

% plant: hardware

io.write.serial.hardware.                         var = Simulink.Variant( 'plant_dynamics_mode == 0' );

io.write.serial.hardware.ff.                      var = Simulink.Variant( 'ctrl_motor_v_mode == 0' );
io.write.serial.hardware.pid.                     var = Simulink.Variant( 'ctrl_motor_v_mode == 1' );

io.write.serial.hardware.ff.standard.             var = Simulink.Variant( 'mdl_case == 0' );
io.write.serial.hardware.ff.motorCharacterization.var = Simulink.Variant( 'mdl_case == 1' );

io.write.serial.hardware.pid.standard.            var = Simulink.Variant( 'mdl_case == 0' );
io.write.serial.hardware.pid.sensorCalibration.   var = Simulink.Variant( 'mdl_case == 2' );

% plant: nonlinearDynamics

io.write.serial.nonlinearDynamics.                var = Simulink.Variant( 'plant_dynamics_mode == 1' );

io.write.serial.nonlinearDynamics.ff.             var = Simulink.Variant( 'ctrl_motor_v_mode == 0' );
io.write.serial.nonlinearDynamics.pid.            var = Simulink.Variant( 'ctrl_motor_v_mode == 1' );

io.write.serial.nonlinearDynamics.ff.standard.    var = Simulink.Variant( 'mdl_case == 0' );

io.write.serial.nonlinearDynamics.pid.standard.   var = Simulink.Variant( 'mdl_case == 0' );

% plant: nonlinearDynamics

io.write.serial.linearDynamics.                   var = Simulink.Variant( 'plant_dynamics_mode == 2' );

io.write.serial.linearDynamics.ff.                var = Simulink.Variant( 'ctrl_motor_v_mode == 0' );
io.write.serial.linearDynamics.pid.               var = Simulink.Variant( 'ctrl_motor_v_mode == 1' );

io.write.serial.linearDynamics.ff.standard.       var = Simulink.Variant( 'mdl_case == 0' );

io.write.serial.linearDynamics.pid.standard.      var = Simulink.Variant( 'mdl_case == 0' );

%% [Init   ]: Write commands
io.write.ctrl.motor_v.cmd.tStart          = ui.io.write.ctrl.motor_v.cmd.tStart;          % [  s            ]
io.write.ctrl.motor_v.cmd.val.x           = ui.io.write.ctrl.motor_v.cmd.val.x;           % [ <cmd>         ]
io.write.ctrl.motor_v.cmd.val_norm.dx.max = ui.io.write.ctrl.motor_v.cmd.val_norm.dx.max; % [  cmd.norm / s ]
io.write.ctrl.motor_v.cmd.val_norm.dx.min = ui.io.write.ctrl.motor_v.cmd.val_norm.dx.min; % [  cmd.norm / s ]

%% End










