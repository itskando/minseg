%% [Init   ]: Plant: Hardware: Motor: Encoder: Pins                        
% not yet implemented
% mask encoder model, then use pins as mask parameters
plant.mtr.encoder.left.  pin.A = 19;
plant.mtr.encoder.left.  pin.B = 18;
plant.mtr.encoder.middle.pin.A = 15;
plant.mtr.encoder.middle.pin.B = 62;

%% [Init   ]: Plant: Hardware: Motor: Encoder: Derivative low-pass filter  
plant.mtr.encoder.filter.order    = 2;                  % [-] [integer] [ 0: disabled ]
plant.mtr.encoder.filter.T.settle = mdl.T.sample * 2.5; % [s]

% note       : cutoff becomes significant at f.cutoff, but still exists before f.cutoff.
% recommended: f.cutoff = f.cutoffDesired * 2.0;
% or         : T.settle = T.settleDesired * 0.5;

plant.mtr.encoder.filter.mode     = 0; % [default: 1]
% 0: bessel      [vaccaro]
% 1: bessel      [matlab ]
% 2: butterworth [matlab ]

switch plant.mtr.encoder.filter.order

case 0    % disabled
plant.mtr.encoder.filter.z.num = 1;
plant.mtr.encoder.filter.z.den = 1;

otherwise % enabled
[ plant.mtr.encoder.filter          ... structure of filter information
] = lpfPlus                         ...
( plant.mtr.encoder.filter.order    ... n_order
, mdl.                     T.sample ... T_sample
, plant.mtr.encoder.filter.T.settle ... T_settle
, plant.mtr.encoder.filter.mode     ... x_mode
);

end

%% End










