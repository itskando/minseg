clearvars
clc

% Get a list of all files and folders in this folder.
data = strsplit(genpath('.'),':').';

% Print folder names to command window.
for i0 = 1 : size(data, 1)
	fprintf('             {\\main/Figures/%s/}\n', data{i0}(3:end));
end