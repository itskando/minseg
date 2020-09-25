%% [Init   ]: Plant: Motor: Gearing (with respect to teeth)                
plant.mtr.n.gearTeeth.map      = { 20 13 10 [] [] [] [] [] 
                                   [] [] 20 10 [] [] [] []
                                   [] [] [] 27 09 [] [] []
                                   [] [] [] [] 40 30 10 32}; % [n.teeth/gear]
%{
legend:
plant.mtr.n.gearTeeth.map{1,1} = wheel   shaft
plant.mtr.n.gearTeeth.map{1,2} = gearbox
 ...
plant.mtr.n.gearTeeth.map{4,6} = gearbox
plant.mtr.n.gearTeeth.map{4,7} = motor   shaft
plant.mtr.n.gearTeeth.map{4,8} = encoder shaft

note: gear teeth counts sharing the same column represent 
        gears which are coupled 1:1.
%}
plant.mtr.k.gearTeeth.wheel2motor                                          ...
  = plant.mtr.n.gearTeeth.map{1,2} / plant.mtr.n.gearTeeth.map{1,1}        ...
  * plant.mtr.n.gearTeeth.map{1,3} / plant.mtr.n.gearTeeth.map{1,2}        ...
                                                                           ...
  * plant.mtr.n.gearTeeth.map{2,4} / plant.mtr.n.gearTeeth.map{2,3}        ...
                                                                           ...
  * plant.mtr.n.gearTeeth.map{3,5} / plant.mtr.n.gearTeeth.map{3,4}        ...
                                                                           ...
  * plant.mtr.n.gearTeeth.map{4,6} / plant.mtr.n.gearTeeth.map{4,5}        ...
  * plant.mtr.n.gearTeeth.map{4,7} / plant.mtr.n.gearTeeth.map{4,6};

plant.mtr.k.gearTeeth.motor2encoder                                        ...
  = plant.mtr.n.gearTeeth.map{4,8} / plant.mtr.n.gearTeeth.map{4,7};

plant.mtr.k.gearTeeth.wheel2encoder                                        ...
  = plant.mtr.k.gearTeeth.wheel2motor                                      ...
  * plant.mtr.k.gearTeeth.motor2encoder;

%% [Init   ]: Plant: Motor: Gearing (with respect to angular motion)       
plant.mtr.k.rev.wheel2motor   = 1 / plant.mtr.k.gearTeeth.wheel2motor;
plant.mtr.k.rev.motor2encoder = 1 / plant.mtr.k.gearTeeth.motor2encoder;
plant.mtr.k.rev.wheel2encoder = plant.mtr.k.rev.wheel2motor                ...
                              * plant.mtr.k.rev.motor2encoder;

%% [Init   ]: Plant: Motor: Encoder                                        
plant.mtr.encoder.n.slot      = 12;
plant.mtr.encoder.k.rev2slot  = plant.mtr.encoder.n.slot;

switch 04 % [default: 04]
  case 01; plant.mtr.encoder.k.slot2count = 01; % [unary     ] 1 channels count each [slot        ]
  case 02; plant.mtr.encoder.k.slot2count = 02; % [binary    ] 1 channels count each [slot & ~slot]
  case 04; plant.mtr.encoder.k.slot2count = 04; % [quadrature] 2 channels count each [slot & ~slot]
end                                             %              ( channels are 90 deg out of phase )

plant.mtr.encoder.wheelRev2count    ...
  = plant.mtr.k.rev.wheel2encoder   ...
  * plant.mtr.encoder.k.rev2slot    ...
  * plant.mtr.encoder.k.slot2count;
                         
plant.mtr.encoder.count2wheelRev = 1 / plant.mtr.encoder.wheelRev2count;

plant.mtr.encoder.count2wheelRad = plant.mtr.encoder.count2wheelRev * k.Rev2rad; % rad

%% End










