// [Component Type]
type = "handle"; // ["handle","cylinder","cup","step"]

/* [Handle Options] */
rod_d          = 9;     // mm (M8 rod)
center_h       = 20;    // mm vertical height
center_d       = 30;    // mm vertical cylinder Ø
pocket_flat_w  = 10.3;    // mm nut‐flat width
pocket_depth   = 6;     // mm nut height
pocket_offset  = 10;    // mm from base to pocket start
handle_len     = 200;   // mm length of horizontal bar
handle_d       = 16;    // mm diameter of horizontal bar
$fn_handle     = 128;    // resolution

/* [Cylinder Options] */
outer_d      = 30;  // mm
inner_d      = 25;  // mm
height       = 20;  // mm
$fn_ring     = 128;  // resolution

/* [Cup Options] */
cup_outer_d      = 30;  // mm
cup_inner_d      = 25;  // mm
cup_height       = 20;  // mm
cup_bottom_h     = 10;  // mm
cup_hole_d       = 9;  // mm
$fn_cup          = 128;  // resolution

/* [Step Options] */
base_d        = 30;  // mm
base_h        = 12;  // mm
top_d         = 18;  // mm
top_h         = 8;   // mm
step_hole_d   = 9;  // mm
$fn_step      = 128;  // resolution


// — dispatch —
if      (type == "cylinder")   cylinder_hollow(outer_d, inner_d, height,      $fn_ring);
else if (type == "cup")    cup(cup_outer_d, cup_inner_d, cup_height, cup_bottom_h, cup_hole_d, $fn_cup);
else if (type == "step")   step(base_d, base_h, top_d, top_h, step_hole_d, $fn_step);
else if (type == "handle") handle(
    rod_d,
    center_h,
    center_d,
    pocket_flat_w,
    pocket_depth,
    pocket_offset,
    handle_len,
    handle_d,
    $fn_handle
);

// — modules —
module cylinder_hollow(od, id, h, fn=64) {
  difference() {
    cylinder(d=od, h=h, $fn=fn);
    translate([0,0,-1]) cylinder(d=id, h=h+2, $fn=fn);
  }
}

module cup(od, id, h, bottom_h, hole_d, fn=64) {
  difference() {
    cylinder(d=od, h=h, $fn=fn);
    translate([0,0,bottom_h]) cylinder(d=id, h=h, $fn=fn);
    translate([0,0,-1]) cylinder(d=hole_d, h=h+2, $fn=fn);
  }
}

module step(bd, bh, td, th, hd, fn=64) {
  difference() {
    union() {
      cylinder(d=bd, h=bh, $fn=fn);
      translate([0,0,bh]) cylinder(d=td, h=th, $fn=fn);
    }
    translate([0,0,-1]) cylinder(d=hd, h=bh+th+2, $fn=fn);
  }
}

// — Handle + horizontal bar + nut‑pocket —
module handle(
    rod_d,
    center_h,
    center_d,
    flat_w,
    pocket_h,
    pocket_z,
    handle_len,
    handle_d,
    fn=64
) {
  difference() {
    union(){
        // vertical grip
        cylinder(d=center_d, h=center_h, $fn=fn);
        // horizontal bar (centered on ground)
        translate([0, 0, handle_d/2])
        rotate([0,90,0])
            cylinder(d=handle_d, h=handle_len - handle_d, center=true, $fn=fn);

        // rounded ends
        translate([-handle_len/2 + handle_d/2, 0, handle_d/2])
        sphere(d=handle_d, $fn=fn);
        translate([ handle_len/2 - handle_d/2, 0, handle_d/2])
        sphere(d=handle_d, $fn=fn);
    }
    // rod hole through vertical only
    cylinder(d=rod_d, h=center_h, $fn=fn);

    // nut pocket in vertical
    translate([0,0,pocket_z]) {
      pd = flat_w * 2 / sqrt(3);
      cylinder(d=pd, h=pocket_h, $fn=6);
      translate([0,0,-1])
        cylinder(d=rod_d, h=pocket_h+2, $fn=fn);
    }
  }
}
// --- Slice with pause at Z = pocket_offset + pocket_depth to drop in nut. ---
