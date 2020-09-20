%% [Input  ]: Initialize user-specified controller commands                

%   ui.io.write.ctrl.v_mtr.cmd.tStart          = zeros(5,1);        % [  s            ]
%   ui.io.write.ctrl.v_mtr.cmd.val.x           = zeros(5,1);        % [ <cmd>         ]
%   ui.io.write.ctrl.v_mtr.cmd.val_norm.dx.max = ones (5,1) * +inf; % [  cmd.norm / s ]
%   ui.io.write.ctrl.v_mtr.cmd.val_norm.dx.min = ones (5,1) * -inf; % [  cmd.norm / s ]

%% [Input  ]: Define user-specified controller commands                    

switch ui.ctrl.motor.v.mode
  
case 0 % direct feed forward (input: v.motor.input)
  ui.io.write.ctrl.motor.v.cmd.tStart         (1,1) =  0;
  ui.io.write.ctrl.motor.v.cmd.val.x          (1,1) = +10;
  ui.io.write.ctrl.motor.v.cmd.val_norm.dx.max(1,1) = +0.01;
  ui.io.write.ctrl.motor.v.cmd.val_norm.dx.min(1,1) = -0.01;
  
case 1 % PID (input: w.motor)
  ui.io.write.ctrl.motor.v.cmd.tStart         (1,1) =  0;
  ui.io.write.ctrl.motor.v.cmd.val.x          (1,1) =  0.50 * 2*pi;
  ui.io.write.ctrl.motor.v.cmd.val_norm.dx.max(1,1) = +0.2;
  ui.io.write.ctrl.motor.v.cmd.val_norm.dx.min(1,1) = -inf;
  
end

%% End










