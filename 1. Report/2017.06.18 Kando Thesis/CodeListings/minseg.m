%% [Global ]                                                               
minseg_0p0p0p0_global

%% [Input  ]: Model                                                        
minseg_1p0p0p0_input

%% [Input  ]: Script: Commands                                              

ui.x.build   = 0; % rebuild required for any change in [input]: model / [init]: model.
ui.x.write   = 0; % not yet implemented
ui.x.read    = 0;
ui.x.plot    = 0; % enables read/write by default.
ui.x.save    = 0; % enables read/write by default.
ui.x.cleanup = 0; % enables read/write by default.

%% [Input  ]: Script: Serial                                                

switch 1  % serial duration
  case 0; ui.srl.n.transmits = 100; % [samples]
  case 1; ui.srl.T.transmits = 020; % [seconds]
end

%% [Input  ]: Script: Save                                                 
ui.save.label = '';

%% [Init   ]: Define parameters                                            
minseg_2p0p0p0_init_general

minseg_2p1p0p0_init_model_general
minseg_2p1p1p0_init_model_plant
minseg_2p1p2p0_init_model_controller
minseg_2p1p3p0_init_model_io
minseg_2p1p9p0_init_model_build

minseg_2p2p0p0_init_serial_write
minseg_2p2p1p0_init_serial_read
minseg_2p2p2p0_init_serial_general
minseg_2p2p3p0_init_serial_reads
minseg_2p2p9p0_init_model_build

%minseg_2p3p0p0_init_build

%% [Process]:                                                              

% build (normal mode) / run (external mode)
if ui.x.build
minseg_3p0p0p0_process_build
end

% serial transmit (normal mode only)
if (ui.x.write || ui.x.read || ui.x.plot || ui.x.save )  
minseg_3p1p0p0_process_serial_transmit
end

% serial post-processing
if (              ui.x.read || ui.x.plot || ui.x.save )  
minseg_3p2p0p0_process_serial_reads

% if ui.mdl.case == 2
% minseg_3p3p1p0_process_motorTF
% end
% 
% if ui.mdl.case == 3
% minseg_3p3p1p0_process_gyroBias
% end

end

%% [Output]:                                                               

% save
if ui.x.save
minseg_4p0p0p0_output_save
end

% plot
if ui.x.plot
minseg_4p1p0p0_output_serial_plot
% minseg_4p1p1p0_output_serial_plot
end

%% [Cleanup]:                                                              

if ui.x.cleanup
minseg_5p0p0p0_cleanup
end

%% End










