%% [Process]: Open, read/write, and close serial port object.                    

% open serial channel
fopen ( srl.srl );

disp( 'Performing serial read:' )

% initialize complete read cycle timers
srl.t.start = clock;
srl.T.all   = tic;

for i0 = 1 : srl.n.transmits
srl.           T.one = tic;


% write
% srl.write{1,1}.T.one = tic;


% read
srl.read{1,1}.T.one = tic;


% perform read of one time sample:
srl.read{1,1}.Val = fread( srl.srl               ... serial object
                         , srl.read{1,1}.n.Bytes ... read size        [bytes/read]
                         , srl.type.in           ... input data class [default: 'uint8']
                         );

if isempty( srl.read{1,1}.Val ) % occasionally isempty on startup.    [seek better fix.]
srl.read{1,1}.Val = NaN * zeros( srl.read {1 ,1}.n.Bytes, 1 );
end

% append to vector of all reads:
srl.reads{1,1}.Val( ( 1:srl.read{1,1}.n.Bytes ) + (i0-1)*srl.read{1,1}.n.Bytes, 1) = ...
srl.read {1,1}.Val;


% wait for end of time sample:
if i0 ~= srl.n.transmits                % if not the last sample
  while toc( srl.T.one ) < srl.T.sample % then loop to wait until
  end                                   % a complete sample period
end                                     % has passed before reading 
                                        % again.

end

srl.T.all  = toc( srl.T.all );
srl.t.stop = clock;

disp(['Intended total transmit time: ' num2str( srl.n.transmits * srl.T.sample, '%010.6f' ) ]);
disp(['Actual   total transmit time: ' num2str( srl.T.all                     , '%010.6f' ) ]);
disp( 'Serial read complete.' )
disp( ' ' )


fclose( srl.srl );


% convert output to intended data type:
srl.read {1,1}.Val = cast( srl.read {1,1}.Val, srl.type.out );
srl.reads{1,1}.Val = cast( srl.reads{1,1}.Val, srl.type.out );
% note: Mathworks forces conversion to 'double' for serial read output.

%% End










