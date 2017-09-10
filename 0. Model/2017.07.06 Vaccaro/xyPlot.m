plot( xy.ref_x.Data ...
    , xy.ref_y.Data ...
    , 'b'           ...
    )

hold on

plot( xy.act_x.Data ...
    , xy.act_y.Data ...
    , 'r'           ...
    )

hold off

e.x = max( abs(xy.ref_x.Data - xy.act_x.Data) )
e.y = max( abs(xy.ref_y.Data - xy.act_y.Data) )