%% [Init   ]: Define parameters                                            
minseg_2p0p0p0p0_init_general

minseg_2p1p0p0p0_init_model_general
minseg_2p1p1p0p0_init_model_plant
minseg_2p1p2p0p0_init_model_controller
%minseg_2p1p3p0p0_init_model_io

minseg_2p1p9p0p0_init_model_build

%% [Init   ]: Serial transmission (hardware only)                          

if ui.plant.dynamics.mode  == 0 % hardware
minseg_2p2p0p0p0_init_serial_write
minseg_2p2p1p0p0_init_serial_read
minseg_2p2p2p0p0_init_serial_general
minseg_2p2p3p0p0_init_serial_reads
minseg_2p2p9p0p0_init_model_build
end

%% [Process]: (hardware only)                                              

if ui.plant.dynamics.mode  == 0 % hardware

% build (normal mode) / run (external mode)
if ui.x.build
minseg_3p0p0p0p0_process_build 
% add if mac: string-compare terminal output for connection to usb programming port
end

% serial transmit (normal mode only)
if (ui.x.write || ui.x.read || ui.x.plot || ui.x.save )  
minseg_3p1p0p0p0_process_serial_transmit 
% add if mac: string-compare terminal output for connection to serial transmission port
end

% serial post-processing
if (              ui.x.read || ui.x.plot || ui.x.save )  
minseg_3p2p0p0p0_process_serial_reads

% if ui.mdl.case == 2
% minseg_3p3p1p0p0_process_motorTF
% end
% 
% if ui.mdl.case == 3
% minseg_3p3p1p0p0_process_gyroBias
% end

end

end

%% [Output]:                                                               

% save
if ui.x.save
minseg_4p0p0p0p0_output_save
end

if ui.plant.dynamics.mode  == 0 % hardware

% plot
if ui.x.plot
minseg_4p1p0p0p0_output_serial_plot
% minseg_4p1p1p0p0_output_serial_plot
end

end

%% [Cleanup]:                                                              

if ui.x.cleanup
minseg_5p0p0p0p0_cleanup
end

%% End










