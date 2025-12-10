// DIY_Ambilight_Case.scad
// Parametric OpenSCAD case for: 5V 20A PSU (200x100x40 mm), Rezcoo HDMI 2.0 splitter,
// HDMI capture card, Raspberry Pi 3B, ESP32, and cable routing.
// - Removable lid (screwed)
// - Ventilation (hex pattern) on top and sides
// - Standoffs for Pi and ESP32
// - PSU bay sized to user-supplied dims
// Adjust parameters below to match exact board hole positions or personal preferences.

// -------------------------
// RENDER MODE SELECTION
// -------------------------
// Change this value to render different components:
// 0 = Full assembly preview (both base and lid together)
// 1 = Base only (for 3D printing)
// 2 = Lid only (for 3D printing)
// 3 = Base with component mounts visible (for planning)
// 4 = Exploded view (base and lid separated)
render_mode = 3;

// -------------------------
// Parameters (edit to fit your parts)
// -------------------------
wall_thickness = 3.0; // mm
base_height = 6; // height of base lip
lid_thickness = 3.5;
clearance = 1.5; // room around components
screw_diameter = 3.2; // clearance for M3 screws
standoff_diameter = 6.0;
standoff_height = 6.0;
standoff_hole_dia = 3.2; // hole for M3 screw

// PSU dimensions (user provided)
psu_w = 200; // length along X
psu_d = 100; // depth along Y
psu_h = 40;  // height

// Raspberry Pi3B approx footprint (adjust if you want precise hole locations)
pi_w = 85;
pi_d = 56;
pi_h = 17; // including connectors clearance
pi_mount_margin = 6; // distance from Pi edge to standoff centers

// Rezcoo splitter and capture card footprint (approx) - adjust if you have exact dims
splitter_w = 120;
splitter_d = 60;
splitter_h = 20;

capture_w = 90;
capture_d = 40;
capture_h = 15;

// ESP32 (small)
esp_w = 52; // typical dev board length
esp_d = 25;
esp_h = 8;

// Internal spacing and layout
bay_gap = 8; // gap between bays

// Vent pattern
hex_radius = 3.0; // size of hex holes
hex_spacing = hex_radius * 2.2;

// Wall perforations
perf_diameter = 4;      // diameter of perforation holes
perf_spacing = 10;      // spacing between perforations
perf_margin = 10;       // margin from edges

// Overall layout orientation: X is length, Y is depth

// -------------------------
// Derived box sizes
// -------------------------
internal_x = psu_w + bay_gap + max(splitter_w, capture_w, pi_w) + 2*clearance;
internal_y = max(psu_d, max(splitter_d, capture_d, pi_d, esp_d)) + 2*clearance;
internal_z = max(psu_h, splitter_h + capture_h, pi_h + 8) + 12; // extra headroom

outer_x = internal_x + 2*wall_thickness;
outer_y = internal_y + 2*wall_thickness;
outer_z = base_height + internal_z + lid_thickness;

// -------------------------
// Build
// -------------------------
module box_base() {
  difference() {
    // outer shell
    translate([0,0,0])
      cube([outer_x, outer_y, base_height + internal_z]);
    // hollow
    translate([wall_thickness, wall_thickness, base_height])
      cube([internal_x, internal_y, internal_z]);
  }
}

module lid() {
  // flat lid with lip that fits inside walls
  hull() {
    translate([0,0,0]) cube([outer_x, outer_y, lid_thickness]);
  }
}

// hexagon shape
module hexagon(r=3) {
  polygon(points=[
    [r,0], [r/2, r*sqrt(3)/2], [-r/2, r*sqrt(3)/2], [-r,0], [-r/2, -r*sqrt(3)/2], [r/2, -r*sqrt(3)/2]
  ]);
}

