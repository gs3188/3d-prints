            module test(r=125, depth=20, clockwork_slot_size=55, rim_width=5, disc_recess_depth=5, slot_corner_radius=2, sleeve_wall=3, slot_clearance=0.5)
{
            difference () {
                translate([0, 0, -1])
                linear_extrude(height=depth - disc_recess_depth - 2)
                    offset(r=slot_corner_radius + sleeve_wall)
                        offset(delta=-(slot_corner_radius + sleeve_wall))
                            translate([-(clockwork_slot_size + 2*slot_clearance)/2 - sleeve_wall, -(clockwork_slot_size + 2*slot_clearance)/2 - sleeve_wall])
                                square([clockwork_slot_size + 2*slot_clearance + 2*sleeve_wall, clockwork_slot_size + 2*slot_clearance + 2*sleeve_wall]);
                    // Hollow out the back (but leave sleeve solid)
        translate([0, 0, -1])
            difference() {
                cylinder(r=r - rim_width, h=depth - disc_recess_depth);
                // Keep the sleeve area solid
                linear_extrude(height=depth - disc_recess_depth + 2)
                    offset(r=slot_corner_radius + sleeve_wall + 2)
                        offset(delta=-(slot_corner_radius + sleeve_wall + 2))
                            translate([-(clockwork_slot_size + 2*slot_clearance)/2 - sleeve_wall - 2, -(clockwork_slot_size + 2*slot_clearance)/2 - sleeve_wall - 2])
                                square([clockwork_slot_size + 2*slot_clearance + 2*sleeve_wall + 4, clockwork_slot_size + 2*slot_clearance + 2*sleeve_wall + 4]);
            }
                    // Center hole for clock shaft
        translate([0, 0, -1])
            cylinder(d=10, h=depth + 2);
        
        // Square slot for clock mechanism with rounded edges and clearance
        translate([0, 0, -1])
            linear_extrude(height=depth - disc_recess_depth - 2)
                offset(r=slot_corner_radius)
                    offset(delta=-slot_corner_radius)
                        translate([-(clockwork_slot_size + 2*slot_clearance)/2, -(clockwork_slot_size + 2*slot_clearance)/2])
                            square([clockwork_slot_size + 2*slot_clearance, clockwork_slot_size + 2*slot_clearance]);
            }
            
            }

            test();