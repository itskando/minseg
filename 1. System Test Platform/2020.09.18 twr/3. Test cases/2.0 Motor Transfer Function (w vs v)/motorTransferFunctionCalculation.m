%% [Global]:                                                               
clc
clearvars

%% [Input  ]: General

t.start.t = 2; % Data steady-state start time [s]

%% [Init   ]: Load data                                                    

load( '2017.06.15 13.41 minseg gyro bias calibration.mat' );

%% [Init   ]: Provide signal legend                                        

for i0 = 1 : size(srl.read, 1)
disp([ num2str( i0, '%02d' )  ...
      ' '                     ...
       srl.read{i0,1}.label   ...
    ]);
end

disp(' ')

%% [Process]: Determine starting index                                     
[~, t.start.z] = min( srl.read{1,1}.Val - t.start.t);

%% [Process]: Determine average value gyroscope outputs at steady state    
gyro_x_bias = mean( srl.reads{02,01}.val( t.start.z : end, 1 ) )
gyro_y_bias = mean( srl.reads{03,01}.val( t.start.z : end, 1 ) )
gyro_z_bias = mean( srl.reads{04,01}.val( t.start.z : end, 1 ) )

%% End