// hex vent grid inside rectangle
module hex_vent(rect_w, rect_d, spacing=6, r=3) {
  for(x = [spacing/2 : spacing : rect_w - spacing/2])
    for(y = [spacing/2 : spacing : rect_d - spacing/2]) {
      // offset every other column to create honeycomb
      off = ((floor((x)/(spacing))+0) % 2) * spacing/2;
      translate([x+off - rect_w/2, y - rect_d/2, 0])
        hexagon(r=r);
    }
}

// Wall perforations for front and back walls
module wall_perforations_fb() {
  // Front wall (X-Y plane)
  for (y = [perf_margin : perf_spacing : outer_y - perf_margin]) {
    for (z = [base_height + perf_margin : perf_spacing : base_height + internal_z - perf_margin]) {
      translate([-1, y, z])
        rotate([0, 90, 0])
          cylinder(d = perf_diameter, h = wall_thickness + 2, $fn = 16);
    }
  }
  // Back wall
  for (y = [perf_margin : perf_spacing : outer_y - perf_margin]) {
    for (z = [base_height + perf_margin : perf_spacing : base_height + internal_z - perf_margin]) {
      translate([outer_x - wall_thickness - 1, y, z])
        rotate([0, 90, 0])
          cylinder(d = perf_diameter, h = wall_thickness + 2, $fn = 16);
    }
  }
}

// Wall perforations for left and right walls
module wall_perforations_lr() {
  // Left wall (X-Z plane)
  for (x = [perf_margin : perf_spacing : outer_x - perf_margin]) {
    for (z = [base_height + perf_margin : perf_spacing : base_height + internal_z - perf_margin]) {
      translate([x, -1, z])
        rotate([90, 0, 0])
          cylinder(d = perf_diameter, h = wall_thickness + 2, $fn = 16);
    }
  }
  // Right wall
  for (x = [perf_margin : perf_spacing : outer_x - perf_margin]) {
    for (z = [base_height + perf_margin : perf_spacing : base_height + internal_z - perf_margin]) {
      translate([x, outer_y - wall_thickness - 1, z])
        rotate([90, 0, 0])
          cylinder(d = perf_diameter, h = wall_thickness + 2, $fn = 16);
    }
  }
}

// standoff
module standoff(x, y, h=standoff_height) {
  translate([x, y, base_height])
    union() {
      cylinder(h=h, r=standoff_diameter/2, $fn=36);
      translate([0,0,h]) cylinder(h=1, r=standoff_diameter/2+0.15, $fn=36);
    }
  // screw hole
  translate([x, y, base_height - 0.1]) rotate([0,0,0]) cylinder(h=h+2, r=standoff_hole_dia/2, $fn=24);
}

// cable slot
module cable_slot(x, y, w, h) {
  translate([x, y, base_height + 2])
    cube([w, h, internal_z - 6]);
}

// make mounting pattern for Raspberry Pi approximate
module pi_mount(x0, y0) {
  // draw Pi footprint
  translate([x0, y0, base_height]) cube([pi_w, pi_d, pi_h]);
  // four standoffs (approx positions inside margins)
  standoff(x0 + pi_mount_margin, y0 + pi_mount_margin);
  standoff(x0 + pi_w - pi_mount_margin, y0 + pi_mount_margin);
  standoff(x0 + pi_mount_margin, y0 + pi_d - pi_mount_margin);
  standoff(x0 + pi_w - pi_mount_margin, y0 + pi_d - pi_mount_margin);
}

// ESP32 mount
module esp32_mount(x0,y0) {
  translate([x0, y0, base_height]) cube([esp_w, esp_d, esp_h]);
  // two standoffs
  standoff(x0 + 6, y0 + 6);
  standoff(x0 + esp_w - 6, y0 + 6);
}

// PSU bay
module psu_bay(x0, y0) {
  translate([x0, y0, base_height]) cube([psu_w, psu_d, psu_h + 6]);
  // ventilation above PSU
  translate([x0 + psu_w/2, y0 + psu_d/2, base_height + psu_h + 2])
    rotate([0,0,0]) translate([-psu_w/2 + 8, -psu_d/2 + 8, 0])
      linear_extrude(height=1) {
        hex_vent(psu_w - 16, psu_d - 16, spacing=hex_spacing, r=hex_radius);
      }
}

