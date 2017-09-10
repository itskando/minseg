function mywritevrtrack(varargin)
% MYWRITEVRTRACK   Make VRML map file from bitmap file
% mywritevrtrack('track.bmp')     : Make VRML map. The height of wall is 20 [cm] (default). 
% mywritevrtrack('track.bmp', 10) : Make VRML map. The height of wall is 10 [cm]. 

% check input arguments
switch nargin
    case 1
        bmp_file = varargin{1};
        wall_height_text = '20,';
    case 2
        bmp_file = varargin{1};
        wall_height_text = [num2str(varargin{2}), ','];
    otherwise
        error('Requires 1 or 2 arguments.')
end

% read bitmap file
try
	map = imread(bmp_file);
	map = uint8(map(:, :, 1));
	[rows, cols] = size(map);
	[bmp_path, bmp_name] = fileparts(bmp_file);
	vrml_file = [bmp_name, '.wrl'];
catch
	error(['Failed to read: '  bmp_file]);
end

% constants
NL = sprintf('\n');
TAB = sprintf('\t');

LINE_COLOR = uint8(0);
WALL_COLOR = uint8(128);
FIELD_COLOR = uint8(255);

LINE_COLOR_TEXT  = '0.0 0.0 0.0,';	% black
WALL_COLOR_TEXT  = '0.3 0.3 0.3,';	% gray
FIELD_COLOR_TEXT = '0.7 0.7 0.7,';	% white
FIELD_HEIGHT_TEXT = '0,';

% make VRML elevation grid text
vr_text = [ ...
	'#VRML V2.0 utf8', NL, ...
	'Shape {', NL, ...
	TAB, 'appearance Appearance {', NL, ...
	TAB, TAB, 'material Material {', NL, ...
	TAB, TAB, TAB, 'ambientIntensity 0.2', NL, ...
	TAB, TAB, TAB, 'diffuseColor 0.15 0.15 0.15', NL, ...
	TAB, TAB, TAB, 'emissiveColor 0.15 0.15 0.15', NL, ...
	TAB, TAB, TAB, 'shininess 0.1', NL, ...
	TAB, TAB, TAB, 'specularColor 0.15 0.15 0.15', NL, ...
	TAB, TAB, '}', NL, ...
	TAB, '}', NL, ...
	TAB, 'geometry ElevationGrid {', NL, ...
	TAB, TAB, 'xDimension ', num2str(cols), NL, ...
	TAB, TAB, 'zDimension ', num2str(rows), NL, ...
	TAB, TAB, 'xSpacing 1', NL, ...
	TAB, TAB, 'zSpacing 1', NL, ...
	TAB, TAB, 'creaseAngle 0.8', NL, ...
	];

% height of the elevation grid
vr_text = [vr_text, TAB, TAB, 'height [', NL, TAB, TAB, TAB];
for m = 1:rows
	for n = 1:cols
		if map(m, n) == WALL_COLOR
			vr_text = [vr_text, wall_height_text, ' '];
		else
			vr_text = [vr_text, FIELD_HEIGHT_TEXT, ' '];
		end
	end
	vr_text = [vr_text, NL, TAB, TAB, TAB];
end
vr_text(end) = [];
vr_text = [vr_text, ']', NL];

% color of the elevation grid
vr_text = [vr_text, TAB, TAB, 'color Color {', NL];
vr_text = [vr_text, TAB, TAB, 'color [', NL, TAB, TAB, TAB];
for m = 1:rows
	for n = 1:cols
		switch map(m, n)
			case FIELD_COLOR
				vr_text = [vr_text, FIELD_COLOR_TEXT, ' '];
			case WALL_COLOR
				vr_text = [vr_text, WALL_COLOR_TEXT, ' '];
			case LINE_COLOR
				vr_text = [vr_text, LINE_COLOR_TEXT, ' '];
			otherwise
				error('Unspecified map color')
		end
	end
	vr_text = [vr_text, NL, TAB, TAB, TAB];
end
vr_text(end) = [];
vr_text = [vr_text, ']', NL];
vr_text = [vr_text, TAB, TAB, '}', NL];
vr_text = [vr_text, TAB, '}', NL];
vr_text = [vr_text, '}', NL];

% write VRML file
try
	fid = fopen(vrml_file, 'w');
	fprintf(fid, '%c', vr_text);
	fclose(fid);
catch
	error(['Failed to write: ' vrml_file]);
end
