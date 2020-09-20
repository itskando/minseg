%% [Process]: Format serial port data                                      

% Index of first byte of each read
srl.reads{1,1}.z.byte1 = ( 0:srl.n.transmits-1 ).' * srl.read{1,1}.n.Bytes + 1;

srl.read {1,1}.i.byte0 = 0; % initialize byte offset
for i0 = 1 : srl.read{1,1}.n.signals

  % Start index of signal i0 at each sample
  srl.reads{i0,1}.z.byte0   = srl.reads{1,1}.z.byte1 + srl.read{1,1}.i.byte0;

  % Include additional indices for multibyte signals
  if srl.read {i0,1}.n.bytes > 1
     srl.reads{i0,1}.z.byte0 = bsxfun( @plus                      ...
                                    ,   srl.reads{i0,1}.z.byte0   ...
                                    , 0:srl.read {i0,1}.n.bytes-1 ...
                                    );
  end

  % Pull corresponding values
  if strcmp( srl.read{i0,1}.type.original, srl.type.out )
       % If intended signal datatype is     equal to serial output, 
       % then use it immediately:
    srl.reads{i0,1}.val  = srl.reads{1,1}.Val( srl.reads{i0,1}.z.byte0 );
    
  else % If intended signal datatype is not equal to serial output, 
       % then first convert the serial output:
    srl.reads{i0,1}.val0 = srl.reads{1,1}.Val( srl.reads{i0,1}.z.byte0 );
    
    % Convert to cell:
    srl.reads{i0,1}.val  = mat2cell(             srl.reads{i0,1}.val0          ...
                                   , ones( size( srl.reads{i0,1}.val0, 1 ), 1) ...
                                   ,       size( srl.reads{i0,1}.val0, 2 )     ...
                                   );
    % Typecast each row vector to correct type:
    srl.reads{i0,1}.fun  = @(x) typecast( x, srl.read{i0,1}.type.original );
    srl.reads{i0,1}.val  = cellfun ( srl.reads{i0,1}.fun                       ...
                                   , srl.reads{i0,1}.val                       ...
                                   );
    % Convert back to matrix: [unnecessary - cellfun converts to matrix already]
    % srl.read{i0,1}.val  = cell2mat( srl.read{i0,1}.val );
  
    % Determine maximum and minumum values (axis information in plots)
    srl.reads{i0,1}.val_min    = min( srl.reads{i0,1}.val );
    srl.reads{i0,1}.val_max    = max( srl.reads{i0,1}.val );
    srl.reads{i0,1}.val_absMax = max( abs( [ srl.reads{i0,1}.val_min 
                                             srl.reads{i0,1}.val_max ] ) );
  end
  
  

  % Increment byte offset
  srl.read{1,1}.i.byte0 = srl.read{1,1}.i.byte0 + srl.read{i0,1}.n.bytes;

end

%% End










