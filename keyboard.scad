include<swappable.scad>

thickness = 1.5;

pos_vec = [
	[[27, 59, 0], [44, 67, 0], [61, 74, 0], [79, 78, 0]], // bottom
	[[27, 59, 0], [44, 68.5, 0], [62, 76, 0], [80.5, 80.5, 0]], // middle
	[[27, 59, 0], [45, 69, 0], [65, 78, 0], [85, 83, 0]], // top
	[[7.5, 6, 0], [20, 26, 0], [41, 35, 0]] // thumb
];
ofs_vec = [
	[-0.5, -2, 0], // bottom
	[-8, 20, 0], // middle
	[-18, 40, 0], //top
	[0, 0, 0] // thumb
];

angle_vec = [
	[[-8, 0, 17], [-10, 0, 16], [-12, 0, 15], [-14, 0, 14]], // bottom
	[[0, 0, 28], [0, 0, 24], [0, 0, 17], [0, 0, 14]], // middle
	[[10, 0, 32], [12, 0, 26], [12, 0, 20], [14, 0, 13]], // top
	[[0, 0, 63], [0, 0, 39], [0, 0, 15]] //thumb
];

height_vec = [
	[1, 1, 2, 3],
	[1, 1, 2, 3],
	[1, 1, 2, 3],
	[2, 2, 2]
];

module Switchies(is_mock=true) {
	if(len(pos_vec) == len(ofs_vec)) {
		for(i = [0 : len(pos_vec)-1]) {
			ofs = ofs_vec[i];
			for(j = [0 : len(pos_vec[i])-1]) {
				pos = pos_vec[i][j];
				if(is_mock) {
					translate(pos + ofs) circle(2);
				} else {
					angle = angle_vec[i][j];
					height = height_vec[i][j];
					translate(pos + ofs) rotate([0, 0, angle[2]]) SwitchBlock(height, angle[0]);
				}
			}
		}
	}
}

module SwitchBaseWrapper() {
	switch_base_w = 14;
	switch_base_thickness = 2.4;
	delta = 2;
	w = switch_base_w + delta;
	difference() {
		cube([w, switch_base_w, switch_base_thickness/2]);
		translate([delta/2, delta/2, 0])
			cube([switch_base_w, switch_base_w, switch_base_thickness/2]);
	}
	translate([delta/2, 0, 0])
		SwitchBase();
}

module SwitchBlock(height=4, angle=15) {
	switch_base_w = 14;
	switch_base_thickness = 2.4;
	delta = 2;
	w = switch_base_w + delta;
	depth = w * cos(angle);

	module Base() {
		module EmptyCube(cube_h=height)
			difference() {
				cube([w, depth, cube_h]);
				translate([delta/2, delta/2, 0])
					cube([switch_base_w, depth-delta, cube_h]);
			};
		module TopTri() {
			tri_depth = sqrt(depth^2 + (depth*sin(angle))^2);
			color("yellowgreen")
				translate([0, 0, height])
					if(angle < 0) {
							difference() {
								EmptyCube(w * sin(-angle));
								translate([0, depth, 0])
									rotate([angle, 0, 0])
									translate([0, -tri_depth, 0])
									cube([w, tri_depth, w*sin(-angle)]);
							}
					} else {
							difference() {
								EmptyCube(w * sin(angle));
								rotate([angle, 0, 0])
									cube([w, tri_depth, w*sin(angle)]);
							}
					}
		}
		module TopPick() {
			pick_depth = sqrt(depth^2 + (depth*sin(angle))^2);
			translate([0, 0, height])
			if(angle < 0) {
				translate([0, depth, 0])
					rotate([angle, 0, 0])
					translate([0, -pick_depth, 0])
					difference() {
						cube([w, w, switch_base_thickness/2]);
						translate([0, delta/2, 0])
						cube([w, switch_base_w, switch_base_thickness/2]);
					}
			} else {
				rotate([angle, 0, 0])
					difference() {
						cube([w, w, switch_base_thickness/2]);
						translate([0, delta/2, 0])
						cube([w, switch_base_w, switch_base_thickness/2]);
					}
			}
		}
		color("plum")
			EmptyCube();
		TopTri();
		TopPick();
	}

	translate([-w/2, -depth/2, 0]) {
		Base();
	}
}

module PlateHoles() {
	switch_base_w = 14;
	switch_base_thickness = 2.4;
	delta = 2;
	w = switch_base_w + delta;

	if(len(pos_vec) == len(ofs_vec)) {
		for(i = [0 : len(pos_vec)-1]) {
			ofs = ofs_vec[i];
			for(j = [0 : len(pos_vec[i])-1]) {
				pos = pos_vec[i][j];
				angle = angle_vec[i][j];
				translate(pos + ofs)
					rotate([0, 0, angle[2]])
					square([switch_base_w, switch_base_w*cos(angle[0])], center=true);
			}
		}
	}
}

module KeyBoard() {
	switches_pos_ofs = [18, -62, thickness];
	x = 0.046;

	difference() {
		union() {
			translate(switches_pos_ofs) color("orange") Switchies(false);
			linear_extrude(thickness)
					intersection() {
						translate([0, -100, 0])square(200);
						rotate([0, 0, 13]) translate([-90, -100, 0]) square(200);
						difference() {
							scale([x, x]) import("keyboard.svg", center=true);
							translate(switches_pos_ofs) PlateHoles();
						}
					}
		}
		Joints();
	}
}

module Joint(length=30) {
	radius = 5;
	color("orange")
	linear_extrude(thickness)
	union() {
		square([length-radius/2, radius], true);
		translate([length/2 - radius, 0]) circle(radius);	
		translate([-(length/2 - radius), 0]) circle(radius);	
	}
}

module Joints(n=1) {
	translate([0, 20, 0])Joint();
	Joint();
	translate([0, -20, 0])Joint();
	translate([0, -40, 0])Joint();
}


//translate([-17, 0])Joints();
KeyBoard();
//translate([10, 0, 0])SwitchBaseWrapper();
//SwitchBlock();
