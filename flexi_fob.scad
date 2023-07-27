/*

    Flexi Fob v0.1.1

        BOSL2 Library is included with this file available from https://github.com/BelfrySCAD/BOSL2/

        flexi_fob © 2023 by Snowball's Chance is licensed under CC BY-SA 4.0.
        To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/

         Remixing encouraged - attribution appreciated.

    HISTORY:
    v0.1 - initial release
    v0.1.1 - added chamfer selection upper, lower, both or none.

*/

// Libraries
include <BOSL2/std.scad>

// This hidden section does not appear in the customiser
/* [Hidden] */
model_name = "Flexi Fob";
model_version = "v0.1.1";
lowres = 30;
hires = 180;
$fn = $preview ? lowres : hires; // Enables lowres for preview and super hires for render.
$slop = 0.125;                     // provided by BOSL2. To access the current value x = get_slop();

/* [Settings] */
do_hat = false;
do_keyring_hole = false;
do_chamfer = "u";   //  [u:upper, l:lower, b:both, r:round, n:none] 
rfid_diameter = 25.4;   //0.1
rfid_thickness = 0.8;   //0.2
bottom_thickness = 0.6; //0.2
top_thickness = 0.6;  //0.2
wall_thickness = 2; //0.1

module __Customizer_Limit__()
{
} // end module __Customizer_Limit__

rfid_r = rfid_diameter / 2;
ch_up_low = top_thickness + bottom_thickness;
ch_both = (top_thickness + bottom_thickness / 2) - 0.2;
fob_thickness = top_thickness + bottom_thickness + rfid_thickness;
fob_diameter = rfid_diameter + get_slop() * 2 + wall_thickness * 2;
fob_radius = fob_diameter / 2;
hat_diameter = fob_diameter * 0.75;
hat_radius = hat_diameter / 2;


// display model settings
echo();
echo(model_name = model_name, model_version = model_version);
echo(do_hat = do_hat, do_keyring_hole = do_keyring_hole, do_chamfer = do_chamfer);
echo(rfid_diameter = rfid_diameter, rfid_thickness = rfid_thickness, bottom_thickness = bottom_thickness, top_thickness = top_thickness, wall_thickness = wall_thickness );
echo(do_chamfer = do_chamfer);
echo( ch_both = ch_both, ch_up_low = ch_up_low);
echo("\n");

render(2)
    diff()
      {

        if (do_chamfer == "n")
          cyl(r = fob_radius, h = top_thickness + bottom_thickness + rfid_thickness );  // main body
        
        if (do_chamfer == "u")
          cyl(r = rfid_r + get_slop() + wall_thickness, h = top_thickness + bottom_thickness + rfid_thickness, chamfer2 = ch_up_low );  // main body

        if (do_chamfer == "l")
          cyl(r = rfid_r + get_slop() + wall_thickness, h = top_thickness + bottom_thickness + rfid_thickness, chamfer1 = ch_up_low );  // main body

        if (do_chamfer == "b")
          cyl(r = rfid_r + get_slop() + wall_thickness, h = top_thickness + bottom_thickness + rfid_thickness, chamfer1 = ch_both, chamfer2 = ch_both );  // main body

        if (do_chamfer == "r")
          {
            cyl(r = fob_radius - fob_thickness, h = fob_thickness);  // main body
            rotate_extrude(convexity = 10)
            translate([fob_radius - fob_thickness, 0, 0])
            circle(d = top_thickness + bottom_thickness + rfid_thickness);
          }



        if (do_hat)
          {
            back(rfid_diameter * 0.3)
              {
                // cyl(r = (rfid_r + get_slop()) / 1.8 + wall_thickness, h = top_thickness + bottom_thickness + rfid_thickness, chamfer1 = ch_up_low, chamfer2 = ch_up_low);  // hat

                if (do_chamfer == "n")
                  cyl(r = hat_radius, h = fob_thickness); // hat

                if (do_chamfer == "u")
                  cyl(r = hat_radius, h = fob_thickness, chamfer2 = ch_up_low);  // hat

                if (do_chamfer == "l")
                  cyl(r = hat_radius, h = fob_thickness, chamfer1 = ch_up_low);  // hat

                if (do_chamfer == "b")
                  cyl(r = hat_radius, h = fob_thickness, chamfer1 = ch_both, chamfer2 = ch_both);  // hat
                if (do_chamfer == "r")
                    {
                      cyl(r = hat_radius - fob_thickness, h = fob_thickness); // hat
                      rotate_extrude(convexity = 10)
                      translate([hat_radius - fob_thickness, 0, 0])
                      circle(d = top_thickness + bottom_thickness + rfid_thickness);
                    }  //  end if do_chamfer = r
              } // end_back

          }  //  end if do_hat 





        tag("remove")
          {
            if (do_keyring_hole)
              back(fob_radius)
                yrot(90)
                  cyl(r = 1.6, h=9, rounding = 1.49);  //keyring_hole

            cyl(r = rfid_r + get_slop() * 2, h = rfid_thickness);  // make the void for the RFID tag
            
            *left(20) down(10)   // for testing. Cuts model in half so the void can be observed
                cube(40);

          } //end tag remove
    } // end_diff