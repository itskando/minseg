%% Global
clc
clearvars

%% Recursion (to export model and all libraries (if any exist) )
for model_index = 1:1


%% User Input

switch model_index
case 0; model.file = '../../minseg_M2V3_2017a.slx';
case 1; model.file = '../9. Control System Diagrams/controlSystemDiagrams.slx';
end

switch model_index
case 0; ui.export.folder = './Output/minseg';
case 1; ui.export.folder = './Output/controlSystemDiagrams';
end

%% Initialize model
[~, model.name, ~] = fileparts(model.file);

if ~bdIsLoaded(model.name)
load_system(model.file);
end

%% Intialize export directory
export.folder = fullfile(pwd,ui.export.folder);

if ~exist(export.folder, 'dir')
    mkdir(export.folder       )
    pause(2)
end

%% Determine all subsystems and stateflow charts

% Find all subsystems       in the model
subsystem.path.sim = find_system(  model.name                     ...
                                , 'FollowLinks',    'on'          ...
...                             , 'LookUnderMasks', 'all'         ...
                                , 'Variants',       'AllVariants' ...
                                , 'BlockType',      'SubSystem'   ...
                                );

% % Find all stateflow charts in the model (not yet tested)
% rt = sfroot;
% m = rt.find('-isa', 'Simulink.BlockDiagram', '-and', 'Name', ModelName);
% ch = m.find('-isa', 'Stateflow.Chart'                                 );
% ch_path = cell(length(ch),1);
% for i_ch = 1:length(ch)
%     ch_path{i_ch} = ch(i_ch).path;
% end

% % Find where the lists overlap
% ch_indx = ismember(ss,ch_path);

%% Export

% Export root system
print( ['-s' model.name], '-dpdf', fullfile(export.folder, [model.name '.pdf']) );

% Export subsystems
subsystem.path.os  = subsystem.path.sim;

for i0 = 1:size(subsystem.path.sim,1)

  % prohibited characters to nonprohibited characters
    subsystem.path.os{i0,1}( subsystem.path.os{i0,1} == ' '      ) = '-'; % space
    subsystem.path.os{i0,1}( subsystem.path.os{i0,1} == '_'      ) = '-'; % underscore
    subsystem.path.os{i0,1}( subsystem.path.os{i0,1} == '&'      ) = '+'; % ampersand
    subsystem.path.os{i0,1}( subsystem.path.os{i0,1} == ':'      ) = '-'; % colon
    subsystem.path.os{i0,1}( subsystem.path.os{i0,1} == '.'      ) = '-'; % period
    subsystem.path.os{i0,1}( subsystem.path.os{i0,1} == char(10) ) = '-'; % newline

  [ subsystem.dir. os{i0,1} ...
  , subsystem.name.os{i0,1} ...
  , subsystem.ext. os{i0,1} ...
  ] = fileparts             ...
  ( subsystem.path.os{i0,1} ...
  );

    subsystem.name.os{i0,1} = [ subsystem.name.os{i0,1}  subsystem.ext.os{i0,1} ];
    
  if ~exist( fullfile( export.folder, subsystem.dir.os{i0,1} ),'dir' )
      mkdir( fullfile( export.folder, subsystem.dir.os{i0,1} )       );
      pause(2)
  end

  % if(ch_indx(i_sub))
  %   currentdir = pwd;
  %   cd(fullfile(RootFolder,subfolder));
  %   sfprint(ss{i_sub},'pdf');
  %   cd(currentdir);
  % else

  print( ['-s', subsystem.path.sim{i0,1}] ...
       ,  '-dpdf'                   ...
       ,  fullfile(export.folder, subsystem.dir.os{i0,1}, ['snap-' subsystem.name.os{i0,1} '.pdf'] ) ...
       );

  % end

end

%% pdfcrop
log.err = {};

 [sys.err, sys.txt] =                                              ...
  system(['pdfcrop --hires '                                       ...
          '--verbose '                                             ...
          '"' ui.export.folder '/' model.name              '.pdf"' ...
          ' '                                                      ...
          '"' ui.export.folder '/' model.name              '.pdf"' ...
        ]);
      
	if sys.err ~= 0
   log.err = [log.err; {0, sys.err, sys.txt}]
  end

for i0 = 1:size(subsystem.path.sim,1)

 [sys.err, sys.txt] =                                              ...
  system(['pdfcrop --hires '                                       ...
          '--verbose '                                             ...
          '"' ui.export.folder '/' subsystem.dir.os{i0,1} '/' 'snap-' subsystem.name.os{i0,1} '.pdf"' ...
          ' '                                                      ...
          '"' ui.export.folder '/' subsystem.dir.os{i0,1} '/' 'snap-' subsystem.name.os{i0,1} '.pdf"' ...
        ]);

 if sys.err ~= 0
   log.err = [log.err; {i0, sys.err, sys.txt}];
 end
 
end


%% End recursion
end

%% End



























