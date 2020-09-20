%% [global]                                                                
clearvars
close all

%%

set(groot,'defaultFigurePaperPositionMode', 'manual'  );
set(groot,'defaultFigurePaperPosition',    [0 0 20 20]);
set(groot,'defaultFigurePaperSize',        [    20 20]);

set(groot,'defaultAxesFontSize',                   10 );
set(groot,'defaultAxesFontSize',                   24 );

%% [init]                                                                  

load('scope_figure8.mat')

file.dir = '0. Output/';

p = 0;

log.err = {};

%% [theta]                                                                 

p = p+1;
figure(p)

subplot(2,1,1)
plot( p_theta_cae.time, p_theta_cae.signals(1,1).values)
hold on
plot( p_theta_cae.time, p_theta_cae.signals(1,2).values)
plot( p_theta_cae.time, p_theta_cae.signals(1,3).values)
hold off

title ('wheel.angularPosition.global (theta) [rad]')
xlabel('Time [s]')

legend({ 'Command'                ...
       , 'Actual'                 ...
       , 'Error'                  ...
       }                          ...
       , 'Location',  'NorthEast' ...
       )

grid minor



subplot(2,1,2)

plot( p_theta_cae.time, p_theta_cae.signals(1,3).values)

legend({ 'Error'                  ...
       }                          ...
       , 'Location',  'NorthEast' ...
       )

grid minor

xlabel('Time [s]')

e.theta.max = max( abs( p_theta_cae.signals(1,3).values ) );

file.name = 'theta';
print([file.dir file.name '.pdf'], '-dpdf')

[sys.err, sys.txt] =                                              ...
 system(['pdfcrop --hires '                                       ...
         '--verbose '                                             ...
         '"' file.dir file.name '.pdf' '"'                        ...
         ' '                                                      ...
         '"' file.dir file.name '.pdf' '"'                        ...
       ]);

if sys.err ~= 0
  log.err = [log.err; {0, sys.err, sys.txt}];
end

%% [phi.y]                                                                 

p = p+1;
figure(p)

subplot(2,1,1)
plot( p_phi_y_cae.time, p_phi_y_cae.signals(1,1).values)
hold on
plot( p_phi_y_cae.time, p_phi_y_cae.signals(1,2).values)
plot( p_phi_y_cae.time, p_phi_y_cae.signals(1,3).values)
hold off

title ('body.angularPosition.y (phi.y) [rad]')
xlabel('Time [s]')

legend({ 'Command'                ...
       , 'Actual'                 ...
       , 'Error'                  ...
       }                          ...
       , 'Location',  'NorthEast' ...
       )

grid minor



subplot(2,1,2)

plot( p_phi_y_cae.time, p_phi_y_cae.signals(1,3).values)

legend({ 'Error'                  ...
       }                          ...
       , 'Location',  'NorthEast' ...
       )

grid minor

xlabel('Time [s]')

e.phi_y.max = max( abs( p_phi_y_cae.signals(1,3).values ) );

file.name = 'phi-y';
print([file.dir file.name '.pdf'], '-dpdf')

[sys.err, sys.txt] =                                              ...
 system(['pdfcrop --hires '                                       ...
         '--verbose '                                             ...
         '"' file.dir file.name '.pdf' '"'                        ...
         ' '                                                      ...
         '"' file.dir file.name '.pdf' '"'                        ...
       ]);

if sys.err ~= 0
  log.err = [log.err; {0, sys.err, sys.txt}];
end

%% [phi.x]                                                                 

p = p+1;
figure(p)

subplot(1,1,1)
plot( p_pitch.time, p_pitch.signals(1,1).values)

title ('body.angularPosition.x (phi.x) [rad]')
xlabel('Time [s]')

legend({ 'Actual'                 ...
       }                          ...
       , 'Location',  'NorthEast' ...
       )

grid minor

file.name = 'phi-x';
print([file.dir file.name '.pdf'], '-dpdf')

[sys.err, sys.txt] =                                              ...
 system(['pdfcrop --hires '                                       ...
         '--verbose '                                             ...
         '"' file.dir file.name '.pdf' '"'                        ...
         ' '                                                      ...
         '"' file.dir file.name '.pdf' '"'                        ...
       ]);

if sys.err ~= 0
  log.err = [log.err; {0, sys.err, sys.txt}];
end

%% [p.x]                                                                   

p = p+1;
figure(p)

subplot(2,1,1)
plot( p_p_xy_cae.time, p_p_xy_cae.signals(1,1).values)
hold on
plot( p_p_xy_cae.time, p_p_xy_cae.signals(1,2).values)
plot( p_p_xy_cae.time, p_p_xy_cae.signals(1,3).values)
hold off

title ('wheel.linearPosition.x (p.x) [m]')
xlabel('Time [s]')

