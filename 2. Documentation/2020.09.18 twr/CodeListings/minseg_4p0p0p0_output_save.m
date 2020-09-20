%% [Output]: Save all data                                      

file.label = [datestr(now, 'yyyy.mm.dd HH.MM') ' minseg'];

if ~isempty(ui.save.label)
file.label = [ file.label ' ' ui.save.label ];
end

disp( 'Performing export to .mat file.' )

save( [root.data.dir file.label '.mat' ] )

disp( 'Export to .mat file complete.'   )
disp( ' '                               )

%% End










