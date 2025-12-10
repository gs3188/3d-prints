
// Simple parametric clock inspired by user image
$fn=100;

// -------------------------
// RENDER MODE SELECTION
// -------------------------
// Change this value to render different parts:
// 0 = Full assembly preview (all parts together)
// 1 = Housing only (for 3D printing)
// 2 = Topography disc only (for 3D printing)
// 3 = Hour markers only (for 3D printing)
// 4 = Hands only (for 3D printing)
// 5 = Base only (for 3D printing)
// 6 = Exploded view (all parts separated)
render_mode = 1;

// Function to create milky way pattern - stars and flowing clouds
module milky_way_pattern(r, depth) {
    // Random seed for consistent pattern
    function random(seed) = fract(sin(seed * 12.9898 + 78.233) * 43758.5453);
    function fract(x) = x - floor(x);
    
    // Stars - small dots scattered across the disc
    for(i=[0:300]) {
        rand_r = random(i * 7.123) * r * 0.85;
        rand_angle = random(i * 3.456) * 360;
        star_size = 0.5 + random(i * 9.876) * 1.2;
        
        x = rand_r * cos(rand_angle);
        y = rand_r * sin(rand_angle);
        
        translate([x, y, -0.5])
            cylinder(r=star_size, h=depth + 1, $fn=8);
    }
    
    // Milky way band - flowing organic cloud structures across the disc
    for(i=[0:120]) {
        t = i / 120;
        
        // Create flowing path across disc
        path_x = (t - 0.5) * r * 1.8 + 15 * sin(t * 360 * 2);
        path_y = 10 * sin(t * 360 * 3) + 8 * cos(t * 360 * 5);
        
        // Variable density - more clouds in center of band
        density = sin(t * 180) * sin(t * 180);
        
        if(random(i * 234.567) < density) {
            cloud_size = 2 + random(i * 8.901) * 5;
            scatter_x = (random(i * 4.567) - 0.5) * 20;
            scatter_y = (random(i * 7.890) - 0.5) * 25;
            
            translate([path_x + scatter_x, path_y + scatter_y, -0.5])
                cylinder(r=cloud_size, h=depth + 1, $fn=8);
        }
    }
    
    // Additional wispy tendrils
    for(k=[0:30]) {
        tendril_angle = random(k * 15.678) * 360;
        tendril_dist = 20 + random(k * 23.456) * 40;
        tendril_size = 1.5 + random(k * 34.567) * 2.5;
        
        tendril_x = tendril_dist * cos(tendril_angle) + (random(k * 45.678) - 0.5) * 15;
        tendril_y = tendril_dist * sin(tendril_angle) + (random(k * 56.789) - 0.5) * 15;
        
        translate([tendril_x, tendril_y, -0.5])
            cylinder(r=tendril_size, h=depth + 1, $fn=6);
    }
}

module topography_disc(r=120, thickness=4, center_hole_d=3){
    difference() {
        union() {
            // Base disc
            cylinder(r=r, h=thickness);
            
            // Milky way pattern as protrusions on the surface
            translate([0, 0, thickness])
                milky_way_pattern(r, 0.4);
        }
        
        // Center hole for clock mechanism
        translate([0, 0, -1])
            cylinder(d=center_hole_d, h=thickness + 10);
        
        // Holes for housing protrusions at 12, 3, 6, 9 o'clock
        for(angle=[0, 90, 180, 270]) {
            rotate([0, 0, angle])
                translate([r - 5 - 10, 0, -1])
                    linear_extrude(height=thickness + 2)
                        offset(r=4.5)
                            offset(delta=-4.5)
                                translate([-5, -8])
                                    square([10, 16]);
        }
        
        // Keep within disc bounds
        translate([0, 0, -1])
            difference() {
                cylinder(r=r + 10, h=thickness + 10);
                cylinder(r=r, h=thickness + 10);
            }
    }
}

module hour_markers(r=120){
    for(angle=[0,90,180,270]){
        rotate([0,0,angle])
            translate([r-10,0,2])
                cube([20,6,4], center=true);
    }
}

module hands(){
    // simplified hands
    color("gray") translate([0,0,5])
        cube([60,6,2], center=true); // minute
    color("gray") translate([0,0,4])
        cube([40,6,2], center=true); // hour
}


module housing(r=125, depth=20, clockwork_slot_size=55, rim_width=5, disc_recess_depth=5, slot_corner_radius=2, sleeve_wall=3, slot_clearance=0.5){
    difference(){
        union() {
            // Main body
            cylinder(r=r, h=depth);
            
            // Enclosed sleeve for clock mechanism (protruding inward)
            translate([0, 0, -1])
                linear_extrude(height=depth - disc_recess_depth - 2)
                    offset(r=slot_corner_radius + sleeve_wall)
                        offset(delta=-(slot_corner_radius + sleeve_wall))
                            translate([-(clockwork_slot_size + 2*slot_clearance)/2 - sleeve_wall, -(clockwork_slot_size + 2*slot_clearance)/2 - sleeve_wall])
                                square([clockwork_slot_size + 2*slot_clearance + 2*sleeve_wall, clockwork_slot_size + 2*slot_clearance + 2*sleeve_wall]);
            
            // 4 rectangular protrusions with rounded edges at 12, 3, 6, 9 o'clock in disc recess
            for(angle=[0, 90, 180, 270]) {
                rotate([0, 0, angle])
                    translate([r - rim_width - 10, 0, depth - disc_recess_depth])
                        linear_extrude(height=disc_recess_depth)
                            offset(r=4)
                                offset(delta=-4)
                                    translate([-5, -8])
                                        square([10, 16]);
            }
        }
        
        // Front recess for disc (shallow circular pocket) - subtract protrusions to keep them
        difference() {
            translate([0, 0, depth - disc_recess_depth])
                cylinder(r=r - rim_width, h=disc_recess_depth + 1);
            
            // Subtract the protrusions from the recess so they remain
            for(angle=[0, 90, 180, 270]) {
                rotate([0, 0, angle])
                    translate([r - rim_width - 10, 0, depth - disc_recess_depth - 0.5])
                        linear_extrude(height=disc_recess_depth + 1)
                            offset(r=3)
                                offset(delta=-4)
                                    translate([-5, -8])
                                        square([10, 16]);
            }
        }
        
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


module base(w=160,d=40,h=10){
    cube([w,d,h], center=true);
}

module clock(){
    housing();
    translate([0,0,0])
        topography_disc();
    hour_markers();
    hands();
    translate([0, -50, -5])
        base();
}

// -------------------------
// Render Selection
// -------------------------
if (render_mode == 0) {
    // Mode 0: Full assembly preview
    clock();
    
} else if (render_mode == 1) {
    // Mode 1: Housing only
    housing();
    
} else if (render_mode == 2) {
    // Mode 2: Topography disc only
    topography_disc();
    
} else if (render_mode == 3) {
    // Mode 3: Hour markers only (all 4 combined)
    hour_markers();
    
} else if (render_mode == 4) {
    // Mode 4: Hands only (both minute and hour)
    hands();
    
} else if (render_mode == 5) {
    // Mode 5: Base only
    base();
    
    
}

else if (render_mode == 6) {
    // Mode 6: Exploded view
    translate([0, 0, 40])
        housing();
    translate([0, 0, 30])
        topography_disc();
    translate([0, 0, 20])
        hour_markers();
    translate([0, 0, 10])
        hands();
    translate([0, -50, 0])
        base();
}