legend({ 'Command'                ...
       , 'Actual'                 ...
       , 'Error'                  ...
       }                          ...
       , 'Location',  'NorthEast' ...
       )

grid minor



subplot(2,1,2)

plot( p_p_xy_cae.time, p_p_xy_cae.signals(1,3).values)

legend({ 'Error'                  ...
       }                          ...
       , 'Location',  'NorthEast' ...
       )

grid minor

xlabel('Time [s]')

e.p_x.max = max( abs( p_p_xy_cae.signals(1,3).values ) );

file.name = 'p-x';
print([file.dir file.name '.pdf'], '-dpdf')

[sys.err, sys.txt] =                                              ...
 system(['pdfcrop --hires '                                       ...
         '--verbose '                                             ...
         '"' file.dir file.name '.pdf' '"'                        ...
         ' '                                                      ...
         '"' file.dir file.name '.pdf' '"'                        ...
       ]);

if sys.err ~= 0
  log.err = [log.err; {0, sys.err, sys.txt}];
end

%% [p.y]                                                                   

p = p+1;
figure(p)

subplot(2,1,1)
plot( p_p_xy_cae.time, p_p_xy_cae.signals(1,4).values)
hold on
plot( p_p_xy_cae.time, p_p_xy_cae.signals(1,5).values)
plot( p_p_xy_cae.time, p_p_xy_cae.signals(1,6).values)
hold off

title ('wheel.linearPosition.y (p.y) [m]')
xlabel('Time [s]')

grid minor

legend({ 'Command'                ...
       , 'Actual'                 ...
       , 'Error'                  ...
       }                          ...
       , 'Location',  'NorthEast' ...
       )



subplot(2,1,2)

plot( p_p_xy_cae.time, p_p_xy_cae.signals(1,3).values)

legend({ 'Error'                  ...
       }                          ...
       , 'Location',  'NorthEast' ...
       )

grid minor

xlabel('Time [s]')

e.p_y.max = max( abs( p_p_xy_cae.signals(1,6).values ) );

file.name = 'p-y';
print([file.dir file.name '.pdf'], '-dpdf')

[sys.err, sys.txt] =                                              ...
 system(['pdfcrop --hires '                                       ...
         '--verbose '                                             ...
         '"' file.dir file.name '.pdf' '"'                        ...
         ' '                                                      ...
         '"' file.dir file.name '.pdf' '"'                        ...
       ]);

if sys.err ~= 0
  log.err = [log.err; {0, sys.err, sys.txt}];
end

%% [p.xy]                                                                  

p = p+1;
figure(p)

subplot(1,1,1)
plot( p_p_xy_cae.signals(1,1).values, p_p_xy_cae.signals(1,4).values)
hold on
plot( p_p_xy_cae.signals(1,2).values, p_p_xy_cae.signals(1,5).values)
hold off

title ('wheel.linearPosition.xy (p.xy) [m]')
xlabel('Distance (x) [m]')
ylabel('Distance (y) [m]')


legend({ 'Command'                ...
       , 'Actual'                 ...
       }                          ...
       , 'Location',  'NorthEast' ...
       )

grid minor

axis square

e.p_xy.max = max( abs( [e.p_x.max e.p_y.max] ) );

file.name = 'p-xy';
print([file.dir file.name '.pdf'], '-dpdf')

[sys.err, sys.txt] =                                              ...
 system(['pdfcrop --hires '                                       ...
         '--verbose '                                             ...
         '"' file.dir file.name '.pdf' '"'                        ...
         ' '                                                      ...
         '"' file.dir file.name '.pdf' '"'                        ...
       ]);

if sys.err ~= 0
  log.err = [log.err; {0, sys.err, sys.txt}];
end

%% [v.lr]                                                                   

p = p+1;
figure(p)

subplot(1,1,1)
plot( p_v_motorDriver_lm.time, p_v_motorDriver_lm.signals(1,1).values)
hold on
plot( p_v_motorDriver_lm.time, p_v_motorDriver_lm.signals(1,2).values)
hold off

title ('v.motorDriver (p.x) [V]')
xlabel('Time [s]')

legend({ 'Motor: Left-Connected'  ...
       , 'Motor: Right-Connected' ...
       }                          ...
       , 'Location',  'NorthEast' ...
       )

grid minor



file.name = 'v-lm';
print([file.dir file.name '.pdf'], '-dpdf')

[sys.err, sys.txt] =                                              ...
 system(['pdfcrop --hires '                                       ...
         '--verbose '                                             ...
         '"' file.dir file.name '.pdf' '"'                        ...
         ' '                                                      ...
         '"' file.dir file.name '.pdf' '"'                        ...
       ]);

if sys.err ~= 0
  log.err = [log.err; {0, sys.err, sys.txt}];
end

%% [End]










