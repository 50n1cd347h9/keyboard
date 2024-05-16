include<swappable.scad>

plate_scale = 0.046;
plate_thickness = 1.5;
switch_base_w = 14;
switch_block_wall_thickness = 2;
wall_and_block_depth = switch_base_w + switch_block_wall_thickness;
switchies_pos = [45, -5, plate_thickness];
thumb_switchies_pos = [23, -50, plate_thickness];
switchies_pos_ofs = [45, -5, plate_thickness];
thumb_pos_ofs = [23, -50, plate_thickness];
switchies_angle = [0, 0, 20];
thumb_switchies_angle = [0, 0, 35];
ofs_vec = [
	[[0, 0], [0, 0], [0, 0]],// col0
	[[0, 0], [0, 0], [0, 0]],// col1
	[[0, 0], [0, 0], [0, 0]],// col2
	[[0, 0], [0, 0], [0, 0]],// col3
	[[0, 0], [0, 0], [0, 0]],// col4
];
y_ofs_vec = [0, 1.5, -1, -3, -9];
space_within_switches = [18, 18, 0];
angle_vec = [
	[[30, 0, 0], [0, 0, 0], [0, 0, 0]],// col0
	[[0, 0, 0], [0, 0, 0], [0, 0, 0]],// col1
	[[0, 0, 0], [0, 0, 0], [0, 0, 0]],// col2
	[[0, 0, 0], [0, 0, 0], [0, 0, 0]],// col3
	[[0, 0, 0], [0, 0, 0], [0, 0, 0]],// col4
];
height_vec = [
	[2, 1, 1],
	[1, 1, 1],
	[1, 1, 1],
	[1, 1, 1],
	[1, 1, 1],
];
thumb_ofs_vec = [
	[0, 0],
	[0, 0],
	[0, 0]
];
thumb_angle_vec = [
	[0, 0, 0],
	[0, 0, 0],
	[0, 0, 0]
];
thumb_height_vec = [1, 1, 1];
space_within_thumb_switches = 20;
switch_base_thickness = 2.4;

module MockKeySwitch() {
}

module Switchies(is_mock=true) {
	if(len(ofs_vec)) {
		for(i = [0 : len(ofs_vec)-1]) {
			for(j = [0 : len(ofs_vec[i])-1]) {
				x = space_within_switches[0] * i;
				y = space_within_switches[1] * j + y_ofs_vec[i];
				ofs = ofs_vec[i][j];	
				if(is_mock) {
					translate([x, y] + ofs) circle(2);
				} else {
					angle = angle_vec[i][j];
					height = height_vec[i][j];
					translate([x, y] + ofs)
						rotate([0, 0, angle[2]])
							SwitchBlock(height, angle[0]);
				}
			}	
		}
	}
}

module ThumbSwitchies(is_mock=true) {
	if(len(thumb_ofs_vec)) {
		for(i = [0 : len(thumb_ofs_vec)-1]) {
			x = space_within_thumb_switches * i;
			ofs = thumb_ofs_vec[i];
			if(is_mock) {
				translate([x, 0] + ofs) circle(2);
			} else {
				angle = thumb_angle_vec[i];
				height = thumb_height_vec[i];
				translate([x, 0] + ofs)
					rotate([0, 0, angle[2]])
						SwitchBlock(height, angle[0]);
			}
		}
	}	
}

module SwitchBaseWrapper() {
	w = switch_base_w + switch_block_wall_thickness;
	difference() {
		cube([w, switch_base_w, switch_base_thickness/2]);
		translate([switch_block_wall_thickness/2, switch_block_wall_thickness/2, 0])
			cube([switch_base_w, switch_base_w, switch_base_thickness/2]);
	}
	translate([switch_block_wall_thickness/2, 0, 0])
		SwitchBase();
}

module SwitchBlock(height=4, angle=15) {
	block_depth = wall_and_block_depth * cos(angle);

	module EmptyCube(cube_h=height)
		difference() {
			cube([wall_and_block_depth, block_depth, cube_h]);
			translate([switch_block_wall_thickness/2, switch_block_wall_thickness/2, 0])
				cube([switch_base_w, block_depth - switch_block_wall_thickness, cube_h]);
		};

