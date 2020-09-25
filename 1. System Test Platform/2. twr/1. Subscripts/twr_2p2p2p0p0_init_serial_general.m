%% [Init   ]: Define serial communication parameters (general)             

% serial address on PC
% note: to determine current addresses, use command: {ls /dev/tty.*} in Terminal.app

srl.mode.address.usb = 0;

switch ui.srl.x.bluetooth
  
case 0 % usb 
  switch srl.mode.address.usb
  case 0; srl.address = '/dev/tty.usbserial-1410'; % left      usb port (2015 macbook pro)
  case 1; srl.address = '/dev/tty.usbmodem1411'  ; % left      usb port (2015 macbook pro) [legacy]
  case 2; srl.address = '/dev/tty.usbmodem621'   ; % left-rear usb port (2008 macbook    )
      
  end

  % note: Address needs to be changed manually for external mode:
  %         Simulink: Configuration parameters: Hardware implementation:   ...
  %                                             Host-board connection
  
  srl.port    = 0;
  srl.f.baud  = 115200; % [bit / s]
  
case 1 % bluetooth
  srl.address = '/dev/tty.HC-06-DevB';
  srl.port    = 1;
  srl.f.baud  = 038400; % [bit / s]

end

srl.byteOrder         = 'littleEndian';       % [-]
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
switch ui.srl.x.bluetooth

case 0 % usb
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

case 1 % bluetooth
srl.srl = Bluetooth('HC-06', 1);

% For more information:
% a = instrhwinfo('Bluetooth','HC-06')
% b = instrhwinfo('Bluetooth')

end

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

% number of board sample periods per serial sample period

srl.T.decimation = 0; % [integer] [default: 0]
% = 0: minimum value used.
% > 0: user-defined value used.

if srl.T.decimation == 0 % minimum possible value
  srl.T.decimation = ceil( srl.T.transmit * 1.0000 / mdl.T.sample );
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










