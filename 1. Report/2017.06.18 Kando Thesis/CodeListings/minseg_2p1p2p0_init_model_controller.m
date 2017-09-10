%% [Init   ]: Initialize user-defined parameters                           
ctrl.motor_v.mode = ui.ctrl.motor_v.mode;

%% [Init   ]: Setup controller variant subsystems                          
ctrl.motor_v.ff. motor_v.var = Simulink.Variant( 'ctrl_motor_v_mode == 0' );
ctrl.motor_v.pid.motor_w.var = Simulink.Variant( 'ctrl_motor_v_mode == 1' );

%% [Init   ]: Define controller model parameters                           

switch ctrl.motor_v.mode

case 0 % 
  
case 1
  ctrl.motor_v.pid.motor_w.k.p = 0.500;
  ctrl.motor_v.pid.motor_w.k.i = 1.000;
  ctrl.motor_v.pid.motor_w.k.d = 0.000;

  ctrl.motor_v.pid.motor_w.int.maxVal = +plant.supply.v;
  ctrl.motor_v.pid.motor_w.int.minVal = -plant.supply.v;

end

%% End










