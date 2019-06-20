//////////////////////////////////////////////////////////////////////////////////
// Company: Portland State University
// Engineer: Ryan Bornhorst Andrew Capatina
// 
// Create Date: 02/14/2019 09:14:55 PM
// Design Name: Rojobot
// Module Name: scale
// Project Name: Rojobot Project 2
// Target Devices: NexysA7
// Tool Versions: 
// Description: 
//  Module for scaling current pixel column/rows for world map. 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//	Module that scales the pixel_row, pixel_column (1024x768) to the 
//	Rojobots dimensions (128x128).
//////////////////////////////////////////////////////////////////////////////////

module scale(
    input   	[11:0] pixel_row,	
    input   	[11:0] pixel_column,
    output	[13:0] vid_addr
);

// scaled row/column outputs
wire [6:0] pix_c, pix_r;      
    
// Scale columns and rows to 128x128
assign pix_c	= pixel_column / 8;
assign pix_r    = pixel_row / 6;
assign vid_addr = {pix_r, pix_c};    

endmodule
