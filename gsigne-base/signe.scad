// =========================================
// Circular Hue-Signe-style Base (0° tilt)
// LED profile 17 x 9 mm, 1 m tall
// PSU: 85 x 60 x 35 mm
// ESP32: ~60 x 30 mm area
// Two-part: base + lid
// =========================================
//
// Export: 0=preview, 1=base only, 2=lid only
export_mode = 0;

// ---------- MAIN PARAMS ----------
base_diameter = 140;
inner_height  = 100;
wall          = 3;
floor_thick   = 3;
rim_height    = 2;
total_height  = floor_thick + inner_height + rim_height;

// LED profile (upright)
prof_w        = 18.6;
prof_h        = 9;
slot_clear    = 0.3;
slot_depth_base = 15;   // support depth in base
slot_depth_lid  = 18.6;   // support depth in lid
funnel_extra    = 2;    // funnel width at base entry

// PSU dimensions (BTF)
psu_len = 85;
psu_w   = 60;
psu_h   = 35;

// ESP32 keep-clear area
esp_len = 60;
esp_w   = 30;

// Cable exit (right side)
cable_d = 10;
cable_z = 12;

// Lid
lid_thickness = 5;
lid_lip       = 2;

// Vents (back side)
vent_width  = 20;
vent_height = 70;
vent_count  = 5;
vent_spacing = 8;
vent_bottom_z = 10;

// Lid perforations
perf_diameter = 5;      // diameter of each perforation
perf_spacing  = 20;      // spacing between perforations

// Spiral ribs on base walls
rib_width = 2;          // width of each rib
rib_depth = 0.8;        // how far rib protrudes from wall
rib_count = 8;          // number of spiral ribs
rib_turns = 3;          // number of full rotations up the wall

// Screw clamp (optional for lid – can be off if not needed)
use_screws  = false;
screw_d     = 3.2;   // M3 clearance
screw_offset_x = -10; // shift screws slightly toward center
screw_offset_y = 12;  // sideways from slot center



// ---------- DERIVED ----------
/*
  Coordinate convention:
  - Front (where the profile is) = +X
  - Back (vents)                = -X
  - Right side (cable exit)     = +Y
*/
slot_x = (base_diameter/2) - wall - slot_depth_base;
slot_y = -(prof_w +7  + slot_clear)/2;




// =========================================
// BASE – hollow with open top
// =========================================
module base_part() {
    
    difference() {

            // Outer shell
            cylinder(d=base_diameter, h=total_height, $fn=150);


        // Hollow interior (up to rim height)
        translate([0,0,floor_thick])
            cylinder(d = base_diameter - 2*wall,
                     h = inner_height + rim_height,
                     $fn = 150);

        // LED profile slot
        translate([slot_x, slot_y, floor_thick])
            cube([slot_depth_base,
                  prof_w + slot_clear,
                  inner_height + rim_height]);

// BIG vertical vent on right wall
// Size + position can be tuned visually
// Curved vertical vent on right wall
vent_outer_r = base_diameter/2;         // outer wall radius

difference() {
    // carve into outer wall using a tall cylinder
    translate([0, vent_outer_r + 0.01, floor_thick +65 + vent_bottom_z])
    rotate([180,0,0])
        cylinder(
            h = vent_height,
            d = vent_width,
            $fn = 64
        );
}
    }
}

// =========================================
// LID – disc with inner plug that fits base
// =========================================
module lid_part() {

    lid_clearance = 0.2;   // radial clearance for plug fit
    plug_h        = 4;     // how deep plug goes into base

    difference() {
        // Positive geometry: lid disc + plug
        union() {
            // Top disc (same diameter as base)
            cylinder(d = base_diameter,
                     h = lid_thickness,
                     $fn = 150);

            // Inner plug that goes into the hollow base
            translate([0,0,-plug_h])
                cylinder(
                    d = base_diameter - 2*wall - 2*lid_clearance,
                    h = plug_h,
                    $fn = 150
                );
        }


        // LED profile slot through lid
        translate([slot_x-10, slot_y, -plug_h-1])
        rotate([0,0,45])
            cube([slot_depth_lid,
                  prof_w + slot_clear,
                  lid_thickness + plug_h + 2]);
        
        // Lid perforations
        for (x = [-base_diameter/2 : perf_spacing : base_diameter/2]) {
            for (y = [-base_diameter/2 : perf_spacing : base_diameter/2]) {
                // Only create holes within the lid circle
                if (sqrt(x*x + y*y) < (base_diameter/2 - wall - 2)) {
                    translate([x, y, -plug_h - 1])
                        cylinder(d = perf_diameter, h = lid_thickness + plug_h + 2, $fn = 16);
                }
            }
        }            
    }
}

// =========================================
// EXPORT SWITCH
// =========================================
if (export_mode == 0) {
    base_part();
    translate([0,0,total_height + 2]) lid_part();
} else if (export_mode == 1) {
    base_part();
} else if (export_mode == 2) {
    lid_part();
}
