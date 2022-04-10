// USER_DEFINABLE PARAMETERS

hex_width = 32.75; // cca 25.4*1.25
hex_height = 6;
inner_width = hex_width-1.6;
inner_height = 3;

base_width1 = 30.25;
base_width2 = 27.25;
base_height = 4;

ball_diameter = 3;

trees = 3;
tree_diameter = 2.5;
tree_height = 44;
treetop_diameter = 25;

text_line1 = "heavy";
text_line2 = "woods";

// CALCULATED PARAMETERS

W = hex_width;
H = hex_height;

WI = inner_width;
HI = inner_height;

rB = base_width2/base_width1;
WB = base_width1;
HB = base_height;
R = ball_diameter/2;
RT = tree_diameter/2;

$fn = 40;

module hexagon(smaller_width)
{
    width = smaller_width/cos(30)/2;
    polygon(points=[
        for (it=[1:6])
            let(dang = 360/6)
            [width*cos(it*dang), width*sin(it*dang)]
    ]);
}

module tree()
{
    color("BurlyWood")
    cylinder(h = tree_height-0.1, r = RT);
    color("ForestGreen")
    translate([0, 0, tree_height-treetop_diameter/2])
    sphere(treetop_diameter/2);
}

module bottom_part()
{
    color("DarkGreen")
    difference()
    {
        linear_extrude(H)
        hexagon(W);
        
        translate([0,0,H-inner_height])
        linear_extrude(H)
        hexagon(WI);
        
        for (it=[1:6])
            let(dang = 360/6)
            translate([(W/2-R)*cos(it*dang+dang/2), (W/2-R)*sin(it*dang+dang/2), R])
            sphere(R+0.2);
    
        translate([0, 0, R])
        sphere(R+0.2);
        
        translate([0,W/10,H-inner_height-0.5])
        linear_extrude(1)
        text(text_line1, size=W/6, halign="center", valign="bottom");
        
        translate([0,-W/10,H-inner_height-0.5])
        linear_extrude(1)
        text(text_line2, size=W/6, halign="center", valign="top");
    }
}

module magnets()
{
    color("Gray")
    for (it=[1:6])
        let (dang = 360/6)
        translate([(W/2-R)*cos(it*dang+dang/2), (W/2-R)*sin(it*dang+dang/2), R])
        sphere(R);
    
    color("Gray")
    translate([0, 0, R])
    sphere(R);
}

module top_part()
{
    color("SpringGreen")
    translate([0, 0, H-inner_height])
    difference()
    {
        linear_extrude(base_height, scale=rB
        )
        hexagon(WB);
        
//        translate([0,0,-1])
//        linear_extrude(2, scale=0.92)
//        hexagon(WB-0.5);
        
        if (trees > 1)
            for (it=[1:trees])
                let (dang = 360/trees)
                translate([(1.1*W/4)*cos(it*dang+dang/3), (1.1*W/4)*sin(it*dang+dang/3), -0.1])
                cylinder(h = H, r = RT);
        else
            translate([0, 0, -0.1])
            cylinder(h = H, r = RT);
        
        translate([0, 0, R])
        sphere(R+0.2);
    }
}

module trees()
{
    for (it=[1:trees])
        let (dang = 360/trees)
        translate([(1.1*W/4)*cos(it*dang+dang/3), (1.1*W/4)*sin(it*dang+dang/3), H-inner_height])
        tree();
}

// select only the module that you want to export here
bottom_part();
magnets();
top_part();
trees();
