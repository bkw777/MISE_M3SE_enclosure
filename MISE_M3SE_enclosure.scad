// M1SE/M3SE Enclosure - Top Cover
// b.kenyon.w@gmail.com
// version: 2.2.005

// Which version to generate, M1SE or M3SE
// The only difference is the width of the slot for the bus cable.
// M1SE has a 40-wire cable, M3SE has a 50-wire cable.
// M3SE version can be used for both M3SE and M1SE.
variant = "M3SE";

// Normally Makefile sets this.
// "none", "top_cover", "bottom_cover", "retainer", "nail", "small_parts"
// "display_1", "display_2", "display_3", "display_nail"
make = "display_2";

$fs = 0.25;
$fa = 1;
o = 0.01; // overlap/overcut - extend unions/cuts past boundaries
fc = 0.1; // part fitment clearance
fr = 1;   // default fillet radius

// PCB dimensions
// https://groups.yahoo.com/neo/groups/TRS80MISE/conversations/topics/157
//  >  All hole centers are 250 mils from card edges, drilled for 187 mil board feet.
//  >  "Short edge" holes centered 3815 mils apart.
//  >  "Long edge" holes centered 4770 mils apart.
//  >  Thus the PCB is 4315x5270 mils.
px = 133.858; // pcb x len
py = 109.601; // pcb y len
pcb_thickness = 1.6;
pz = fc + pcb_thickness + fc;
mi = 6.35;    // mounting holes inset from pcb edges
mhd = 4.75;   // mount hole diameter

// rear wall holes
vga_w = 35.814;
vga_h = 17.018;
vga_xc = -14.99;  // pcb X center to vga X center
vga_zb = -2.032;  // pcb Z top to vga Z bottom
pwr_r = 5.08;     // power radius
pwr_xc = -45.847; // pcb X center to power X center
pwr_zc = 6.604;   // pcb Z top to power Z center
nic_w = 16.51;
nic_h = 13.462;
nic_xc = 29.972;  // pcb X center to nic X center
nic_zt = 26.67;   // pcb Z top to nic Z top - NIC conector is the tallest top-side component, so normally you want "th" and "iw_h" to just copy this

// front wall holes
joy_h = 12.7;     // joystick height
joy_w = 25; //22.86;    // joystick width
joy_xc = -30;     // pcb center to js center
                  // joystick bottom = pcb top
joy_f = 5.1;      // pcb front edge to joystick front

cf_connector_thickness = 3.85 ; // references/CF-50P.png
cf_h = 0.1 + cf_connector_thickness + 0.1 + pz + 0.1 + cf_connector_thickness + 0.1 ; // cf height 9.9
cf_w = fc+43.1+fc;    // cf width
                 // cf top = inside top surface = iw_h
cf_xc = joy_xc;  // cf x center

// right wall holes
bus_cable_conductors = (variant=="M1SE") ? 40 : 50;
bus_w = bus_cable_conductors * 1.27 + 1; // bus cable width
bus_h = 6.35;   // bus cable height
bus_yc = -5.33; // pcb center to bus cable center
                // bus cable z bottom = ew_z bottom

bch = 2.54;    // bottom-side components height - height of tallest bottom-side component (screw heads for heat sinks and connectors) from pcb bottom - inner/upper surface of base_plate rests here
tch = nic_zt;  // top-side components height - height of tallest top-side component (ethernet port) above pcb top - inner/lower surface of top wall rests here
assert(tch>=nic_zt,"tch must be >= nic_zt");
wt = 2.54;     // wall thickness - 2.54 makes the face of the ethernet port flush with the exterior surface

// NIC module pcb extends beyond the main pcb rear edge by this much.
// Rear vertical wall can be no closer to the main pcb than this.
// This just the nic module pcb,
// not including the rj45 connector which extends futher.
nic_pcb_overhang = 6.35; // nic module pcb overhang beyond main pcb edge

// FPGA module pcb extends past main pcb front edge by this much.
// Front vertical wall can be no closer to the main pcb than this.
fpga_pcb_overhang = 12.192; // fpga module pcb overhang beyond main pcb edge