	module TopTri() {
		tri_depth = sqrt(block_depth^2 + (block_depth*sin(angle))^2);
		color("yellowgreen")
			translate([0, 0, height])
				if(angle < 0) {
						difference() {
							EmptyCube(wall_and_block_depth * sin(-angle));
							translate([0, block_depth, 0])
								rotate([angle, 0, 0])
								translate([0, -tri_depth, 0])
								cube([wall_and_block_depth, tri_depth, wall_and_block_depth*sin(-angle)]);
						}
				} else {
						difference() {
							EmptyCube(wall_and_block_depth * sin(angle));
							rotate([angle, 0, 0])
								cube([wall_and_block_depth, tri_depth, wall_and_block_depth*sin(angle)]);
						}
				}
	}

	module BaseMountPick() {
		pick_depth = sqrt(block_depth^2 + (block_depth*sin(angle))^2);
		translate([0, 0, height])
		if(angle < 0) {
			translate([0, block_depth, 0])
				rotate([angle, 0, 0])
				translate([0, -pick_depth, 0])
				difference() {
					cube([wall_and_block_depth, wall_and_block_depth, switch_base_thickness/2]);
					translate([0, switch_block_wall_thickness/2, 0])
					cube([wall_and_block_depth, switch_base_w, switch_base_thickness/2]);
				}
		} else {
			rotate([angle, 0, 0])
				difference() {
					cube([wall_and_block_depth, wall_and_block_depth, switch_base_thickness/2]);
					translate([0, switch_block_wall_thickness/2, 0])
					cube([wall_and_block_depth, switch_base_w, switch_base_thickness/2]);
				}
		}
	}

	module Base() {
		color("plum")
			EmptyCube();
		TopTri();
		BaseMountPick();
	}

	translate([-wall_and_block_depth/2, -block_depth/2, 0]) {
		Base();
	}
}

module PlateHoles() {
	switch_block_wall_thickness = 2;
	w = switch_base_w + switch_block_wall_thickness;
	translate(switchies_pos)
		rotate(switchies_angle) {
			if(len(ofs_vec)) {
				for(i = [0 : len(ofs_vec)-1]) {
					for(j = [0 : len(ofs_vec[i])-1]) {
						x = space_within_switches[0] * i;
						y = space_within_switches[1] * j + y_ofs_vec[i];
						ofs = ofs_vec[i][j];	
						angle = angle_vec[i][j];
						height = height_vec[i][j];
						translate([x, y] + ofs)
							rotate([0, 0, angle[2]])
								square([switch_base_w, switch_base_w*cos(angle[0])], center=true);
					}	
				}
			}
		}
	translate(thumb_switchies_pos)
		rotate(thumb_switchies_angle) {
			if(len(thumb_ofs_vec)) {
				for(i = [0 : len(thumb_ofs_vec)-1]) {
					x = space_within_thumb_switches * i;
					ofs = thumb_ofs_vec[i];
					angle = thumb_angle_vec[i];
					height = thumb_height_vec[i];
					translate([x, 0] + ofs)
						rotate([0, 0, angle[2]])
							square([switch_base_w, switch_base_w*cos(angle[0])], center=true);
				}
			}	
		}
}

module KeyBoard() {
	difference() {
		union() {
			color("orange")
				union() {
					translate(switchies_pos)
						rotate(switchies_angle)
						Switchies(false);
					translate(thumb_switchies_pos)
						rotate(thumb_switchies_angle)
						ThumbSwitchies(false);
				}
			linear_extrude(plate_thickness)
					intersection() {
						translate([0, -100, 0])square(200);
						difference() {
							scale([plate_scale, plate_scale]) import("keyboard.svg", center=true);
							PlateHoles();
						}
					}
		}
		Joints();
	}
}

module Joint(length=30) {
	radius = 5;
	color("orange")
	linear_extrude(plate_thickness)
	union() {
		square([length-radius/2, radius], true);
		translate([length/2 - radius, 0]) circle(radius, $fn=64);	
		translate([-(length/2 - radius), 0]) circle(radius, $fn=64);	
	}
}

module Joints(n=1) {
	translate([0, 20, 0])Joint();
	Joint();
	translate([0, -20, 0])Joint();
	translate([0, -40, 0])Joint();
}

KeyBoard();