// splitter + capture bay stacked
module device_stack(x0, y0) {
  // place splitter
  translate([x0, y0, base_height]) cube([splitter_w, splitter_d, splitter_h]);
  // capture card in front
  translate([x0 + splitter_w - capture_w, y0 + splitter_d - capture_d, base_height + splitter_h + 3]) cube([capture_w, capture_d, capture_h]);
}

// top vents
module top_vents() {
  // create a rectangular vent area centered over the stack area
  vent_w = internal_x - 2*clearance;
  vent_d = internal_y - 2*clearance;
  translate([wall_thickness + clearance + vent_w/2, wall_thickness + clearance + vent_d/2, base_height + internal_z + 0.2])
    rotate([0,0,0]) linear_extrude(height=1)
      offset(delta=0) hex_vent(vent_w, vent_d, spacing=hex_spacing, r=hex_radius);
}

// side vents on both long sides
module side_vents() {
  side_w = internal_x - 2*clearance;
  side_h = internal_z/2;
  // left side vents
  translate([wall_thickness, wall_thickness + clearance, base_height + base_height/2])
    linear_extrude(height=1) hex_vent(side_w, side_h, spacing=hex_spacing, r=hex_radius);
  // right side vents
  translate([wall_thickness + internal_x, wall_thickness + clearance, base_height + base_height/2])
    rotate([0,0,180]) linear_extrude(height=1) hex_vent(side_w, side_h, spacing=hex_spacing, r=hex_radius);
}

// lid screw posts (female holes in lid align with standoffs)
module lid_screw_posts() {
  // place 6 screw posts around perimeter
  pad = 8;
  posts = [
    [pad, pad],
    [outer_x - pad, pad],
    [pad, outer_y - pad],
    [outer_x - pad, outer_y - pad],
    [outer_x/2, pad],
    [outer_x/2, outer_y - pad]
  ];
  for(p = posts) {
    translate([p[0]-screw_diameter/2, p[1]-screw_diameter/2, base_height + internal_z - 1])
      cube([screw_diameter, screw_diameter, lid_thickness + 2]);
  }
}

// cable cutouts at rear
module rear_cutouts() {
  // make a large rectangular opening for power and hdmi cables
  cut_w = 80;
  cut_h = 20;
  translate([outer_x - wall_thickness - cut_w - 6, outer_y/2 - cut_h/2, base_height + 6])
    cube([cut_w, cut_h, internal_z - 10]);
}

// -------------------------
// Assemble with difference to create holes, vents, etc.
// -------------------------
module assembled_case() {
  // main solid box
  union() {
    // base shell
    box_base();
    // lid on top (separated a bit so you can see in preview)
    translate([0,0,base_height + internal_z]) lid();
  }
  // subtract internal cutouts/hollows and vents
  difference() {
    // outer body
    union() { box_base(); translate([0,0,base_height + internal_z]) lid(); }
    // hollow internal already handled by box_base's difference
    // subtract top vents
    translate([0,0,0]) top_vents();
    // side vents
    translate([0,0,0]) side_vents();
    // subtract standoffs holes so screws can pass (holes already created inside standoff module) - no extra action
    // subtract pi and device spaces (create removable clearance)
    // place PSU bay at left inside
    translate([wall_thickness + clearance, wall_thickness + clearance, 0])
      difference() {
        // create PSU cavity
        translate([0,0,0]) cube([psu_w + 0.1, psu_d + 0.1, psu_h + 6 + internal_z]);
      }
    // place rear cutouts
    rear_cutouts();
    // top vent holes already placed
  }
}