// pcb edges to inside walls
f2w = fpga_pcb_overhang; // front pcb edge to front inside wall - must be fpga_pcb_overhang or greater
assert(f2w>=fpga_pcb_overhang,"f2w must be >= fpga_pcb_overhang");
l2w = 2;                 // left  pcb edge to left  inside wall - mise v1.1 has a heat-sink that overhangs about one mm or less on the left - v1.2 has no overhangs on the left
r2w = 2;                 // right pcb edge to right inside wall - no overhangs on the right, but the bus cable passes between the pcb and the wall.
assert(r2w>=1.27,"r2w must be enough to allow the bus cable to fit between the pcb and the enclosure wall.");
b2w = nic_pcb_overhang;  // back  pcb edge to back  inside wall - must be nic_pcb_overhang or greater
assert(b2w>=nic_pcb_overhang,"b2w must be >= nic_pcb_overhang");

// screw posts and countersinks
screw_d = 3.5;  // screw diameter - #6 = 0.14" = 3.5
screw_fhr = 4 ; // flat head radius
spir = screw_d/2-0.1; // screw post inside radius
spor = spir+2.5; // screw post outside radius
screw_post_fillet = 2.5;
screw_post_chamfer = 0.75;

// printable flat nail that can be used in place of screw
// nail length not counting head
nail_length = 20 + pcb_thickness + bch;

// square nail cross-section diagonal width, percent of screw post ID
// 0 = corners of nail body exactly the same is screw hole ID
// -n = diagonal x% smaller than hole
// +n = diagonal x% larger than hole
nail_interference_fit_percent = 10;

// how far the full-width non-tapered part of the nail shank inserts into the screw post
// 0 = nail is only full width in the PCB and bottom cover
//     tapers from 75% to full width over the remaining length
nail_grip_depth = 0;

nail_full_width = sq_in_circle(spir*2) * (100+nail_interference_fit_percent)/100;
nail_tip_width = nail_full_width * 0.75;

// interior walls
iw_x = l2w + px + r2w;
iw_y = f2w + py + b2w;
// This controls how high the top is above the highest component
iw_h = tch; // interior walls height - may be "tch" or greater
assert(iw_h>=tch,"iw_h must be >= tch");
iw_z = wt + bch + pz + iw_h; // total interior wall height

// exterior walls
ew_x = wt + iw_x + wt;  // total exterior X width
ew_y = wt + iw_y + wt;  // total exterior Y depth
ew_z = iw_z + wt;       // total exterior Z height

// wall corners radius, 0 to 13
// 0 = square corners
// 0.001 = square inside, round outside thickness of walls
// >0 = round corners
// >13 = invalid, hits pcb corners
cr = 6; // vertical corners inside radius

twt = 2; // tunnel wall thickness
p2t = 0.5; // any pcb edge pcb to any tunnel end

joy_t = f2w-joy_f-p2t; // joystick tunnel length

// CF reader
cft_w = 47.3; // cf tray inside width
cft_d = 27.3; // cf tray inside depth

// This controls how far the CF cards stick out of the front of the enclosure.
// This can vary from 0 to almost 9 in theory. (at 9 you would need fingernails to get the CF cards out)
cft_f2w = 5.842;  // cf tray inside front to inside front wall
//cft_f2w = 0;
                  // cf tray X center = cf opening X center = js_xc
cft_wt = 3;      // cf tray wall thickness
cft_wh = 2.4;    // cf tray wall height

cft_ow = cft_wt+cft_w+cft_wt; // cf tray outer walls
cft_otw = twt+cf_w+twt;       // cf tunnel outer walls

cft_cny = 4.83;    // cf tray clearance notch, inner tray rear to notch side
cft_cnl = 10.66;   // cf tray clearance notch, width
cft_cnh = 1.27;    // cf tray clearance notch, floor height (top wall inner surface to notch floor)

// cf reader retainer
// cf reader retainer top - cr_top is special
// The back side of the FPGA board comes down very close to the top of the JP2 jumper on the card reader.
// cr_top should be as high as possible, touching the FPGA board.
// This should allow about 1mm of plastic to cover the top of JP2 and act as a barrier to prevent JP2 from touching and shorting on the FPGA board.
// If really needed, you can increase iw_h, which will increase the distance between the fpga board and the card reader.
cr_top = 13; // highest surface on retainer bar

