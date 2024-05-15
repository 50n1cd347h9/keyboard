include<swappable.scad>
pos_vec = [
	[[27, 59, 0], [55, 70, 0], [80, 78, 0], [110, 79, 0]], // bottom
	[[27, 59, 0], [50, 70, 0], [74, 79, 0], [102, 82, 0]], // middle
	[[27, 59, 0], [46, 71, 0], [72, 80, 0], [99, 85, 0]], // top
	[[7.5, 6, 0], [20, 26, 0], [43, 36, 0]] // thumb
];
ofs_vec = [
	[0, 0, 0], // bottom
	[-8, 19, 0], // middle
	[-20, 38, 0], //top
	[0, 0, 0] // thumb
];

angle_vec = [
	[[-8, 0, 22], [-10, 0, 32], [-12, 0, 33], [-14, 0, 35]], // bottom
	[[0, 0, 28], [0, 0, 36], [0, 0, 35], [0, 0, 35]], // middle
	[[10, 0, 32], [12, 0, 38], [12, 0, 35], [14, 0, 33]], // top
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
		color("plum")
			EmptyCube();

		color("yellowgreen")
			translate([0, 0, height])
			difference() {
				if(angle < 0) {
					EmptyCube(w * sin(-angle));
				} else {
					EmptyCube(w * sin(angle));
				}
				if(angle < 0) {
					translate([0, depth, 0])
						rotate([angle, 0, 0])
						translate([0, -depth, 0])
						cube([w, depth, w*sin(-angle)]);
				} else {
					rotate([angle, 0, 0])
						cube([w, depth, w*sin(angle)]);
				}
			}
	}
	module WrappedSwitchBase() {
		difference() {
			cube([w, w, switch_base_thickness/2]);
			translate([delta/2, delta/2, 0])
				cube([switch_base_w, switch_base_w, switch_base_thickness/2]);
		}
		translate([delta/2, delta/2, 0])
			SwitchBase();
	}

	translate([-w/2, -depth/2, 0]) {
		translate([0, 0, height])
			if(angle < 0) {
				translate([0, w*cos(angle), 0])
					rotate([angle, 0, 0])
					translate([0, -w, 0])
					WrappedSwitchBase();
			} else {
				rotate([angle, 0, 0])
					WrappedSwitchBase();
			}
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
				translate(pos + ofs) rotate([0, 0, angle[2]]) square(switch_base_w*cos(angle[0]), center=true);
			}
		}
	}
}

module KeyBoard() {
	thickness = 3;
	switches_pos_ofs = [18, -62, thickness];
	x = 0.046;

	translate(switches_pos_ofs)color("cyan") Switchies(false);

	linear_extrude(thickness)
		intersection() {
			translate([0, -100])square(200);
			difference() {
				scale([x, x]) import("keyboard.svg", center=true);
				translate(switches_pos_ofs) PlateHoles();
			}
		}
}

//PlateHoles();
//SwitchBlock();
KeyBoard();
