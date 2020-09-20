%% [Global ]                                                               
clc
clearvars

if ~isempty(instrfindall)
  fclose   (instrfindall);
  delete   (instrfindall);
end

%% [Input  ]: General                                                      
ui.mdl.label        = 'coefficientOfFriction_2017a';
ui.mdl.x.mode       =  0;
% 0: normal
% 1: external
ui.mdl.x.v.supply   =  1;
% 0: 9.00 [V] (battery pack)
% 1: 4.50 [V] (usb cable) <-- Important: Do NOT use if batteries are engaged.
                            % Future work: implement saturation safeguards

ui.mtr.w.cmd.rps    =  0.10 * 2*pi; % [rev/s * rad/rev = rad/s]
ui.mtr.w.cmd.tStart =  5;

ui.x.build          =  1;
ui.x.read           =  0;
ui.x.plot           =  1;
ui.x.save           =  0; % not yet implemented :/

%% [Input  ]: Serial: General                                              
switch 0  % serial address on PC
  case 0; ui.srl.address = '/dev/tty.usbmodem1411'; % left      usb port (2015 PC)
  case 1; ui.srl.address = '/dev/tty.usbmodem621';  % left-rear usb port (2008 PC)
end

switch 1  % serial duration 
  case 0; ui.srl.n.sample =  100; % [samples]
  case 1; ui.srl.T        =  015; % [seconds]
end

%% [Input  ]: Serial: Data signals                                         

i0 = 0;

i0 = i0 + 1;
ui.srl.data{i0,1}.label   = 'clock';
ui.srl.data{i0,1}.type    = 'single';

i0 = i0 + 1;
ui.srl.data{i0,1}.label   = 'ui: angVel.command';
ui.srl.data{i0,1}.type    = 'single';

i0 = i0 + 1;
ui.srl.data{i0,1}.label   = 'plant: motor.left  : angVel.measured [rad/s]';
ui.srl.data{i0,1}.type    = 'single';

i0 = i0 + 1;
ui.srl.data{i0,1}.label   = 'plant: motor.middle: angVel.measured [rad/s]';
ui.srl.data{i0,1}.type    = 'single';

i0 = i0 + 1;
ui.srl.data{i0,1}.label   = 'ctrl: PID: motor.left  : angVel.error [rad/s]';
ui.srl.data{i0,1}.type    = 'single';

i0 = i0 + 1;
ui.srl.data{i0,1}.label   = 'ctrl: PID: motor.middle: angVel.error [rad/s]';
ui.srl.data{i0,1}.type    = 'single';

i0 = i0 + 1;
ui.srl.data{i0,1}.label   = 'ctrl: PID: motor.left  : v.command [V]';
ui.srl.data{i0,1}.type    = 'single';

i0 = i0 + 1;
ui.srl.data{i0,1}.label   = 'ctrl: PID: motor.middle: v.command [V]';
ui.srl.data{i0,1}.type    = 'single';

i0 = i0 + 1;
ui.srl.data{i0,1}.label   = 'plant: motorDriver.left  : voltage.command.digital.positive [-]';
ui.srl.data{i0,1}.type    = 'uint8';

i0 = i0 + 1;
ui.srl.data{i0,1}.label   = 'plant: motorDriver.left  : voltage.command.digital.negative [-]';
ui.srl.data{i0,1}.type    = 'uint8';

i0 = i0 + 1;
ui.srl.data{i0,1}.label   = 'plant: motorDriver.middle: voltage.command.digital.positive [-]';
ui.srl.data{i0,1}.type    = 'uint8';

i0 = i0 + 1;
ui.srl.data{i0,1}.label   = 'plant: motorDriver.middle: voltage.command.digital.negative [-]';
ui.srl.data{i0,1}.type    = 'uint8';


%% [Init   ]: Conversions                                                  
k.intmax.uint8   = intmax('uint8');

k.byte2bit       = 8;
k.bit2byte       = 1 / k.byte2bit;

%% [Init   ]: Define general model parameters                              

mdl.label    = ui.mdl.label;

switch ui.mdl.x.v.supply
  case 0; mdl.  T.sample = 0.030;
  case 1; mdl.  T.sample = 0.030;
end

switch ui.mdl.x.v.supply
  case 0; mdl.  v.supply = 9.00;
  case 1; mdl.  v.supply = 4.50;
end

%% [Init   ]: Define controller model parameters                           

ctrl.angVel.pid.k.p = 0.500;
ctrl.angVel.pid.k.i = 1.000;
ctrl.angVel.pid.k.d = 0.000;

%% [Init   ]: Define motor model parameters                                

mtr.encoder.countPerRev = 720;
mtr.encoder.radPerRev   = 2 * pi;

%% [Init   ]: Define serial communication parameters (general)             

srl.address     =  ui.srl.address;      % [-]
srl.byteOrder   = 'littleEndian';       % [-]
srl.f.baud      =  115200;              % [bits/s]

