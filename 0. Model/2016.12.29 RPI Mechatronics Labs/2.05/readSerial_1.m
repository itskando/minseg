%% Global                                                                  
clc
clearvars

%% Input                                                                   
mdl.name        = 'lab5_1';
T.sample        = 0.002;

srl.address     = '/dev/tty.usbmodem621';
srl.baud        = 115200; % [bits/s]

srl.length      = 2;

%% Data rate check                                                         
k.byte2bit      = 8;
k.single2byte   = 4;
n.signal_single = 1;

k.data2bits     = n.signal_single * k.single2byte * k.byte2bit;
k.bits2data     = 1/k.data2bits;

f.baud          = 115200;               % [bits/s]
f.capture       = f.baud * k.bits2data; % [data/s]
T.capture       = 1 / f.capture;

assert(T.capture < T.sample)

%% Build and read                                                          
T_sample    = T.sample;

srl_address = srl.address;
srl_baud    = srl.baud;
srl_length  = srl.length;

rtwbuild(mdl.name)

%% Create, open, and read serial port object.
if 1

srl.T       = tic;
srl.t.start = clock;

srl.srl     = serial(  srl.address             ...
                    , 'ByteOrder', 'bigEndian' ...
                    , 'BaudRate',   srl.baud   ...
                    );

              fopen (srl.address                     );
srl.data    = fread (srl.address, srl.length, 'uint8');
              fclose(instrfindall                    );
              delete(instrfindall                    );

srl.t.stop  = clock;
srl.T       = toc( srl.t.start );

end

%% End










