clearvars
load sroots % [source: vaccaro digital control toolbox]

for i0 = 1:10

eval([ 's.pole.bessel{i0,1} = s' num2str(i0,'%d') ';' ]);

end

save('bessel poles.mat', 's')