% serial duration may be specified directly in terms of samples or in terms of time.
try    srl.n.sample = round( ui.srl.T / mdl.T.sample ); % [samples]
catch; srl.n.sample = ui.srl.n.sample;                  % [samples]
end

%% [Init   ]: Define serial communication parameters (datas)               
srl.data            =    ui.srl.data;
srl.datas.n.signals =  size(srl.data, 1);
srl.datas.type.in   = 'uint8';
srl.datas.type.out  = 'uint8';

% legend:
% data  involves individual signals.
% datas involves        all signals.

% Initialize
srl.datas.n.bytes       = 0;

srl.datas.n.type.uint8  = 0;
srl.datas.n.type.uint16 = 0;
srl.datas.n.type.uint32 = 0;

srl.datas.n.type.int8   = 0;
srl.datas.n.type.int16  = 0;
srl.datas.n.type.int32  = 0;

srl.datas.n.type.single = 0;
srl.datas.n.type.double = 0;

for i = 1 : srl.datas.n.signals                                            

  % Counter for each signal type [ - ]
  switch srl.data{i,1}.type
  case 'uint8' ; srl.datas.n.type.uint8  = srl.datas.n.type.uint8  + 1;
  case 'uint16'; srl.datas.n.type.uint16 = srl.datas.n.type.uint16 + 1;
  case 'uint32'; srl.datas.n.type.uint32 = srl.datas.n.type.uint32 + 1;

  case 'int8'  ; srl.datas.n.type.int8   = srl.datas.n.type.int8   + 1;
  case 'int16' ; srl.datas.n.type.int16  = srl.datas.n.type.int16  + 1;
  case 'int32' ; srl.datas.n.type.int32  = srl.datas.n.type.int32  + 1;

  case 'single'; srl.datas.n.type.single = srl.datas.n.type.single + 1;
  case 'double'; srl.datas.n.type.double = srl.datas.n.type.double + 1;
  otherwise;     error('unknown datatype');
  end
  
  switch srl.data{i,1}.type
  case 'uint8' ; srl.data{i,1}.n.bytes = 1;           % [ (bytes/signal) / sample ]
  case 'uint16'; srl.data{i,1}.n.bytes = 2;
  case 'uint32'; srl.data{i,1}.n.bytes = 4;

  case 'int8'  ; srl.data{i,1}.n.bytes = 1;
  case 'int16' ; srl.data{i,1}.n.bytes = 2;
  case 'int32' ; srl.data{i,1}.n.bytes = 4;

  case 'single'; srl.data{i,1}.n.bytes = 4;
  case 'double'; srl.data{i,1}.n.bytes = 8;
  otherwise;     error('unknown datatype');
  end
  
  
  srl.data{i,1}.n.bits   = srl.datas.n.bytes        ...
                         * k.byte2bit;                % [ (bits /signal) / sample ]

  srl.datas.    n.bytes  = srl.datas.n.bytes        ...
                         + srl.data{i,1}.n.bytes;     % [  bytes         / sample ]
  
end

srl.datas.n.bits  = srl.datas.n.bytes * k.byte2bit;   % [  bits          / sample ]
srl.datas.n.Bytes = srl.datas.n.bytes * srl.n.sample; % [  bytes                  ]
srl.datas.n.Bits  = srl.datas.n.bits  * srl.n.sample; % [  bits                   ]

%% [Process]: Build (Normal mode or External mode)                         
k_intmax_uint8          = k.intmax.uint8;

mdl_T_sample            = mdl.T.sample;
mdl_v_supply            = mdl.v.supply;

ui_mtr_w_cmd_rps        = ui.mtr.w.cmd.rps;
ui_mtr_w_cmd_tStart     = ui.mtr.w.cmd.tStart;

ctrl_angVel_pid_k_p     = ctrl.angVel.pid.k.p;
ctrl_angVel_pid_k_i     = ctrl.angVel.pid.k.i;
ctrl_angVel_pid_k_d     = ctrl.angVel.pid.k.d;

mtr_encoder_countPerRev = mtr.encoder.countPerRev;
mtr_encoder_radPerRev   = mtr.encoder.radPerRev;

srl_address             = srl.address;
srl_baud                = srl.f.baud;
srl_duration            = srl.n.sample;

if ui.x.build
  
  switch ui.mdl.x.mode
  
  case 0 % Normal mode
  set_param(mdl.label, 'SimulationMode',    'normal'  ) % put model into normal   mode
  rtwbuild (mdl.label                                 ) % build model into hardware
  
  case 1 % External mode
  set_param(mdl.label, 'SimulationMode',    'external') % put model into external mode
  set_param(mdl.label, 'SimulationCommand', 'connect' ) % connect to the executable
  set_param(mdl.label, 'SimulationCommand', 'start'   ) % start      the executable
% set_param(mdl.label, 'SimulationCommand', 'stop'    ) % stop       the executable

  end

