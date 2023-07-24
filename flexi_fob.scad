/*
    Flexi Fob v0.1

        BOSL2 Library is included with this file available from https://github.com/BelfrySCAD/BOSL2/

        flexi_fob.scad © 2023 by Snowball's Chance is licensed under CC BY-SA 4.0.
        To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/

        // a very minor update
*/

// Libraries
include <BOSL2/std.scad>

// This hidden section does not appear in the customiser
/* [Hidden] */
model_name = "Flexi Fob";
model_version = "v0.1";
lowres = 30;
hires = 360;
$fn = $preview ? lowres : hires; // Enables lowres for preview and super hires for render.
$slop = 0.3;                     // provided by BOSL2. To access the current value x = get_slop();

/* [Settings] */

do_hat = true;
do_keyring_hole = true;
do_chamfer = true;
rfid_diameter = 25.4;   //0.1
rfid_thickness = 0.6;   //0.2
bottom_thickness = 0.6; //0.2
top_thickness = 0.6;  //0.2
wall_thickness = 2; //0.1

module __Customizer_Limit__()
{
} // end module __Customizer_Limit__

rfid_r = rfid_diameter / 2;
chamfer_size = do_chamfer ?  top_thickness + bottom_thickness : undef;  // using undef causes the cyl operator to act as if chamfer was never requested, if 0 then chamfer is built but may error


// display model settings
echo();
echo(model_name = model_name, model_version = model_version);
echo(do_hat = do_hat, do_keyring_hole = do_keyring_hole, do_chamfer = do_chamfer);
echo(rfid_diameter = rfid_diameter, rfid_thickness = rfid_thickness, bottom_thickness = bottom_thickness, top_thickness = top_thickness, wall_thickness = wall_thickness );
echo();

diff()
  {
    cyl(r = rfid_r + get_slop() + wall_thickness, h = top_thickness + bottom_thickness + rfid_thickness, chamfer2 = chamfer_size  );  // main body

    if (do_hat)
      back(10.5)
        cyl(r = (rfid_r + get_slop()) / 1.8 + wall_thickness, h = top_thickness + bottom_thickness + rfid_thickness, chamfer2 = chamfer_size);  // hat

    tag("remove")
      {
        if (do_keyring_hole)
          back(15.9)
            yrot(90)
              cyl(r = 1.6, h=9, rounding = 1.49);  //keyring_hole

        cyl(r = rfid_r + get_slop(), h = rfid_thickness);  // make the void for the RFID tag
        
        *left(20) down(10)   // for testing. Cuts model in half so the void can be observed
            cube(40);

      } //end tag remove
  } // end_diff