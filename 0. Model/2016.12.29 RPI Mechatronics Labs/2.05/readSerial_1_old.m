clc
clearvars

mdl.name   = 'lab5_1';
f.serial_0 = 115200;

rtwbuild(mdl.name)
% set_param(mdl.name, 'SimulationCommand', 'start')

% Create, open, and read serial port object.
srl  = serial( '/dev/tty.usbmodem621'   ...
             , 'ByteOrder', 'bigEndian' ...
             , 'BaudRate',   f.serial_0 ...
             );

       fopen (srl             );

data = fread (srl, 30, 'uint8');
       fclose(instrfindall    );
       delete(instrfindall    );

% set_param(mdl.name, 'SimulationCommand', 'stop')