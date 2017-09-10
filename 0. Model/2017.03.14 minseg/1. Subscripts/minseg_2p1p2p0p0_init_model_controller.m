%% [Init   ]: Controller: Initialize user-defined parameters               
ctrl.motorDriver_v.mode = ui.ctrl.motorDriver_v.mode;

%http://www.ele.uri.edu/courses/ele504/s16/
%http://www.ele.uri.edu/courses/ele504/s16/class_videos.html

%% [Init   ]: Controller: Setup variants                                   
ctrl.motorDriver_v.ff.     var = Simulink.Variant( ' ctrl_motorDriver_v_mode == 0 ' );
ctrl.motorDriver_v.pid.    var = Simulink.Variant( ' ctrl_motorDriver_v_mode == 1 ' );
ctrl.motorDriver_v.sfr.    var = Simulink.Variant( ' ctrl_motorDriver_v_mode == 2 ' );
ctrl.motorDriver_v.sfr_rts.var = Simulink.Variant( ' ctrl_motorDriver_v_mode == 3 ' );

ctrl.motorDriver_v.SFR.    var = Simulink.Variant(['(ctrl_motorDriver_v_mode == 2)' ...
                                                   '  || '                          ...
                                                   '(ctrl_motorDriver_v_mode == 3)']);

%% [Init   ]: Controller: Timing                                           

ctrl.motorDriver_v.T.init = 002; % [s]
ctrl.motorDriver_v.T.cmd  = 010; % [s]

%% [Init   ]: Controller: Mode-specific                                    
switch ctrl.motorDriver_v.mode

case 0; minseg_2p1p2p1p0_init_model_controller_ff
case 1; minseg_2p1p2p2p0_init_model_controller_pid
case 2; minseg_2p1p2p3p0_init_model_controller_sfr % sfr
case 3; minseg_2p1p2p3p0_init_model_controller_sfr % sfr with rts

end

%% [Init   ]: Controller: Output saturation                                

switch 0
  
case -1 % none
ctrl.motorDriver_v.output.max = +inf;
ctrl.motorDriver_v.output.min = -inf;

case +0 % plant power supply nominal voltage
ctrl.motorDriver_v.output.max = +plant.pSupply.v;
ctrl.motorDriver_v.output.min = -plant.pSupply.v;

end

%% End










