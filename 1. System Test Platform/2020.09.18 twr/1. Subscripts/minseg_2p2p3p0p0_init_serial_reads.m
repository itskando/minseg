%% [Init   ]: Initialize serial reads variable                             

srl.reads{ srl.read{1,1}.n.signals, 1 } = [];


%% [Init   ]: Define serial reads parameters                               

% number of bytes/bits captured after all reads have been performed:
for i0 = 1 : srl.read{1,1}.n.signals
srl.reads{i0,1}.n.bytes = srl.read{i0,1}.n.bytes * srl.n.transmits; % [bytes]
srl.reads{i0,1}.n.bits  = srl.read{i0,1}.n.bits  * srl.n.transmits; % [bits ]
end      

srl.reads{1 ,1}.n.Bytes = srl.read{1 ,1}.n.Bytes * srl.n.transmits; % [bytes]
srl.reads{1 ,1}.n.Bits  = srl.read{1 ,1}.n.Bits  * srl.n.transmits; % [bits ]

%% [Init   ]: Initialize serial reads value vectors                     

for i0 = 1 : srl.read{1,1}.n.signals
srl.reads{i0,1}.val = zeros( srl.reads{i0,1}.n.bytes, 1 ); % [varies]
end      

srl.reads{1 ,1}.Val = zeros( srl.reads{1 ,1}.n.Bytes, 1 ); % [varies]

%% End