// cf retainer lid thickness
cr_lt = cr_top - cf_h;

cr_tab_w = 10; // retainer tab width
cr_tab_wt = 3; // wall thickness around tab
cr_tab_pocket_wall_thickness = 5; // spor*2;
cr_tab_locx = px/2+cf_xc-mi-cft_w/2; // centered on screw post
cr_tab_pocket_wall_height = cr_top + 3;
cr_leg_w = 4;  // leg thickness
cr_tab_len = cr_tab_locx + cr_tab_pocket_wall_thickness/2-cr_leg_w/2-fc; // for flush end, add "-cr_leg_w/2"
p_wall_y1 = f2w + mi;  // pocket wall front
p_wall_y2 = cft_f2w + cft_d + 5;  // pocket wall back
cr_tab_pocket_wall_length = p_wall_y2 - p_wall_y1;

// TODO - re-arrange this to be based off the edge of the reader pcb
//        this dim is left over from the previous style with a foot tab that goes into a pocket
// cf retainer latch block
cr_latch_locx = 18; // tray side to pocket side
cr_latch_handle = 6; // retainer bar extends past leg to make a handle

include <handy.scad>;

///////////////////////////////////////////////////

function sq_in_circle(d) = d * sqrt(2)/2;

module walls() {
  difference() {
    union() { // add
      // exterior walls
      if(cr<=0)
       translate([-l2w-wt,-f2w-wt,-pz-bch-wt])
        cube([ew_x,ew_y,ew_z]); // square corners
      else
       hull() { // round corners
        translate([-l2w+cr,-f2w+cr,-pz-bch-wt]) cylinder(ew_z,cr+wt,cr+wt);
        translate([px+r2w-cr,-f2w+cr,-pz-bch-wt]) cylinder(ew_z,cr+wt,cr+wt);
        translate([-l2w+cr,py+b2w-cr,-pz-bch-wt]) cylinder(ew_z,cr+wt,cr+wt);
        translate([px+r2w-cr,py+b2w-cr,-pz-bch-wt]) cylinder(ew_z,cr+wt,cr+wt);
      }

    } // add
    union() { // remove
      // interior walls
      if(cr<=0) translate([-l2w,-f2w,-pz-bch-wt-wt]) cube([iw_x,iw_y,ew_z]);  // square corners
      else hull() {                                                           // round corners
        translate([-l2w+cr,-f2w+cr,-pz-bch-wt-o]) cylinder(ew_z-wt+o,cr,cr);
        translate([px+r2w-cr,-f2w+cr,-pz-bch-wt-o]) cylinder(ew_z-wt+o,cr,cr);
        translate([-l2w+cr,py+b2w-cr,-pz-bch-wt-o]) cylinder(ew_z-wt+o,cr,cr);
        translate([px+r2w-cr,py+b2w-cr,-pz-bch-wt-o]) cylinder(ew_z-wt+o,cr,cr);
      }

      // holes in the walls
      translate([px/2+nic_xc-(nic_w/2),py+b2w-o,nic_zt-nic_h]) cube([nic_w,o+wt+o,nic_h]); // nic opening
      translate([px/2+vga_xc-(vga_w/2),py+b2w-o,vga_zb]) cube([vga_w,o+wt+o,vga_h]); // vga opening
      translate([px/2+pwr_xc,py+b2w-o,pwr_zc]) rotate([-90,0,0]) cylinder(o+wt+o,pwr_r,pwr_r); // power opening
      translate([px/2+joy_xc-(joy_w/2),-f2w-wt-o,0]) cube([joy_w,o+wt+o,joy_h]); // joystick opening
      translate([px/2+cf_xc-(cf_w/2),-f2w-wt-o,iw_h-cf_h]) cube([cf_w,o+wt+o,cf_h]); // cf opening
      translate([px+r2w-o,py/2+bus_yc-bus_w/2,-pz-bch-wt-o]) cube([o+wt+o,bus_w,bus_h+o]); // bus opening

      // bar lid front receptical groove
      translate([px/2+cf_xc+cft_otw/2+1,-f2w+0.001,iw_h-cf_h])
        rotate([180,90,0])
          linear_extrude(1+cft_otw+1)
            polygon([
              [0,0],
              [cr_lt,0],
              [cr_lt/2,cr_lt/3]
            ]);

    } // remove
  }
  // round the edge of the bus cable opening
  translate([px+r2w+wt/2,bus_w/2+py/2+bus_yc,-pz-bch-wt+bus_h]) rotate([90,0,0]) cylinder(o+bus_w+o,wt/2,wt/2,$fn=48);

}

