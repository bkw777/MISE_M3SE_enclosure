// M1SE Enclosure - Top Cover
// b.kenyon.w@gmail.com

// PCB dimensions
// https://groups.yahoo.com/neo/groups/TRS80MISE/conversations/topics/157
//  >  All hole centers are 250 mils from card edges, drilled for 187 mil board feet.
//  >  "Short edge" holes centered 3815 mils apart.
//  >  "Long edge" holes centered 4770 mils apart.
//  >  Thus the PCB is 4315x5270 mils.
px = 133.858; // pcb x len
py = 109.601; // pcb y len
mi = 6.35;    // mounting holes inset from pcb edges

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
joy_w = 22.86;    // joystick width
joy_xc = -29.337; // pcb center to js center
                  // joystick bottom = pcb top
joy_f = 5.1;      // pcb front edge to joystick front

cf_h = 9.906;    // cf height
cf_w = 43.18;    // cf width
                 // cf top = inside top surface = iw_h
cf_xc = joy_xc;  // cf x center

// right wall holes
bus_w = 51.562; // bus cable width
bus_h = 6.35;   // bus cable height
bus_yc = -5.33; // pcb center to bus cable center
                // bus cable z bottom = ew_z bottom

pz = 1.8;      // pcb thickness
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
assert(r2w>=1,"r2w must be enough to allow the bus cable to fit between the pcb and the enclosure wall.");
b2w = nic_pcb_overhang;  // back  pcb edge to back  inside wall - must be nic_pcb_overhang or greater
assert(b2w>=nic_pcb_overhang,"b2w must be >= nic_pcb_overhang");

spor = 4.572; // screw post outside radius
spir = 1.8;   // screw post inside  radius

// tight cf tray
//cft_w = 47.117; // cf tray inside width
//cft_d = 27.178; // cf tray inside depth
// loose cf tray
cft_w = 47.3; // cf tray inside width
cft_d = 27.4; // cf tray inside depth

// This controls how far the CF cards stick out of the front of the enclosure.
// This can vary from 0 to almost 9 in theory. (at 9 you would need fingernails to get the CF cards out)
cft_f2w = 5.842;  // cf tray inside front to inside front wall
//cft_f2w = 0;
                  // cf tray X center = cf opening X center = js_xc
cft_wt = 2.4;     // cf tray wall thickness
cft_wh = 2.54;    // cf tray wall height

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
// 0 = square corners, 0.001 = inside square, outside round, >0 = round corners, >13 = invalid, hits pcb corners
cr = 6; // vertical corners inside radius

oc = 0.1;  // overcut - extend subtraction shapes past the edges of the shapes they cut from, to avoid making zero-thickness features
twt = 1.6; // tunnel wall thickness
p2t = 0.5; // any pcb edge pcb to any tunnel end

// cf bar slot
cfb2x = 2.54;
cfb2y = 14;
cfb2z = 14.48;
cfb2xloc = 5.14;
cfb2yloc = 2.54;

// smoother curves (less vibration while printing)
$fa = 0.5; // facet angle
$fs = 0.4; // facet size


///////////////////////////////////////////////////

module pcb() {
  translate([0,0,-pz]) difference(){
    cube([px,py,pz]);
    group(){
      translate([mi,mi,-oc]) cylinder(oc+pz+oc,spir,spir);
      translate([px-mi,mi,-oc]) cylinder(oc+pz+oc,spir,spir);
      translate([mi,py-mi,-oc]) cylinder(oc+pz+oc,spir,spir);
      translate([px-mi,py-mi,-oc]) cylinder(oc+pz+oc,spir,spir);
    }
  }
}

