%% [Init   ]: Plant: Hardware: Accelerometer                               
plant.accel.afs_sel.mode   = 0;  % [ Required: 0 ]
% | # | maxValue [g] | Sensitivity [LSB/mg] |
% | 0 | +/- 02       | 8192
% | 1 | +/- 04       | 4096
% | 2 | +/- 08       | 2048
% | 3 | +/- 16       | 1024

assert( plant.accel.afs_sel.mode == 0 );

switch  plant.accel.afs_sel.mode
case 0; plant.accel.maxVal = 02 * a.gravity;
case 1; plant.accel.maxVal = 04 * a.gravity;
case 2; plant.accel.maxVal = 08 * a.gravity;
case 3; plant.accel.maxVal = 16 * a.gravity;
end

plant.accel.k_digital2analog = plant.accel.maxVal / k.intmax.int16;

%% End










