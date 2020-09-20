%% [Output ]: Plot                                                         

switch srl.read{i0,1}.label

case 'plant.clock'

case 'io.reads.userInput.motorAngularVelocity.command'

case 'plant.encoders.left.angularVelocity'

case 'plant.encoders.middle.angularVelocity'

case 'controller.motorAngularVelocity.left.angularVelocity.error'

case 'controller.motorAngularVelocity.middle.angularVelocity.error'

case 'controller.motorAngularVelocity.left.voltage.command'

case 'controller.motorAngularVelocity.middle.voltage.command'

case 'plant.drivers.left.voltage.command.digital.positive'

case 'plant.drivers.left.voltage.command.digital.negative'

case 'plant.drivers.middle.voltage.command.digital.positive'

case 'plant.drivers.middle.voltage.command.digital.negative'

otherwise 
%error('')

end
%% End










