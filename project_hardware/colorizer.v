//////////////////////////////////////////////////////////////////////////////////
// Company: Portland State University
// Engineer:Andrew Capatina Ryan Bornhorst 
// 
// Create Date: 02/14/2019 04:29:22 PM
// Design Name: Rojobot Emulator
// Module Name: colorizer
// Project Name: Project 2
// Target Devices: Nexys A7
// Tool Versions: 
// Description: 
//      Module for outputting RGB values for the display. 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//	Module outputs color display signals to a VGA port when video_on
//	signal is high.  2 bit pixel colors are received from the map and 
//	icon modules and their output colors are encoded.  
//////////////////////////////////////////////////////////////////////////////////


module colorizer(
    input               video_on,		// display enable		
    input 	[1:0]	world, icon,		// world/icon pixel
    output reg 	[3:0]   red, blue, green	// VGA r,g,b
    );
    
    // all the possible color combinations
    parameter blk = 12'b0000_0000_0000; // black line
    parameter blu = 12'b0000_1111_0000; // blue icon
    parameter rd  = 12'b1111_0000_0000; // red icon
    parameter grn = 12'b0000_0000_1111; // green obstacle
    parameter clr = 12'b1111_1111_1111; // clear background
    parameter yel = 12'b1111_0000_1111; // yellow icon
    
    always@(*)
    // encode VGA r,g,b output colors based {world, icon} input
    if(video_on == 1)
        case({world,icon})
            4'b0000: {red,blue,green} = clr;
            4'b0001: {red,blue,green} = blu;
            4'b0010: {red,blue,green} = rd;
            4'b0011: {red,blue,green} = yel;
            4'b0100: {red,blue,green} = blk;
            4'b1000: {red,blue,green} = grn;
            4'b0101: {red,blue,green} = blu;
            4'b0110: {red,blue,green} = rd;
            4'b0111: {red,blue,green} = yel;
            4'b0001: {red,blue,green} = blu;
            4'b1010: {red,blue,green} = rd;
            4'b1011: {red,blue,green} = yel;
            4'b1100: {red,blue,green} = rd;
            4'b0001: {red,blue,green} = blu;
            4'b1110: {red,blue,green} = rd;
            4'b1111: {red,blue,green} = yel;
        endcase
    else 
       {red,blue,green} = blk;
endmodule
