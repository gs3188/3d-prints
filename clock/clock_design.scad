
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

// Function to create flowing topographic contours
module flowing_contour(center_x, center_y, base_r, num_lines, line_width, height_start) {
    for(i=[0:num_lines-1]) {
        radius = base_r + i * 3;
        height = height_start + i * 0.3;
        
        translate([center_x, center_y, 0])
            linear_extrude(height=height)
                difference() {
                    polygon([
                        for(a=[0:5:360]) 
                            let(angle=a,
                                wave1=2 * sin(a * 2 + i * 30),
                                wave2=1.5 * cos(a * 3 + i * 20))
                            [(radius + line_width/2 + wave1 + wave2) * cos(angle), 
                             (radius + line_width/2 + wave1 + wave2) * sin(angle)]
                    ]);
                    polygon([
                        for(a=[0:5:360]) 
                            let(angle=a,
                                wave1=2 * sin(a * 2 + i * 30),
                                wave2=1.5 * cos(a * 3 + i * 20))
                            [(radius - line_width/2 + wave1 + wave2) * cos(angle), 
                             (radius - line_width/2 + wave1 + wave2) * sin(angle)]
                    ]);
                }
    }
}

module topography_disc(r=80, thickness=4, center_hole_d=3){
    difference() {
        union() {
            // Base disc
            cylinder(r=r, h=thickness);
            
            // Top-left terrain cluster (around 10-11 o'clock)
            flowing_contour(-25, 35, 8, 8, 1.2, thickness + 0.3);
            
            // Top-right terrain cluster (around 1-2 o'clock)
            flowing_contour(30, 30, 10, 7, 1.2, thickness + 0.3);
            
            // Bottom-left terrain cluster (around 7-8 o'clock)
            flowing_contour(-30, -25, 9, 6, 1.2, thickness + 0.3);
            
            // Bottom-right terrain cluster (around 4-5 o'clock)
            flowing_contour(28, -30, 11, 7, 1.2, thickness + 0.3);
            
            // Center cluster
            flowing_contour(0, 0, 6, 5, 1.2, thickness + 0.2);
            
            // Additional smaller clusters for variety
            flowing_contour(45, 0, 7, 4, 1.0, thickness + 0.2);
            flowing_contour(-40, 0, 6, 4, 1.0, thickness + 0.2);
            flowing_contour(0, 45, 5, 3, 1.0, thickness + 0.2);
            flowing_contour(0, -40, 6, 3, 1.0, thickness + 0.2);
        }
        
        // Center hole for clock mechanism
        translate([0, 0, -1])
            cylinder(d=center_hole_d, h=thickness + 10);
        
        // Keep within disc bounds
        translate([0, 0, -1])
            difference() {
                cylinder(r=r + 10, h=thickness + 10);
                cylinder(r=r, h=thickness + 10);
            }
    }
}

module hour_markers(r=80){
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

module housing(r=85, depth=20, clockwork_slot_size=55, rim_width=5, disc_recess_depth=5){
    difference(){
        // Main body
        cylinder(r=r, h=depth);
        
        // Front recess for disc (shallow circular pocket)
        translate([0, 0, depth - disc_recess_depth])
            cylinder(r=r - rim_width, h=disc_recess_depth + 1);
        
        // Center hole for clock shaft
        translate([0, 0, -1])
            cylinder(d=10, h=depth + 2);
        
        // Square slot for clock mechanism on the back (5.5cm x 5.5cm)
        translate([-clockwork_slot_size/2, -clockwork_slot_size/2, -1])
            cube([clockwork_slot_size, clockwork_slot_size, depth - disc_recess_depth - 2]);
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
    
} else if (render_mode == 6) {
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
