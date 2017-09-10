%% [Init   ]: Plant: Motor                                                 
plant.mtr.mode = 0; % [default: 0]
% 0: philohome / yamamoto / peltier
% 1: howard

switch plant.mtr.mode

case 0 % philohome / yamamoto / peltier
plant.mtr.R                =  6.690; %  resistance            [ohm       ]
plant.mtr.k.dlambda        =  0.468; %  back EMF constant     [V*s / rad ]
plant.mtr.k.torque         =  0.317; %  torque   constant     [N*m / A   ]

case 1 % howard
plant.mtr.R                =  4.400; %  resistance            [ohm       ]
plant.mtr.k.dlambda        =  0.495; %  back EMF constant     [V*s / rad ]
plant.mtr.k.torque         =  0.470; %  torque   constant     [N*m / A   ]

end

%% [Init   ]: Plant: Motor: Transfer function                              

% transfer function = output/input = angularVelocity/v.input

% measured when: 
%  body is upright AND 
%  both wheels are at equivalent speed, in a common direction

switch plant.pSupply.battery.n
case 6; plant.mtr.k.v2w    =  3/3.35; % transfer function    [rad / (s*V)] [source: measured]
end

%% [Init   ]: Plant: Motor: Coefficient of friction                              

plant.mtr.k.friction =  plant.mtr.k.torque * (1 - plant.mtr.k.dlambda * plant.mtr.k.v2w) ...
                     / (plant.mtr.R * plant.mtr.k.v2w); 
                                      % friction coefficient [ - ]

%% End