module boss () {
  screw_post(h=iw_h,od=spor*2,id=spir*2,fr=screw_post_fillet,ch=screw_post_chamfer);
}

module posts() {
  x = (px-mi-mi)/2;
  y = (py-mi-mi)/2;
  translate([x+mi,y+mi,iw_h+o])
   mirror_copy([1,0,0]) translate([x,0,0])
    mirror_copy([0,1,0]) translate([0,y,0])
     rotate([180,0,0])
      boss();
}

module cf_holder() {
  translate([px/2+cf_xc,-f2w,iw_h+.001])
  rotate([0,180,0])
  difference(){ // cf_holder diff
    union(){ // fc_holder diff add
      // tunnel - really just two walls now
      translate([-cft_otw/2,0,0])
       cube([cft_otw,cft_f2w,cf_h-fc/2]);

      // front lid guide
      // strain-releif for the pocket wall while the retainer is being installed or removed
      gl=4; // length of upper guides
      gw=twt; // width of upper guides
      translate([0,0,cf_h+cr_lt+fc/2])
      mirror_copy([1,0,0])
       translate([-cf_w/2+gw,0,0]) {
        rotate([0,-90,0])
          linear_extrude(gw)
            polygon([
              [0,0],
              [0,fr],
              [gl,gl+fr],
              [gl+fr,gl+fr],
              [gl+fr,0]
            ]);
        // fillets on the upper guides
        translate([-gw/2,0,0])
         mirror_copy([1,0,0])
          translate([-fr-gw/2+o,fr,0])
           rotate([0,0,-90])
            fillet_linear(l=gl+fr,r=fr);
      }
      // fillets on the tunnel walls
      mirror_copy([1,0,0])
       translate([-fr-cf_w/2-twt+o,fr,0])
        rotate([0,0,-90])
         fillet_linear(l=cf_h-fc/2,r=fr);

      // tray
      // rear wall
      translate([0,cft_f2w+cft_d+cft_wt/2+fc*2,0]) {
        hull() mirror_copy([1,0,0])
         translate([cft_w/2-cft_wt,0,0])
          cylinder(h=cft_wh,d=cft_wt);
        translate([-cft_w/2+cft_wt,cft_wh+cft_wt/2-o,cft_wh])
         rotate([-90,0,-90])
          fillet_linear(l=cft_w-cft_wt*2,r=cft_wh);
      }

      // side walls
      translate([0,cft_f2w+cft_d/2,0])
       mirror_copy([1,0,0])
        translate([-cft_w/2-cft_wt/2-fc,0,0])
         hull() mirror_copy([0,1,0])
          translate([0,cft_d/2-cft_wt,0])
           cylinder(h=cft_wh,d=cft_wt);

      // latch / ramp
      translate([-cft_w/2-cr_latch_locx-cr_tab_wt+fc,cft_f2w+cft_d+cr_leg_w/2-cr_tab_w,0])
        rotate([90,0,90])
          linear_extrude(cr_tab_wt+cr_leg_w+cr_tab_wt)
            polygon([
              [0,0],
              [0,cr_tab_wt],
              [cr_tab_w,cr_tab_wt],
              [cr_tab_w*2,0]
            ]);

      // bar pocket wall
      translate([cft_w/2+cr_tab_locx,p_wall_y1,0])
        difference(){ // bar pocket wall diff
          union() { // diff add
           hull(){
            cylinder(h=cr_tab_pocket_wall_height,d=cr_tab_pocket_wall_thickness);
            translate([0,cr_tab_pocket_wall_length,0])
             cylinder(h=cr_tab_pocket_wall_height,d=cr_tab_pocket_wall_thickness);
           }
           // top fillet
           difference(){
           f=2;
           translate([0,0,cr_tab_pocket_wall_height+f-o]) rotate([0,180,180]) fillet_polar(R=-spor-o,r=f,A=180);
           mirror_copy([1,0,0]) translate([cr_tab_pocket_wall_thickness/2,-o,cr_tab_pocket_wall_height-o-o]) cube([cr_tab_pocket_wall_thickness/2+f+o,o+spor+f+o,o+f+o]);
           }
           
          } // diff add
          
          // clear away around the screw hole
          translate([0,0,-o]) // diff remove
           cylinder(h=o+cr_tab_pocket_wall_height+o,d=o+spir*2+o);
        } // diff

    } // cf_holder diff add

    union(){ // cf_holder diff remove
      translate([-cf_w/2,-o,-o])
       cube([cf_w,o+cft_f2w+o,o+cf_h+o]); // tunnel

      // notch to clear some components on cf reader pcb
      translate([-cft_w/2-cft_wt-fc-o,cft_f2w+cft_d-cft_cnl-cft_cny,cft_cnh])
        cube([o+cft_wt+o,cft_cnl,cft_wh-cft_cnh+o]);

      // leg latch pocket
      translate([-cft_w/2-cr_latch_locx+cr_leg_w/2+fc,cft_f2w+cft_d-cr_leg_w/2,-o])
        hull(){
          cylinder(h=o+cr_tab_wt+o,d=cr_leg_w+fc);
          translate([0,-cr_tab_w,0]) cylinder(h=cr_tab_wt+o,d=cr_leg_w+fc);
        }

      // bar pocket
      translate([cft_w/2+cr_tab_locx-cr_tab_pocket_wall_thickness/2-o,cft_f2w+cft_d-(cr_tab_w+2),cr_top-cr_lt-0.4])
        cube([o+cr_tab_pocket_wall_thickness+o,0.2+cr_tab_w+2,0.4+cr_lt+0.4]);
    } // cf_holder diff remove
  }
}

