# G-Signe LED Base Enclosure

A customizable two-part 3D-printable enclosure for a circular LED strip lighting base with integrated PSU and ESP32 controller housing.

## Overview

This OpenSCAD project generates a circular base and lid designed to house:
- **LED Profile**: 17 x 9 mm upright LED strip (1 m tall)
- **Power Supply**: 85 x 60 x 35 mm PSU
- **Controller**: ESP32 microcontroller (~60 x 30 mm)
- **Cable Management**: Side cable exit port

## Features

- **Two-part Design**: Separate base and lid for easy assembly
- **Spiral Ribs**: Decorative and structural spiral patterns on base walls
- **Perforated Lid**: Small holes for ventilation and reduced material usage
- **LED Profile Sleeve**: Secure socket at base bottom to hold LED profile in place
- **Cable Exit**: Right-side port for power/signal cables
- **Ventilation**: Large vent opening on back wall and perforated lid
- **Customizable**: All dimensions and features are parametric

## File Structure

```
gsigne-base/
├── signe.scad          # Main OpenSCAD design file
└── README.md           # This file
```

## Using the File

### Prerequisites
- **OpenSCAD** (free, open-source 3D CAD software)
  - Download from: https://openscad.org/

### How to Open and View

1. Open OpenSCAD
2. File → Open → Select `signe.scad`
3. Press F5 (or Design → Preview) to preview the model
4. Press F6 (or Design → Render) for final quality rendering

### Export Modes

Control what is rendered by changing the `export_mode` parameter at the top of the file:

```scad
export_mode = 0;  // 0 = preview both parts, 1 = base only, 2 = lid only
```

- **Mode 0 (Preview)**: Shows both base and lid assembled for visualization
- **Mode 1 (Base)**: Renders only the base part for 3D printing
- **Mode 2 (Lid)**: Renders only the lid part for 3D printing

### Customization

All design parameters are grouped at the top of the file for easy modification:

#### Main Dimensions
- `base_diameter`: Overall diameter of the enclosure (default: 140 mm)
- `inner_height`: Height of interior space (default: 100 mm)
- `wall`: Thickness of cylindrical walls (default: 3 mm)
- `floor_thick`: Bottom floor thickness (default: 3 mm)

#### LED Profile
- `prof_w`: Profile width (default: 18.6 mm) - adjust if using different profile
- `prof_h`: Profile height (default: 9 mm)
- `slot_depth_base`: How deep the slot goes into the base (default: 15 mm)
- `slot_depth_lid`: How deep the slot goes into the lid (default: 18.6 mm)

#### Profile Sleeve (Bottom Support)
- `sleeve_height`: Height of the base sleeve socket (default: 10 mm)
- `sleeve_wall`: Wall thickness around profile opening (default: 1.5 mm)

#### Ventilation Features
- **Perforations (Lid)**:
  - `perf_diameter`: Size of holes (default: 5 mm)
  - `perf_spacing`: Distance between holes (default: 20 mm)
  
- **Back Vent**:
  - `vent_width`: Width of opening (default: 20 mm)
  - `vent_height`: Height of opening (default: 70 mm)

#### Spiral Ribs (Decorative Wall Pattern)
- `rib_width`: Width of each rib (default: 2 mm)
- `rib_depth`: How far ribs protrude (default: 0.8 mm)
- `rib_count`: Number of spiral lines (default: 8)
- `rib_turns`: Rotations from bottom to top (default: 3)

#### Internal Components (Reference)
- `psu_len/w/h`: PSU dimensions (for planning layout)
- `esp_len/w`: ESP32 space allocation
- `cable_d`: Cable exit hole diameter (default: 10 mm)
- `cable_z`: Height of cable exit (default: 12 mm)

## 3D Printing Tips

### General Settings
- **Material**: PLA or PETG recommended
- **Layer Height**: 0.2 mm for good detail
- **Infill**: 15-20% (honeycomb or grid pattern)
- **Support**: May be needed on the inside of the base, depending on printer

### Part-Specific Recommendations

**Base:**
- Orient with flat side down (floor on build plate)
- Use support if printer struggles with overhangs
- Total print time: ~8-12 hours (depending on infill and speed)

**Lid:**
- Flat side down (easier to print)
- The plug section on underside may need support
- Total print time: ~3-4 hours

### Post-Processing
1. Remove support material
2. Clean up any rough edges with sandpaper
3. Optional: Paint or apply finish coat
4. Dry fit components before assembly

## Assembly Guide

1. **Prepare Components**: Ensure LED profile, PSU, and ESP32 are ready
2. **Insert LED Profile**: Slide the LED profile down into the base sleeve until it bottoms out
3. **Position Internal Components**: Place PSU and ESP32 inside the hollow base
4. **Cable Management**: Route cables through the side exit port
5. **Attach Lid**: Align the lid's plug with the base opening and press down
6. **Optional**: Apply thermal adhesive or clips if extra rigidity is needed

## Coordinate System

The design uses the following convention:
- **Front** (X+): Where the LED profile is positioned
- **Back** (X-): Large vent opening
- **Right** (Y+): Cable exit port
- **Up** (Z+): Top of enclosure

## Troubleshooting

### Render is Slow
- Lower the `$fn` values in the code (fewer facets = faster preview)
- Use Preview (F5) instead of Render (F6) for design work

### Lid Doesn't Fit
- Check `lid_clearance` parameter (currently 0.2 mm)
- Increase if the fit is too tight
- Decrease if there's too much wobble

### LED Profile Slot Too Tight
- Adjust `slot_clear` parameter (add clearance)
- Currently set to 0.3 mm

### Need Different Dimensions
- All parameters at the top are easily modified
- Re-render after each change to check fit
- Consider tolerances for your specific printer

## Notes

- All measurements are in millimeters
- Design assumes FDM 3D printing (0.4 mm nozzle standard)
- The two-part design allows for easy access and component replacement
- Spiral ribs add visual interest while improving structural rigidity

## License

This design is part of the 3d-prints repository by gs3188.

## Contact

For questions or modifications, refer to the main repository.
