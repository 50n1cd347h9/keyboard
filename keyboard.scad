include<swappable.scad>

module SwitchPos(is_mock=true) {
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
		[], // bottom
		[], // middle
		[], // top
		[] //thumb
	];

	if(len(pos_vec) == len(ofs_vec)) {
		for(i = [0 : len(pos_vec)-1]) {
			ofs = ofs_vec[i];
			for(j = [0 : len(pos_vec[i])-1]) {
				pos = pos_vec[i][j];
				if(is_mock) {
					translate(pos + ofs) circle(2);
				} else {
					translate(pos + ofs) rotate([0, 0, 0]) SwitchBlock();
				}
			}
		}
	}
}


module SwitchBlock(height=4, angle=5) {
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
				EmptyCube(w * sin(angle));
				rotate([angle, 0, 0])
					cube([w, depth, w*sin(angle)]);
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
			rotate([angle, 0, 0])
			WrappedSwitchBase();
		Base();
	}
}


module KeyBoard() {
	thickness = 3;
	translate([18, -62, thickness]) SwitchPos(false);
	
	linear_extrude(thickness)
	intersection() {
		x = 0.046;
		translate([0, -100])square(200);
		scale([x, x]) import("keyboard.svg", center=true);
	}
}

translate([0, 0, -5])KeyBoard();