module walls() {
  difference() {
    group() { // add
      // exterior walls
      if(cr<=0) translate([-l2w-wt,-f2w-wt,-pz-bch-wt]) cube([ew_x,ew_y,ew_z]); // square corners
      else hull() {                                                             // round corners
        translate([-l2w+cr,-f2w+cr,-pz-bch-wt]) cylinder(ew_z,cr+wt,cr+wt);
        translate([px+r2w-cr,-f2w+cr,-pz-bch-wt]) cylinder(ew_z,cr+wt,cr+wt);
        translate([-l2w+cr,py+b2w-cr,-pz-bch-wt]) cylinder(ew_z,cr+wt,cr+wt);
        translate([px+r2w-cr,py+b2w-cr,-pz-bch-wt]) cylinder(ew_z,cr+wt,cr+wt);
      }

    } // add
    group() { // remove
      // interior walls
      if(cr<=0) translate([-l2w,-f2w,-pz-bch-wt-wt]) cube([iw_x,iw_y,ew_z]);  // square corners
      else hull() {                                                           // round corners
        translate([-l2w+cr,-f2w+cr,-pz-bch-wt-oc]) cylinder(ew_z-wt+oc,cr,cr);
        translate([px+r2w-cr,-f2w+cr,-pz-bch-wt-oc]) cylinder(ew_z-wt+oc,cr,cr);
        translate([-l2w+cr,py+b2w-cr,-pz-bch-wt-oc]) cylinder(ew_z-wt+oc,cr,cr);
        translate([px+r2w-cr,py+b2w-cr,-pz-bch-wt-oc]) cylinder(ew_z-wt+oc,cr,cr);
      }

      // holes in the walls
      translate([px/2+nic_xc-(nic_w/2),py+b2w-oc,nic_zt-nic_h]) cube([nic_w,oc+wt+oc,nic_h]); // nic opening
      translate([px/2+vga_xc-(vga_w/2),py+b2w-oc,vga_zb]) cube([vga_w,oc+wt+oc,vga_h]); // vga opening
      translate([px/2+pwr_xc,py+b2w-oc,pwr_zc]) rotate([-90,0,0]) cylinder(oc+wt+oc,pwr_r,pwr_r); // power opening
      translate([px/2+joy_xc-(joy_w/2),-f2w-wt-oc,0]) cube([joy_w,oc+wt+oc,joy_h]); // joystick opening
      translate([px/2+cf_xc-(cf_w/2),-f2w-wt-oc,iw_h-cf_h]) cube([cf_w,oc+wt+oc,cf_h]); // cf opening
      translate([px+r2w-oc,py/2+bus_yc-bus_w/2,-pz-bch-wt-oc]) cube([oc+wt+oc,bus_w,bus_h+oc]); // bus opening

    } // remove
  }
  // round the edge of the bus cable opening
  translate([px+r2w+wt/2,bus_w/2+py/2+bus_yc,-pz-bch-wt+bus_h]) rotate([90,0,0]) cylinder(oc+bus_w+oc,wt/2,wt/2,$fn=48);

}

module tunnels() {
  // CF tunnel is a special case and is defined in the cf_holder() module
  joy_t = f2w-joy_f-p2t; // joystick tunnel length
  difference() {
    group() {
      translate([px/2+vga_xc-(vga_w/2)-twt,py+p2t,vga_zb-twt]) cube([twt+vga_w+twt,b2w+oc-p2t,twt+vga_h+twt]); // vga opening
      translate([px/2+pwr_xc,py+p2t,pwr_zc]) rotate([-90,0,0]) cylinder(b2w+oc-p2t,pwr_r+twt,pwr_r+twt); // power opening
      translate([px/2+joy_xc-(joy_w/2)-twt,-f2w-oc,-twt]) cube([twt+joy_w+twt,joy_t+oc,twt+joy_h+twt]); // joystick opening
    }
    group() {
      translate([px/2+vga_xc-(vga_w/2),py-oc,vga_zb]) cube([vga_w,oc+wt+b2w+oc,vga_h]); // vga opening
      translate([px/2+pwr_xc,py-oc,pwr_zc]) rotate([-90,0,0]) cylinder(oc+wt+b2w+oc,pwr_r,pwr_r); // power opening
      translate([px/2+joy_xc-(joy_w/2),-f2w-wt-oc,0]) cube([joy_w,oc+wt+joy_t+oc,joy_h]); // joystick opening
    }
  }
}

module post() {
  difference() {
    group() {
      cylinder(iw_h+oc,spor,spor);
      // emulate a fillet with a few cones at different angles
      // to try to reduce stress risers to compensate for weak 3d printing
      translate([0,0,iw_h-3]) cylinder(3+oc,spor-oc,spor+3);
      translate([0,0,iw_h-4.5]) cylinder(4.5+oc,spor-oc,spor+2);
      translate([0,0,iw_h-6]) cylinder(6+oc,spor-oc,spor+1);
    }
    group() {
      cylinder(iw_h,spir,spir);
      // chamfer provides cavity for plastic displaced by the screw instead of mushrooming up the top surface
      translate([0,0,-oc]) cylinder(1.6+oc,spir+0.8,spir-0.8);
    }
  }
}

module posts() {
  translate([mi,mi,0]) post();
  translate([mi,py-mi,0]) post();
  translate([px-mi,mi,0]) post();
  translate([px-mi,py-mi,0]) post();
}