end

%% [Init   ]: Verify serial rate                                           
if (ui.x.read || ui.x.save || ui.x.plot)

% Periodic data
srl.T.baud         = 1 / srl.f.baud;                        % [s /bit]
srl.T.capture      = srl.T.baud * (srl.datas.n.bits + 16);  % [s / ]
% Note: 2 bytes (16 bits) added to account for header and terminator.

% Check (probably could be tightened.)
assert(srl.T.capture < mdl.T.sample)

end

%% [Process]: Setup serial object                                          
if (ui.x.read || ui.x.save || ui.x.plot)

if ~isempty( instrfind('Port', srl.address) )
  fclose   ( instrfind('Port', srl.address) );
  delete   ( instrfind('Port', srl.address) );
end

srl.srl = serial(                     srl.address      ...
                , 'ByteOrder'       , srl.byteOrder    ...
                , 'BaudRate'        , srl.f.baud       ... [ Hz ]
                , 'InputBufferSize' , srl.datas.n.bits ... [bits]
                , 'OutputBufferSize', srl.datas.n.bits ... [bits]
                );

end

%% [Process]: Open, read, and close serial port object.                    
if (ui.x.read || ui.x.save || ui.x.plot)

srl.t.start.read = clock;
srl.T.start.read = tic;

srl.datas.val    = [];

fopen ( srl.srl );
for i0 = 1 : srl.n.sample

srl.T.start.read0 = tic;
  
srl.datas.val0 = fread( srl.srl           ... serial object
                      , srl.datas.n.bytes ... read size  [bytes/sample * samples]
                      , srl.datas.type.in ... input data class [default: 'uint8']
                      );

srl.datas.val  = [srl.datas.val; srl.datas.val0];

if i0 ~= srl.n.sample                           % if not the last sample
  while toc( srl.T.start.read0 ) < mdl.T.sample % then loop until complete
  end                                           % sample period has passed
end                                             % before reading again.

end
fclose( srl.srl );

srl.T.     read = toc( srl.T.start.read );
srl.t.stop.read = clock;

% Note: Mathworks forces conversion to 'double' for serial read output.
% Convert output to intended data type:
srl.datas.val = cast( srl.datas.val, srl.datas.type.out );
end

%% [Process]: Format serial port data                                      
if (ui.x.read || ui.x.save || ui.x.plot)

% Start index of each sample
srl.datas.z.sample = ( 0:srl.n.sample-1 ).' * srl.datas.n.bytes + 1;

srl.datas.n.bytes0 = 0; % initialize byte offset
for i0 = 1 : srl.datas.n.signals

  % Start index of signal at each sample
  srl.data{i0,1}.z    = srl.datas.z.sample + srl.datas.n.bytes0;

  % Include additional indices for multibyte signals
  if srl.data{i0,1}.n.bytes > 1
     srl.data{i0,1}.z       = bsxfun( @plus                      ...
                                    ,   srl.data{i0,1}.z         ...
                                    , 0:srl.data{i0,1}.n.bytes-1 ...
                                    );
  end

  % Pull corresponding values
  if strcmp( srl.data{i0,1}.type, srl.datas.type.out )
       % If intended signal datatype is     equal to serial output, 
       % then use it immediately:
    srl.data{i0,1}.val  = srl.datas.val( srl.data{i0,1}.z );
    
  else % If intended signal datatype is not equal to serial output, 
       % then first convert the serial output:
    srl.data{i0,1}.val0 = srl.datas.val( srl.data{i0,1}.z );
    
    % Convert to cell:
    srl.data{i0,1}.val  = mat2cell(             srl.data{i0,1}.val0          ...
                                  , ones( size( srl.data{i0,1}.val0, 1 ), 1) ...
                                  ,       size( srl.data{i0,1}.val0, 2 )     ...
                                  );
    % Typecast each row vector to correct type:
    srl.data{i0,1}.val  = cellfun (@(x) typecast( x, srl.data{i0,1}.type )   ...
                                  , srl.data{i0,1}.val                       ...
                                  );
    % Convert back to matrix: [unnecessary - cellfun converts to matrix already]
  % srl.data{i0,1}.val  = cell2mat( srl.data{i0,1}.val );
  end
  
  

  % Increment byte offset
  srl.datas.n.bytes0 = srl.datas.n.bytes0 + srl.data{i0,1}.n.bytes;

end

end

%% [Output ]: Plot setup                                                   
if ui.x.plot

p = 0;

end

%% [Output ]: Plot setup                                                   
if ui.x.plot

p = 0;

end

%% [Output ]: Plot                                                         
if ui.x.plot

for i = 1 : srl.datas.n.signals                                            
    
p = p + 1;
figure(p)

stairs(srl.data{i,1}.val, '.-')

xlabel( 'Samples [-]'       )
ylabel( srl.data{i,1}.label )

grid minor

end

end

%% End










