%% [Init   ]: Plant: Hardware: Variants                                    

plant.hardware.calculation.phi.x.mode              = 0; % [default: 0]
plant.hardware.calculation.phi.x.gyro.         var = Simulink.Variant( 'plant_hardware_calculation_phi_x_mode == 0' );
plant.hardware.calculation.phi.x.accel.        var = Simulink.Variant( 'plant_hardware_calculation_phi_x_mode == 1' );
plant.hardware.calculation.phi.x.gyroAndAccel. var = Simulink.Variant( 'plant_hardware_calculation_phi_x_mode == 2' );

plant.hardware.calculation.phi.y.mode              = 1; % [default: 1]
plant.hardware.calculation.phi.y.gyro.         var = Simulink.Variant( 'plant_hardware_calculation_phi_y_mode == 0' );
plant.hardware.calculation.phi.y.wheelPosition.var = Simulink.Variant( 'plant_hardware_calculation_phi_y_mode == 1' );

plant.hardware.calculation.phi.z.mode              = 0; % [default: 0]
plant.hardware.calculation.phi.z.gyro.         var = Simulink.Variant( 'plant_hardware_calculation_phi_z_mode == 0' );
plant.hardware.calculation.phi.z.accel.        var = Simulink.Variant( 'plant_hardware_calculation_phi_z_mode == 1' );
plant.hardware.calculation.phi.z.gyroAndAccel. var = Simulink.Variant( 'plant_hardware_calculation_phi_z_mode == 2' );

%% [Init   ]: Plant: Hardware: Components                                  

twr_2p1p1p2p1_init_model_plant_hardware_motorDriver
twr_2p1p1p2p2_init_model_plant_hardware_motorEncoder
twr_2p1p1p2p3_init_model_plant_hardware_gyroscope
twr_2p1p1p2p4_init_model_plant_hardware_accelerometer

%% End










