%% [Init   ]: Plant: Hardware: Gyroscope                                   

plant.gyro.dlpf.mode   = 0;  % [ default: 0 ]
% | # | maxValue [deg/s] | bandwidth [Hz] | delay [s] | 
% | 0 | +/- 0250         | 256            | 00.98     | 
% | 1 | +/- 0500         | 188            | 01.90     | 
% | 2 | +/- 1000         | 098            | 02.80     | 
% | 3 | +/- 2000         | 042            | 04.80     | 
% | 4 | +/- ????         | 020            | 08.30     | 
% | 5 | +/- ????         | 010            | 13.40     | 
% | 6 | +/- ????         | 005            | 18.60     | 

switch plant.gyro.dlpf.mode
case 0; plant.gyro.maxVal = 0250 * k_deg2rad;
case 1; plant.gyro.maxVal = 0500 * k_deg2rad;
case 2; plant.gyro.maxVal = 1000 * k_deg2rad;
case 3; plant.gyro.maxVal = 2000 * k_deg2rad;
end

plant.gyro.k_digital2analog = plant.gyro.maxVal / k.intmax.int16;

%% [Init   ]: Plant: Hardware: Gyroscope: Bias correction                  

plant.gyro.bias.movingAverage.n.pts = floor( plant.T.init / mdl.T.sample);

% [source: 1. Test Cases/1. Gyro Bias Calibration]
% plant.gyro.x.bias      = -266.0779700;
% plant.gyro.y.bias      = -135.5037500;
% plant.gyro.z.bias      = -034.3493271;

%% [Init   ]: Plant: Hardware: Gyroscope: Derivative low-pass filter       
plant.gyro.filter.order    = 2;                  % [-] [integer] [ 0: disabled ]
plant.gyro.filter.T.settle = mdl.T.sample * 2.5; % [s]

% note       : cutoff becomes significant at f.cutoff, but still exists before f.cutoff.
% recommended: f.cutoff = f.cutoffDesired * 2.0;
% or         : T.settle = T.settleDesired * 0.5;

plant.gyro.filter.mode     = 0; % [default: 1]
% 0: bessel      [vaccaro]
% 1: bessel      [matlab ]
% 2: butterworth [matlab ]

switch plant.gyro.filter.order

case 0    % disabled
plant.gyro.filter.z.num = 1;
plant.gyro.filter.z.den = 1;

otherwise % enabled
[ plant.gyro.filter          ... structure of filter information
] = lpfPlus                  ...
( plant.gyro.filter.order    ... n_order
, mdl.              T.sample ... T_sample
, plant.gyro.filter.T.settle ... T_settle
, plant.gyro.filter.mode     ... x_mode
);

end
%% End










