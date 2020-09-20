%% [Global ]                                                               
minseg_0p0p0p0p0_global

%% [Input  ]: Script: Commands                                             

ui.x.build   = 0; % rebuild required after any changes to scripts.
ui.x.write   = 0; % not implemented
ui.x.read    = 0;
ui.x.plot    = 0; % enables read/write by default.

ui.x.save    = 0;
ui.x.cleanup = 0;

%% [Input  ]: Script: Save                                                 
ui.save.label = ''; % [default: '']

%% [Input  ]: Model: General                                               

ui.mdl.mode  = 0; % [default: 0]
% 0: normal
% 1: external

ui.mdl.case  = 0; % [default: 0]
%  ##: Case Description:      Plant:    Controller:    Command:
% -01: Clear board            Empty     Empty          Empty             % not implemented.
% +00: Custom                 Custom    Custom         Custom
% +01: Motor characterization Hardware  FF  - v.motor  0 --> 10 [V]      % not implemented.
% +02: Gyro bias calibration  Hardware  PID - w.motor  0 --> 00 [rad/s]  % not implemented.
  
%% [Input  ]: Model: Plant                                                 

ui.plant.dynamics.mode        = 0; % [default: 0 or 2]
% 0: actual hardware
% 1: simulated dynamics (non-linear) [not implemented]
% 2: simulated dynamics (    linear)

%% [Input  ]: Model: Controller: motor.v                                   

ui.ctrl.motorDriver_v.mode    = 3; % [default: 3]
% #: mode:          input command:   [input command unit]:
% 0: feedForward    v.motor          [V]
% 1: PID            w.motor          [rad/s]
% 2: SFR            theta.motor      [rad]
%                   phi.y.motor      [rad]
% 3: SFR with RTS   theta.motor      [rad]
%                   phi.y.motor      [rad]

%% [Input  ]: Model: Serial                                                

ui.srl.x.bluetooth = 0;
% note: requires prior physical installation of bluetooth module into hardware.

switch 1  % serial duration
  case 0; ui.srl.n.transmits = 100; % [samples]
  case 1; ui.srl.T.transmits = 015; % [seconds]
end

%% [Init   ]: initProcessOutputCleanup                                     
minseg_1p0p0p0p0_initProcessOutputCleanup

%% End