//////////////////////////////////////////////////////////////////////

module pcb() {
  translate([0,0,-pz]) difference(){
    cube([px,py,pz]);
    union(){
      translate([mi,mi,-o]) cylinder(o+pz+o,d=mhd);
      translate([px-mi,mi,-o]) cylinder(o+pz+o,d=mhd);
      translate([mi,py-mi,-o]) cylinder(o+pz+o,d=mhd);
      translate([px-mi,py-mi,-o]) cylinder(o+pz+o,d=mhd);
    }
  }
}

// obstructions, parts of cf card reader
module reader() {
    cr_pcb_top = iw_h-0.1-cf_connector_thickness-0.1-pz;
    jp_h = 6;
    pw_h = 5;
    translate([px/2+cf_xc-cft_w/2,-cft_f2w,0]) union(){
    // bottom cf conn
    translate([0,0,iw_h-0.1-cf_connector_thickness]) cube([cft_w,cft_d,cf_connector_thickness]);
    // pcb
    translate([-2,0,cr_pcb_top]) cube([2+cft_w+13,cft_d+10,pz]);
    // top cf conn
    translate([0,0,cr_pcb_top-0.1-cf_connector_thickness]) cube([cft_w,cft_d,cf_connector_thickness]);
    }
    // JP1
    translate([6.2+60.2,mi+11.6,cr_pcb_top-jp_h]) cube([6.2,2.1,jp_h]);
    // JP2
    translate([6.2+10.1,mi+17.53,cr_pcb_top-jp_h]) cube([6.2,2.1,jp_h]);
    // power
    translate([6.2+56.7,mi-2.7,cr_pcb_top-pw_h]) cube([10,3.2,pw_h]);
}

module top_cover () {
  walls();
  posts();
  cf_holder();
} // top_cover

