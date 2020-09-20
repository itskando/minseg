function flag = iswall(pos, map)
% Check the position is inside a wall area or on the border of it
% Inputs:
%   pos    : position ([z, x]) [cm]
%   map    : wall map
% Outputs:
%   flag   : wall flag

%#eml

iz = ceil(pos(1));
ix = ceil(pos(2));
if pos(1) ~= iz && pos(2) ~= ix		% inside a wall area
	flag = map(iz, ix);
elseif pos(1) == iz					% on the border of a wall area (z = integer)
	if pos(2) ~= ix
		flag = map(iz, ix) || map(iz + 1, ix);
	else							% on the corner of a wall area (x, z = integer)
		flag = map(iz, ix) || map(iz + 1, ix) || map(iz, ix + 1) || map(iz + 1, ix + 1);
	end
else								% on the border of a wall area (x = integer)
	flag = map(iz, ix) || map(iz, ix + 1);
end
