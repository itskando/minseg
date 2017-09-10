%% [Global ]                                                               
clc
clearvars

if ~isempty(instrfindall)
  fclose   (instrfindall);
  delete   (instrfindall);
end

%% [Input  ]: General                                                      
ui.mdl.label       = 'lab5_2_2017a';
ui.mdl.T.sample    =  0.002;
ui.mdl.byte1       = [113; 203]; % first byte sequence

ui.x.build         =  1;
ui.x.read          =  1;
ui.x.plot          =  1;

%% [Input  ]: Serial                                                       
switch 0
  case 0; ui.srl.address = '/dev/tty.usbmodem1411'; % left      usb port (2015 PC)
  case 1; ui.srl.address = '/dev/tty.usbmodem621';  % left-rear usb port (2008 PC)
end

ui.srl.duration          =  100;    % [samples]

ui.srl.data{1,1}.label   = 'First Byte Sequence';
ui.srl.data{1,1}.type    = 'uint8';

ui.srl.data{2,1}.label   = 'seven';
ui.srl.data{2,1}.type    = 'uint8';

ui.srl.data{3,1}.label   = 'counter';
ui.srl.data{3,1}.type    = 'single';

%% [Init   ]: Conversions                                                  

k.byte2bit       = 8;
k.bit2byte       = 1 / k.byte2bit;

%% [Init   ]: Define model parameters                                      

mdl.label    = ui.mdl.label;
mdl.T.sample = ui.mdl.T.sample;
mdl.byte1    = ui.mdl.byte1;

%% [Init   ]: Define serial communication parameters (general)             

srl.address     =  ui.srl.address;      % [-]
srl.byteOrder   = 'littleEndian';          % [-]
srl.f.baud      =  115200;              % [bits/s]
srl.duration    =  ui.srl.duration + 1; % [sample]

% Note: Duration is increased by 1 due to the likelihood of the serial
%       communication starting partway through a sample reading, which must 
%       then be cropped from both ends (thereby removing the added sample).

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
srl.datas.n.Bytes = srl.datas.n.bytes * srl.duration; % [  bytes                  ]
srl.datas.n.Bits  = srl.datas.n.bits  * srl.duration; % [  bits                   ]

%% [Process]: Build                                                        
mdl_T_sample = mdl.T.sample;
mdl_byte1    = mdl.byte1;

srl_address  = srl.address;
srl_baud     = srl.f.baud;
srl_duration = srl.duration;

if ui.x.build
     rtwbuild(mdl.label)
end

%% [Init   ]: Verify serial rate                                           

% Periodic data
srl.T.baud         = 1 / srl.f.baud;                 % [s /bit]
srl.T.capture      = srl.T.baud * srl.datas.n.bits;  % [s / ]

% Check (probably could be tightened.)
assert(srl.T.capture < mdl.T.sample)

%% [Process]: Setup serial object                                          

if ~isempty( instrfind('Port', srl.address) )
  fclose   ( instrfind('Port', srl.address) );
  delete   ( instrfind('Port', srl.address) );
end

srl.srl = serial(                     srl.address      ...
                , 'ByteOrder'       , srl.byteOrder    ...
                , 'BaudRate'        , srl.f.baud       ... [ Hz ]
                , 'InputBufferSize' , srl.datas.n.Bits ... [bits]
                , 'OutputBufferSize', srl.datas.n.Bits ... [bits]
                );

%% [Process]: Open, read, and close serial port object.                    
if ui.x.read

srl.t.start.read = clock;
srl.T.      read = tic;

fopen ( srl.srl );
srl.datas.val = fread( srl.srl           ...  serial object
                     , srl.datas.n.Bytes ... [samples]
                     , srl.datas.type.in ...  default: 'uint8'
                     );
fclose( srl.srl );

srl.T.     read = toc( srl.T.read );
srl.t.stop.read = clock;

% Note: Mathworks forces conversion to 'double' for serial read output.
% Convert output to intended data type:
srl.datas.val = cast( srl.datas.val, srl.datas.type.out );
end

%% [Process]: Format serial port data: Skip partial samples                
if ui.x.read

% Find first available "start byte"
mdl.n.byte1 = size(mdl.byte1, 1);

% Needs to be enough samples to scan full "start byte" sequence
assert(srl.duration > mdl.n.byte1) 

for i0 = 1 : mdl.n.byte1 % For each byte value in the starting sequence    
                         %  check the first serial samples for any bytes which 
                         %  correspond to that start sequence value.
  srl.datas.z0 =                                                         ...
    find( ~( + srl.datas.val( 1 : srl.datas.n.bytes * mdl.n.byte1, 1 )   ...
             - mdl.byte1    (                                  i0, 1 ) ) );
  
  % Find number of hits
  n.hits = size(srl.datas.z0,1);
  
  for    i1 = 1 : n.hits % Check for the hit which continues the sequence
                         %  (all other hits are false positives.)

    if srl.datas.val( (0 : mdl.n.byte1 - 1) * srl.datas.n.bytes ...
                    + srl.datas.z0( i1 , 1)                     ...
                    ) == circshift( mdl.byte1, -(i1 - 1) + n.hits, 2 )

    srl.datas.z1(i0,1) = srl.datas.z0(i1,1);
    break
    
    end
    
  end
 
end
srl.datas.z0 = []; % cleanup
n.hits       = [];

srl.datas.z1 = min( srl.datas.z1 );

end

%% [Process]: Format serial port data: Remove partial samples              
if ui.x.read

% Account for planned cropping of (beginning and ending) partial samples.
srl.duration       = srl.duration - 1;

% Indices at which new samples begin
srl.datas.z.sample = ( 0:srl.duration-1 ).' * srl.datas.n.bytes ...
                   +     srl.datas.z1;

srl.datas.n.bytes0 = 0; % initialize byte offset
for i0 = 1 : srl.datas.n.signals

  % Start indices of signal at each sample
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
    srl.data{i0,1}.val  = srl.datas.val( srl.data{i0,1}.z );
  else % If serial output is not equal to actual datatype, then convert:
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
p = 0;

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










