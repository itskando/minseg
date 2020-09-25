%% [Init   ]: Import serial read signal label and datatype from model      

% serial read block location:
srl.read{1,1}.block.path = ...
  [  mdl.label '/User IO/Writes (To PC)/' ];

while 1 % continue until 'break' command
  
  srl.read{1,1}.block.path0 = get_param(  srl.read{1,1}.block.path         ...
                                       , 'ActiveVariantBlock'              ...
                                       );

  if isempty( srl.read{1,1}.block.path0 )
  break
  end
  
  srl.read{1,1}.block.path  = srl.read{1,1}.block.path0;
  
end

% serial read block names:
srl.read{1,1}.block.busSelect.label =                     ...
find_system(  srl.read{1,1}.block.path                    ...
           , 'Regexp', 'on'                               ...
           , 'Name',   'Bus Selector'                     ...
           );

srl.read{1,1}.block.convert.label =                       ...
find_system(  srl.read{1,1}.block.path                    ...
           , 'Regexp', 'on'                               ...
           , 'Name',   'Data Type Conversion*'            ...
           );

srl.read{1,1}.block.bytepack.label =                      ...
find_system(  srl.read{1,1}.block.path                    ...
           ,  'Regexp', 'on'                              ...
           ,  'Name',   'Byte Pack*'                      ...
           );

% import output signal labels from bus block
srl.read{1,1}.block.busSelect.signals.out =               ...
get_param  ( srl.read{1,1}.block.busSelect.label          ...
           , 'OutputSignals'                              ...
           );

srl.read{1,1}.block.busSelect.signals.out =               ...
regexp     ( srl.read{1,1}.block.busSelect.signals.out{:} ...
           , '[^,]*'                                      ...
           , 'match'                                      ...
           ).';

% verify equivalent number of each type of serial read preprocessing block:
assert(   size( srl.read{1,1}.block.busSelect.signals.out, 1 ) == ...
          size( srl.read{1,1}.block.convert.label,         1 )    ...
      , [ srl.read{1,1}.block.path ':\n'                          ...
         'Less Convert blocks than number of signals.']           ...
      , 0                                                         ...
      ) % 0 allows use of '\n'

assert(   size( srl.read{1,1}.block.busSelect.signals.out, 1 ) == ...
          size( srl.read{1,1}.block.bytepack.label, 1 )           ...
      , [ srl.read{1,1}.block.path ':\n'                          ...
         'Less Byte Pack blocks than number of signals.']         ...
      , 0                                                         ...
      ) % 0 allows use of '\n'

%% [Init   ]: Define serial read signal label and datatype parameters      

% number of signals being transmitted:
srl.read {1,1}.n.signals = size( srl.read{1,1}.block.convert.label, 1 );

% increase srl.read cell vector size to number of signals
srl.read { srl.read{1,1}.n.signals, 1 } = [];
srl.reads{ srl.read{1,1}.n.signals, 1 } = [];


