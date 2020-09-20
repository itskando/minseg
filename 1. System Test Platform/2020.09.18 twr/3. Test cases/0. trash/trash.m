%% [Global]:                                                               
clc
%clearvars

%% [Input  ]: General

%% [Init   ]: Load data                                                    

%load( 'a.mat' );

%% [Init   ]: Provide signal legend                                        

for i0 = 1 : size(srl.read, 1)
disp([ num2str( i0, '%02d' )  ...
      ' '                     ...
       srl.read{i0,1}.label   ...
    ]);
end

disp(' ')

%% [Process]: Determine starting index                                     
p = p + 1;
figure(p)

stairs(srl.reads{1,1}.val, srl.reads{06,01}.val, '.-');
hold on
stairs(srl.reads{1,1}.val, srl.reads{11,01}.val/100, '.-');
stairs([0 4], [0 0], 'k-');
hold off

xlabel( 'Time [s]'    ); % all else
legend( {srl.read{06,01}.label,
         srl.read{11,01}.label
        }...
      )

% y-axis limits
if isa(srl.reads{06,1}.val, 'float') % float
  srl.reads{06,1}.ymin = -rndOut(max([srl.reads{06,1}.val_absMax srl.reads{11,1}.val_absMax/100])+eps, 2);
  srl.reads{06,1}.ymax = +rndOut(max([srl.reads{06,1}.val_absMax srl.reads{11,1}.val_absMax/100])+eps, 2);
else                                 % integer
  srl.reads{06,1}.ymin = double( intmin( class(srl.reads{i0,1}.val) ) );
  srl.reads{06,1}.ymax = double( intmax( class(srl.reads{i0,1}.val) ) );
end

ylim([ srl.reads{06,1}.ymin, srl.reads{06,1}.ymax ])

grid minor

%% End










