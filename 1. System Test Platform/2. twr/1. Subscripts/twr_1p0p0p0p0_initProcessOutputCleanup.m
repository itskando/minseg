%% [Init   ]: Define parameters                                            
twr_2p0p0p0p0_init_general

twr_2p1p0p0p0_init_model_general
twr_2p1p1p0p0_init_model_plant
twr_2p1p2p0p0_init_model_controller
%twr_2p1p3p0p0_init_model_io

twr_2p1p9p0p0_init_model_build

%% [Init   ]: Serial transmission (hardware only)                          

if ui.plant.dynamics.mode  == 0 % hardware
twr_2p2p0p0p0_init_serial_write
twr_2p2p1p0p0_init_serial_read
twr_2p2p2p0p0_init_serial_general
twr_2p2p3p0p0_init_serial_reads
twr_2p2p9p0p0_init_model_build
end

%% [Process]: (hardware only)                                              

if ui.plant.dynamics.mode  == 0 % hardware

% build (normal mode) / run (external mode)
if ui.x.build
twr_3p0p0p0p0_process_build 
% add if mac: string-compare terminal output for connection to usb programming port
end

% serial transmit (normal mode only)
if (ui.x.write || ui.x.read || ui.x.plot || ui.x.save )  
twr_3p1p0p0p0_process_serial_transmit 
% add if mac: string-compare terminal output for connection to serial transmission port
end

% serial post-processing
if (              ui.x.read || ui.x.plot || ui.x.save )  
twr_3p2p0p0p0_process_serial_reads

% if ui.mdl.case == 2
% twr_3p3p1p0p0_process_motorTF
% end
% 
% if ui.mdl.case == 3
% twr_3p3p1p0p0_process_gyroBias
% end

end

end

%% [Output]:                                                               

% save
if ui.x.save
twr_4p0p0p0p0_output_save
end

if ui.plant.dynamics.mode  == 0 % hardware

% plot
if ui.x.plot
twr_4p1p0p0p0_output_serial_plot
% twr_4p1p1p0p0_output_serial_plot
end

end

%% [Cleanup]:                                                              

if ui.x.cleanup
twr_5p0p0p0p0_cleanup
end

%% End