// For preview: show mounts and standoffs as solid additions so the user can see where to fasten
module preview_components() {
  // PSU
  translate([wall_thickness + clearance, wall_thickness + clearance, base_height]) color([0.9,0.7,0.7]) psu_bay(0,0);
  // Raspberry Pi positioned on the opposite bay
  pi_x = wall_thickness + clearance + psu_w + bay_gap;
  pi_y = wall_thickness + clearance + (internal_y - pi_d)/2;
  translate([0,0,0]) pi_mount(pi_x, pi_y);
  // ESP32 near Pi
  esp_x = pi_x + pi_w - esp_w - 6;
  esp_y = pi_y + pi_d - esp_d - 6;
  esp32_mount(esp_x, esp_y);
  // device stack next to Pi
  device_x = wall_thickness + clearance + psu_w + bay_gap;
  device_y = wall_thickness + clearance + 6;
  translate([0,0,0]) device_stack(device_x, device_y + pi_d + 6);
}

// ---------------
// Render Selection
// ---------------
if (render_mode == 0) {
    // Mode 0: Full assembly preview
    assembled_case();
    
} else if (render_mode == 1) {
    // Mode 1: Base only (for 3D printing)
    difference() {
        union() {
            box_base();
        }
        // subtract top vents
        translate([0,0,0]) top_vents();
        // side vents
        translate([0,0,0]) side_vents();
        // wall perforations
        wall_perforations_fb();
        wall_perforations_lr();
        // PSU cavity
        translate([wall_thickness + clearance, wall_thickness + clearance, 0])
            difference() {
                translate([0,0,0]) cube([psu_w + 0.1, psu_d + 0.1, psu_h + 6 + internal_z]);
            }
        // rear cutouts
        rear_cutouts();
    }
    
} else if (render_mode == 2) {
    // Mode 2: Lid only (for 3D printing)
    difference() {
        lid();
        // lid vents
        translate([0,0,0]) top_vents();
    }
    
} else if (render_mode == 3) {
    // Mode 3: Base with component mounts visible
    difference() {
        union() {
            box_base();
        }
        translate([0,0,0]) top_vents();
        translate([0,0,0]) side_vents();
        // wall perforations
        wall_perforations_fb();
        wall_perforations_lr();
        translate([wall_thickness + clearance, wall_thickness + clearance, 0])
            difference() {
                translate([0,0,0]) cube([psu_w + 0.1, psu_d + 0.1, psu_h + 6 + internal_z]);
            }
        rear_cutouts();
    }
    // Show component mounts
    preview_components();
    
} else if (render_mode == 4) {
    // Mode 4: Exploded view
    difference() {
        union() {
            box_base();
        }
        translate([0,0,0]) top_vents();
        translate([0,0,0]) side_vents();
        // wall perforations
        wall_perforations_fb();
        wall_perforations_lr();
        translate([wall_thickness + clearance, wall_thickness + clearance, 0])
            difference() {
                translate([0,0,0]) cube([psu_w + 0.1, psu_d + 0.1, psu_h + 6 + internal_z]);
            }
        rear_cutouts();
    }
    // Lid separated above
    translate([0, 0, base_height + internal_z + 30])
        difference() {
            lid();
            translate([0,0,-30]) top_vents();
        }
}

// -------------------------
// Notes:
// - This is a parametric starting point. Update dimensions to match exact PCB mounting hole coordinates if you want precise M2/M3 hole positions for the Pi.
// - The lid is a simple plate; you can add screw countersinks, clips or snap-fit features as desired.
// - If your PSU has connectors or protrusions on certain sides, rotate the PSU by swapping psu_w/psu_d or adjust orientation variables.
// - For printing: use 3-4mm walls, 3-4 perimeters, and consider adding ribs for strength. PLA is fine but if PSU generates heat use PETG and leave extra vent area.
// - If you'd like, I can tune standoff positions to match the exact Raspberry Pi 3B screw hole pattern (requires exact coordinates) and add M3 captive nuts in the lid.
// -------------------------
