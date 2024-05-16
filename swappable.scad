module Pick() {
	difference() {
		cube([20, 20, 5]);
		translate([0, 1.5, 0]) {
			cube([20, 17, 3.5]);
			translate([0, 1.5, 0]) {
				cube([20, 14, 5]);
			}
		}
	}

}

module Circle(dia) circle(d=dia, $fn=10);
module Circle1() Circle(4.2);
module Circle2() Circle(1.5); // switch pin
module Circle3() Circle(1.9);
module BaseHoles() {
	Circle1();
	translate([-3.81, 2.54, 0])
		Circle2();
	translate([2.54, 5.08, 0])
		Circle2();
	translate([5.08, 0, 0])
		Circle3();
	translate([-5.08, 0, 0])
		Circle3();
}
module SwitchBase () {
	thickness = 2.4;
	wire_thickness = 0.8;
	diode_length = 4;
	diode_thickness = 2;

	module Path(length) {
		translate([length/2, 0, wire_thickness/2])
			cube([length, wire_thickness, wire_thickness], true);
		children();
	}
	module DiodeWirePath(length) {
		translate([0, 0, diode_thickness/2 - wire_thickness/2]) Path(length);
		translate([0, 0, 0]) Path(length);
		children();
	}
	module Diode()
		translate([diode_length/2 + 1.4, 0, diode_thickness/2])
			cube([diode_length, diode_thickness + 0.7, diode_thickness], true);

	difference() {
		linear_extrude(thickness)
			difference() {
				square(14, false);
				translate([7, 7, 0]) {
					BaseHoles();
					translate([-2, -7, 0])
						square([4, 7]);
				}
			}

		translate([7, 7, 0])
			translate([0, 0, thickness])
				mirror([0, 0, 1]) {
					translate([2.54, 5.08, 0]) {
						rotate([0, 0, -85]) {
							Diode();
							DiodeWirePath(15) {
								translate([8, 0, 0])
									linear_extrude(3)
										Circle(1.5);
								translate([10.5, 0, 0])
									linear_extrude(3)
										Circle(1.5);
							}
						}

						rotate([0, 0, 180])
							Path(3)
								translate([3, 0, 0])
									linear_extrude(3)
										Circle(1.5);
					}

					translate([-3.81, 2.54, 0])
						rotate([0, 0, 180])
							Path(2.5)
								translate([2.3, 0, 0])
									linear_extrude(5)
										Circle(1.5);

					translate([-3.81, -7, 0])
						rotate([0, 0, 90])
							Path(14) 
								translate([12, 0, 0])
									linear_extrude(5)
										Circle(1.5);
				}
	}
}
