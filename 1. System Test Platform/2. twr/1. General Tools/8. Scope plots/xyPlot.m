set(groot,'defaultFigurePaperPositionMode', 'manual'  );
set(groot,'defaultFigurePaperPosition',    [0 0 20 20]);
set(groot,'defaultFigurePaperSize',        [    20 20]);

set(groot,'defaultAxesFontSize',                   10 );
set(groot,'defaultAxesFontSize',                   24 );

%% [p.xy]                                                                  

figure

subplot(1,1,1)
plot( p_p_xy_cae.signals(1,1).values(:,1), p_p_xy_cae.signals(1,2).values(:,1))
hold on
plot( p_p_xy_cae.signals(1,1).values(:,2), p_p_xy_cae.signals(1,2).values(:,2))
hold off

title ('wheel.linearPosition.xy (p.xy)')
xlabel('Distance (x) [m]')
ylabel('Distance (y) [m]')


legend({ 'Command'                ...
       , 'Actual'                 ...
       }                          ...
       , 'Location',  'NorthEast' ...
       )

grid minor

axis square

e.p_x.max = max( abs( p_p_xy_cae.signals(1,1).values(:,3) ) );
e.p_y.max = max( abs( p_p_xy_cae.signals(1,2).values(:,3) ) );
e.p_xy.max = max( abs( [e.p_x.max e.p_y.max] ) );

disp(['Maximum error: ' num2str(e.p_xy.max,'%05.4f') ' [m]'])
%% [End]