module cf_holder() {
  cft_ow = cft_wt+cft_w+cft_wt; // cf tray outer walls
  cft_otw = twt+cf_w+twt;       // cf tunnel outer walls

  cft_cny = 4.83;    // cf tray clearance notch, inner tray rear to notch side
  cft_cnl = 10.66;   // cf tray clearance notch, width
  cft_cnh = 1.27;    // cf tray clearance notch, floor height (top wall inner surface to notch floor)

  // cf bar pocket
  cfb1x = 2.54;
  cfb1y = 12;
  cfb1z = 2.54;
  cfb1xloc = 17.52;  // tray side to pocket side
  cfb1yloc = 2.54;   // tray rear to pocket rear

  translate([px/2+cf_xc,-f2w,iw_h+.001]) rotate([0,180,0]) difference(){
    group(){
      translate([-cft_otw/2,0,0]) cube([cft_otw,cft_f2w,cf_h+twt]); // tunnel
      translate([-cft_ow/2,cft_f2w,0]) cube([cft_ow,cft_d+cft_wt,cft_wh]); // tray

      // bar closed end pocket
      translate([-cfb1x-2.54-cft_w/2-cfb1xloc,cft_f2w+cft_d-cfb1y-cfb1yloc-4,0]) cube([cfb1x+2.54,4+cfb1y+4,cfb1z+2]);

      // bar open end slot
      translate([cft_w/2+cfb2xloc,cft_f2w+cft_d-cfb2y+cfb2yloc-2,0]) cube([cfb2x+2.54,cfb2y+2,cfb2z]);

      // bar front lip
      translate([-cft_otw/2,0,cf_h+twt-.001]) cube([cft_otw,cft_f2w+3,twt]);

    }
    group(){
      translate([-cf_w/2,-oc,-oc]) cube([cf_w,oc+cft_f2w+oc,cf_h+oc]); // tunnel
      translate([-cft_w/2,cft_f2w,-oc]) cube([cft_w,cft_d,oc+cft_wh+oc]); // tray

      // knock out the inside corners of the tray to compensate for imperfect 3d-printing
      translate([cft_w/2-1,cft_f2w+cft_d-1,-oc]) cube([cft_wt+2,cft_wt+2,oc+cft_wh+oc]);
      translate([-cft_w/2-cft_wt-1,cft_f2w+cft_d-1,-oc]) cube([cft_wt+2,cft_wt+2,oc+cft_wh+oc]);
      translate([-cft_w/2-cft_wt-oc,cft_f2w-oc,-oc]) cube([oc+cft_wt+oc,1+oc,oc+cft_wh+oc]);
      translate([cft_w/2-oc,cft_f2w-oc,-oc]) cube([oc+cft_wt+oc,1+oc,oc+cft_wh+oc]);

      // notch to clear some components on cf reader pcb
      translate([-cft_w/2-cft_wt-oc,cft_f2w+cft_d-cft_cnl-cft_cny,cft_cnh]) cube([oc+cft_wt+oc,cft_cnl,cft_wh-cft_cnh+oc]);

      // bar closed end pocket
      translate([-cfb1x-cft_w/2-cfb1xloc,cft_f2w+cft_d-cfb1y-cfb1yloc,0]) cube([cfb1x+oc,cfb1y,cfb1z]);

      // bar open end slot
      // this has to be done out in main() instead of here,
      // if you want it to cut into screw post
      //translate([cft_w/2+cfb2x+cfb2xloc-0.001,cft_f2w+cft_d+cfb2yloc+0.001,8.636]) rotate([90,0,-90]) linear_extrude(cfb2x) polygon([ [0,0],[0,3.56],[1.14,2.54],[2.67,2.54],[3.81,3.56],[cfb2y,3.56],[cfb2y,0] ]);

    }
  }
}

//
// main
//
union() { // all
  %#pcb();
  difference(){
    group(){
      walls();
      tunnels();
      posts();
      cf_holder();
    }
    group(){
      // bar open end slot
      translate([-cfb2x+px/2+cf_xc-cft_w/2-cfb2xloc+.001,-f2w+cft_f2w+cft_d+cfb2yloc+.001,+iw_h-8.636]) rotate([-90,0,-90]) linear_extrude(cfb2x) polygon([ [0,0],[0,3.56],[1.14,2.54],[2.67,2.54],[3.81,3.56],[cfb2y,3.56],[cfb2y,0] ]);
    }
  }
} // all