module bottom_cover () {
  difference(){
    union(){
      // base plate
      if(cr<=0) translate([-l2w,-f2w,-pz-bch-wt-wt]) cube([iw_x,iw_y,wt]);  // square corners
      else hull() {                                                           // round corners
        translate([-l2w+cr,-f2w+cr,-pz-bch-wt]) cylinder(wt,cr-0.5,cr-0.5);
        translate([px+r2w-cr,-f2w+cr,-pz-bch-wt]) cylinder(wt,cr-0.5,cr-0.5);
        translate([-l2w+cr,py+b2w-cr,-pz-bch-wt]) cylinder(wt,cr-0.5,cr-0.5);
        translate([px+r2w-cr,py+b2w-cr,-pz-bch-wt]) cylinder(wt,cr-0.5,cr-0.5);
      }
      translate([mi,mi,-pz-bch-o]) cylinder(bch+o,spor+2,spor);
      translate([mi,py-mi,-pz-bch-o]) cylinder(bch+o,spor+2,spor);
      translate([px-mi,mi,-pz-bch-o]) cylinder(bch+o,spor+2,spor);
      translate([px-mi,py-mi,-pz-bch-o]) cylinder(bch+o,spor+2,spor);
    }
    // r*1.15 makes 82 degree cone - countersink for screw head
    union(){
      translate([mi,mi,-pz-bch-wt-o]) {
        cylinder(bch+wt+2*o,d=screw_d+0.2);
        cylinder(screw_fhr*1.15,screw_fhr,0);
      }
      translate([mi,py-mi,-pz-bch-wt-o]) {
        cylinder(bch+wt+2*o,d=screw_d+0.2);
        cylinder(screw_fhr*1.15,screw_fhr,0);
      }
      translate([px-mi,mi,-pz-bch-wt-o]) {
        cylinder(bch+wt+2*o,d=screw_d+0.2);
        cylinder(screw_fhr*1.15,screw_fhr,0);
      }
      translate([px-mi,py-mi,-pz-bch-wt-o]) {
        cylinder(bch+wt+2*o,d=screw_d+0.2);
        cylinder(screw_fhr*1.15,screw_fhr,0);
      }
    }
  }
}

module retainer () {
  difference(){
   lfr = cr_leg_w/2; // local fillet radius
   ffc = fc*2; // front edge fitment clearance

   union(){  // add

   // lid main
   translate([(cft_w-cft_otw)/2+fc,ffc,0])
    cube([cft_otw,cft_f2w+cft_d-cr_tab_w-ffc+o,cr_lt]);

   // lid to rear bar fillets
   translate([cft_w/2+fc,0,0])
    mirror_copy([1,0,0])
     translate([-cft_w/2-lfr+(cft_w-cft_otw)/2+o,-lfr+cft_f2w+cft_d-cr_tab_w+o,0])
      fillet_linear(l=cr_lt,r=lfr);

   // lid front edge
   translate([(cft_w-cft_otw)/2+fc,ffc+0.001,0])
    rotate([0,-90,180])
     linear_extrude(cft_otw)
      polygon([
        [0,0],
        [cr_lt,0],
        [cr_lt/2,cr_lt/3]
       ]);

   // lid tab
   translate([-cr_tab_len-lfr,cft_f2w+cft_d+cr_leg_w/2-cr_tab_w,0])
    hull(){
     cylinder(h=cr_lt,d=cr_leg_w);
     translate([0,cr_tab_w-cr_leg_w,0])
      cylinder(h=cr_lt,d=cr_leg_w);
     translate([lfr+cr_tab_len+cft_w+cr_latch_locx-cr_leg_w/2+cr_latch_handle,0,0])
      cylinder(h=cr_lt,d=cr_leg_w);
     translate([lfr+cr_tab_len+cft_w+cr_latch_locx-cr_leg_w/2+cr_latch_handle,cr_tab_w-cr_leg_w,0])
      cylinder(h=cr_lt,d=cr_leg_w);
    }

   // leg
   translate([cft_w+cr_latch_locx-cr_leg_w/2,cft_f2w+cft_d-cr_tab_w+cr_leg_w/2,o]) {
    hull(){
     cylinder(h=cr_top-fc-o,d=cr_leg_w);
     translate([0,cr_tab_w-cr_leg_w,0])
      cylinder(h=cr_top-fc-o,d=cr_leg_w);
    }
    translate([0,0,fr+cr_lt-o-o])
     mirror_copy([1,0,0])
      translate([fr+cr_leg_w/2-o,0,0])
       rotate([0,90,90])
        fillet_linear(r=fr,l=cr_tab_w-cr_leg_w);
    translate([0,cr_tab_w/2-cr_leg_w/2,0])
     mirror_copy([0,1,0])
      mirror_copy([1,0,0])
       translate([fr,-cr_tab_w/2+cr_leg_w/2+o,fr+cr_lt-o-o])
        rotate([0,180,0]) fillet_polar(r=fr,R=-cr_leg_w/2+fr);
   }

   } // union add

   union () { // remove
    // JP2 clearance
    translate([52.5-1,cft_f2w+24.5-1,0.8]) cube([1+6+1,1+2+1+1,6.5]);
    // front edge corner chamfer to compensate for fdm printing corners excess extrusion
    //lfr = cr_lt/3;
    translate([cft_otw/2+fc,fc+lfr-cr_lt/3,-o])
     mirror_copy([1,0,0])
      translate([cft_otw/2-lfr+o,0,0])
       rotate([0,0,-90])
        fillet_linear(l=o+cr_lt+o,r=o+lfr+o);

        } // union remove
} // difference
} // retainer