% for each serial read signal existing within the model:
for i0 = 1 : srl.read{1,1}.n.signals
  
  % import the datalabel of that signal from the bus block
  srl.read{i0,1}.label = srl.read{1,1}.block.busSelect.signals.out{i0,1};
  
  % import the datatype of that signal from the datatype conversion block
  srl.read{i0,1}.type.original = ...
  get_param( srl.read{ 1,1}.block.convert. label{i0,1}, 'OutDataTypeStr' );

  % for posterity, set the datatype in the bytepack block to the same datatype.
  set_param( srl.read{ 1,1}.block.bytepack.label{i0,1}, 'datatypes',     ...
      ['{''' srl.read{i0,1}.type.original '''}' ]                        );

end

%% [Init   ]: Define serial read signal size parameters                    

% initialize counters
srl.read{1,1}.n.Bytes       = 0; % [bytes                  / read]

srl.read{1,1}.n.type.uint8  = 0; % [type: 'uint8'  signals / read]
srl.read{1,1}.n.type.uint16 = 0; % [type: 'uint16' signals / read]
srl.read{1,1}.n.type.uint32 = 0; % [type: 'uint32' signals / read]

srl.read{1,1}.n.type.int8   = 0; % [type: 'int8'   signals / read]
srl.read{1,1}.n.type.int16  = 0; % [type: 'int16'  signals / read]
srl.read{1,1}.n.type.int32  = 0; % [type: 'int32'  signals / read]

srl.read{1,1}.n.type.single = 0; % [type: 'single' signals / read]
srl.read{1,1}.n.type.double = 0; % [type: 'double' signals / read]

for i0 = 1 : srl.read{1,1}.n.signals

  % increment counter for appropriate signal type [ - ]
  switch srl.read{i0,1}.type.original
  case 'uint8' ; srl.read{1,1}.n.type.uint8  = srl.read{1,1}.n.type.uint8  + 1;
  case 'uint16'; srl.read{1,1}.n.type.uint16 = srl.read{1,1}.n.type.uint16 + 1;
  case 'uint32'; srl.read{1,1}.n.type.uint32 = srl.read{1,1}.n.type.uint32 + 1;

  case 'int8'  ; srl.read{1,1}.n.type.int8   = srl.read{1,1}.n.type.int8   + 1;
  case 'int16' ; srl.read{1,1}.n.type.int16  = srl.read{1,1}.n.type.int16  + 1;
  case 'int32' ; srl.read{1,1}.n.type.int32  = srl.read{1,1}.n.type.int32  + 1;

  case 'single'; srl.read{1,1}.n.type.single = srl.read{1,1}.n.type.single + 1;
  case 'double'; srl.read{1,1}.n.type.double = srl.read{1,1}.n.type.double + 1;
  otherwise;     error('unknown datatype');
  end
  
  switch srl.read{i0,1}.type.original
  case 'uint8' ; srl.read{i0,1}.n.bytes = 1;       % [ (bytes/signal) / read ]
  case 'uint16'; srl.read{i0,1}.n.bytes = 2;       % [ (bytes/signal) / read ]
  case 'uint32'; srl.read{i0,1}.n.bytes = 4;       % [ (bytes/signal) / read ]

  case 'int8'  ; srl.read{i0,1}.n.bytes = 1;       % [ (bytes/signal) / read ]
  case 'int16' ; srl.read{i0,1}.n.bytes = 2;       % [ (bytes/signal) / read ]
  case 'int32' ; srl.read{i0,1}.n.bytes = 4;       % [ (bytes/signal) / read ]

  case 'single'; srl.read{i0,1}.n.bytes = 4;       % [ (bytes/signal) / read ]
  case 'double'; srl.read{i0,1}.n.bytes = 8;       % [ (bytes/signal) / read ]
  otherwise;     error('unknown datatype');
  end
    
  srl.read{i0,1}.n.bits  = srl.read{i0,1}.n.bytes  ...
                         * k.byte2bit;             % [ (bits /signal) / read ]

  srl.read{1 ,1}.n.Bytes = srl.read{1 ,1}.n.Bytes  ...
                         + srl.read{i0,1}.n.bytes; % [  bytes         / read ]
  
end

  srl.read{1 ,1}. n.Bits = srl.read{1 ,1}.n.Bytes  ...
                         * k.byte2bit;             % [  bits          / read ]

% verify number of bytes per read is not greater than arduino input buffer:
assert( (srl.read{1,1}.n.Bytes + 1) <= 64              ...
      , ['Number of bytes being sent per read '        ...
         '(including 1 byte for Terminator)\n'         ...
         'is greater than size of\n'                   ...
         'Arduino Mega 2650 input buffer (64 bytes).'] ...
      ,   0                                            ...
      )

%% [Init   ]: Initialize serial read value vectors                     

for i0 = 1 : srl.read{1,1}.n.signals
srl.read {i0,1}.val = zeros( srl.read {i0,1}.n.bytes, 1 ); % [varies]
end

srl.read {1 ,1}.Val = zeros( srl.read {1 ,1}.n.Bytes, 1 ); % [varies]

%% End










