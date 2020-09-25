%% [Init   ]: Define serial communication parameters (general)             

% serial address on PC
switch ui.srl.mode.address
  case 0; srl.address = '/dev/tty.usbmodem1411'; % left      usb port (2015 PC)
  case 1; srl.address = '/dev/tty.usbmodem621';  % left-rear usb port (2008 PC)
end
% note: to determine current address, use command: {ls /dev/tty.*} in Terminal.app

srl.byteOrder         = 'littleEndian';       % [-]
srl.f.baud            =  115200;              % [bit /   s]
srl.T.baud            =  1 / srl.f.baud;      % [  s / bit]

srl.type.in           = 'uint8'; % signal datatype when entering transmission
srl.type.out          = 'uint8'; % signal datatype when exiting  transmission

% legend:
% read  involves a single read  (1   sample ).
% reads involves      all reads (all samples).

%% [Init   ]: Serial buffer size                       

srl.bufferSize.in  = max( [0; srl.read{1,1}.n.Bits] ); % [bits]
srl.bufferSize.out = srl.bufferSize.in;                % [bits]

% buffer sizes should be equivalent to write or read size (whichever is higher).

%% [Process]: Setup serial object                                          

% Ensure that desired serial port does not already exist in the loaded list:
if ~isempty( instrfind('Port', srl.address) )
  fclose   ( instrfind('Port', srl.address) );
  delete   ( instrfind('Port', srl.address) );
end

% Initialize serial object
srl.srl = serial(                     srl.address        ...
                , 'ByteOrder'       , srl.byteOrder      ...
                , 'BaudRate'        , srl.f.baud         ... [ Hz ]
                , 'InputBufferSize' , srl.bufferSize.in  ... [bits]
                , 'OutputBufferSize', srl.bufferSize.out ... [bits]
                );

% For detailed information, use: get(srl.srl)

%{
how prove no "header" value?
how read timeout period? how reduce to something reasonable?

find more information on: 

  TimerPeriod = 1
  Timeout     = 10
  StopBits    = 1

%}

%% [Init   ]: Time required to perform transmission                        

% time required to transmit each write:
srl.write{1,1}.T.transmit = srl.T.baud * (             0             ); % [ s / write ]
                          %  [s / bit] * (       [bit / write]       )

% time required to transmit each read:
srl.read {1,1}.T.transmit = srl.T.baud * ( srl.read{1,1}.n.Bits + 08 ); % [ s / read  ]
                          %  [s / bit] * (        [bit / read]       )
% note: 1 byte (08 bits) added to account for terminator (1 byte).

srl.read {1,1}.T.transmit = srl.read {1,1}.T.transmit * 10 / 08;

% time required to perform all transmissions:
srl.T.transmit = srl.write{1,1}.T.transmit + srl.read{1,1}.T.transmit;  % [ s ]

%% [Init   ]: Time between start of each transmission

% number of board sample periods per serial process period     

if ui.srl.T.decimation == 0
srl.T.decimation = ceil( srl.T.transmit * 1.0000 / mdl.T.sample );

else
srl.T.decimation = ui.srl.T.decimation;  

end

% time until next serial process:
srl.T.sample = mdl.T.sample * srl.T.decimation;                     % [ s ]

%% [Init   ]: Verify serial period                                         

% verify that total time to transmit serial data is not greater than
%  time until start of next serial process:
assert( srl.T.transmit < srl.T.sample                ...
      , 'Read period is greater than sample period.' ...
      );

%% [Init   ]: Define serial transmits parameters                           

% number of reads to perform:
% note: serial duration may be specified directly in terms of samples or in terms of time
try    srl.n.transmits = round( ui.srl.T.transmits / srl.T.sample ); % [transmit cycles]
catch; srl.n.transmits =        ui.srl.n.transmits;                  % [transmit cycles]
end

srl.n.transmits = srl.n.transmits + 1; % 1 added for time = 0

%% End