// printable nail to take the place of a screw
// screw_d - screw diameter
// screw_fhr - flat head radius
// bch - bottom-side components height
// wt - wall thickness
module nail () {
  head_height = wt-fc;
  mirror_copy([1,0,0]) linear_extrude(nail_full_width)
    polygon([
     [0,0],
     [0,nail_length+head_height],
     [screw_fhr-fc,nail_length+head_height],
     [nail_full_width/2,nail_length],
     [nail_full_width/2,nail_length-fc-wt-bch-pcb_thickness-nail_grip_depth],
     [nail_tip_width/2,nail_tip_width/2]
    ]);
}

///////////////////////////////////////////////////////////////////////

// Makefile support - allow Makefile to generate STL for individual parts
// Rotate as appropriate for FDM printing
if(make=="top_cover") rotate([180,0,0]) top_cover();
else if(make=="bottom_cover") bottom_cover();
else if(make=="retainer") retainer();
else if(make=="nail") nail();
else if(make=="small_parts") {
        retainer();
        translate([nail_length+wt+cft_otw+1,-(screw_fhr+0.5)*3+cft_f2w+cft_d-cr_tab_w,0])
         rotate([0,0,90]) {
          mirror_copy([1,0,0])
           translate([screw_d+1,0,0])
            nail();
         translate([screw_d+1,0,0])
          mirror_copy([1,0,0])
           translate([screw_d+1,nail_length+screw_d/2-0.5,0])
            rotate([0,0,180])
             nail();
     }
}
else if(make=="display_1") { // show right-side up, front
    top_cover();
    translate ([px/2+cf_xc-cft_w/2,-f2w,iw_h-cr_top]) retainer();
    bottom_cover();
}
else if(make=="display_2") { // show upside-down, inside, retainer closed
  rotate([180,0,0]){
    top_cover();
    translate ([px/2+cf_xc-cft_w/2-fc,-f2w,iw_h-cr_top]) retainer();
    %bottom_cover();
  }
}
else if(make=="display_3") { // show upside-down, inside, retainer open
  rotate([180,0,0]){
    top_cover();
    rotate([0,2,13]) translate([4,-2.6,0.5]) translate ([px/2+cf_xc-cft_w/2,-f2w,iw_h-cr_top]) retainer();
    %bottom_cover();
  }
}
else if(make=="display_nail") {
  translate([0,nail_full_width/2,iw_h-nail_length+pcb_thickness+bch+wt-nail_grip_depth]) rotate([90,0,0])
   nail();
  %boss();
}
else {
  // Normal/Interactive
  //%pcb();
  translate([0,-0.3,0])
   %reader();
  top_cover();

  //%bottom_cover();
  //rotate([0,2,13]) translate([4,-2.6,0.5])  // rotate retainer to un-latched position
  translate ([px/2+cf_xc-cft_w/2,-f2w,iw_h-cr_top])
   retainer();
}
