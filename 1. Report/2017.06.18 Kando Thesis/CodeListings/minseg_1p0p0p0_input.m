%% [Input  ]: Model: General                                               
ui.mdl.label = 'minseg_M2V3_2017a';

ui.mdl.mode  = 0;
% 0: normal
% 1: external

ui.mdl.case  = 0;
%  ##: Case Description:      Plant:    Controller:    Command:
% -01: Clear board            Empty     Empty          Empty    % not yet implemented
% +00: Custom                 Custom    Custom         Custom
% +01: Motor characterization Hardware  FF  - v.motor  0 --> 10 [V]
% +02: Gyro bias calibration  Hardware  PID - w.motor  0 --> 00 [rad/s]
  
%% [Input  ]: Model: Plant                                                 

ui.plant.dynamics.mode        = 0;
% 0: actual hardware
% 1: simulated dynamics (non-linear)
% 2: simulated dynamics (    linear)

ui.plant.n.batteries          = 6; % [range: 0 - 6]

ui.plant.x.bluetoothModule    = 1;
% 0: bluetooth module not inserted into board.
% 1: bluetooth module     inserted into board.

ui.plant.supply.mode          = 1;
% 0: 9.00 [V] (battery pack)
% 1: 4.50 [V] (usb cable) 
% Important: Do NOT set to usb power if actually using battery power.

%% [Input  ]: Model: Controller: body.pitch.theta                          
% not yet implemented.

ui.ctrl.body.pitch.theta.mode = 0;
% #: mode:         input command:   [input command unit]:

%% [Input  ]: Model: Controller: motor.v                                   

ui.ctrl.motor_v.mode          = 1;
% #: mode:         input command:   [input command unit]:
% 0: feedForward   v.motor          [V]
% 1: PID           w.motor          [rad/s]

switch ui.ctrl.motor_v.mode
  
case 0 % feed forward (input: v.motor)
  ui.io.write.ctrl.motor_v.cmd.tStart         (1,1) =  0;
  ui.io.write.ctrl.motor_v.cmd.val.x          (1,1) = +10;
  ui.io.write.ctrl.motor_v.cmd.val_norm.dx.max(1,1) = +0.01;
  ui.io.write.ctrl.motor_v.cmd.val_norm.dx.min(1,1) = -0.01;
  
case 1 % PID          (input: w.motor)
  ui.io.write.ctrl.motor_v.cmd.tStart         (1,1) =  0;
  ui.io.write.ctrl.motor_v.cmd.val.x          (1,1) =  0.50 * 2*pi;
  ui.io.write.ctrl.motor_v.cmd.val_norm.dx.max(1,1) = +0.10;
  ui.io.write.ctrl.motor_v.cmd.val_norm.dx.min(1,1) = -inf;
  
end

%% [Input  ]: Model: Serial                                                
ui.srl.mode.address = 0;
% 0: left      usb port (2015 Macbook Pro)
% 1: left-rear usb port (2008 Macbook Pro)

% Note: Needs to be changed manually for external mode:
% Simulink: Configuration parameters: Hardware implementation: Host-board connection

ui.srl.T.decimation = 0; % [integer] [default: 0]
% Integer factor of board sample time (mdl.T.sample) 
%  in which to iterate serial processes.
% If 0, minimum possible value will be used.
% (Could be greater than 1 if combined size of reads/writes is sufficiently large.)

%% End










