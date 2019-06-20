//////////////////////////////////////////////////////////////////////////////////
// Company: Portland State University
// Engineer: Andrew Capatina Ryan Bornhorst
// 
// Create Date: 02/14/2019 06:34:56 PM
// Design Name: Rojobot
// Module Name: icon_new
// Project Name: Rojobot
// Target Devices: Nexys4 A7
// Tool Versions: 
// Description: 
//      Creates scaled icon output for video display. 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//	Module that creates the Rojobot icon by mapping a 16x16 image of
//	2 bit colorized pixels. A different icon is created for each
//      Rojobot orientation.
/////////////////////////////////////////////////////////////////////////////////

module icon_new(
    input 	[11:0]	pixel_row, pixel_column,
    input 	[7:0]   LocX_reg, LocY_reg, BotInfo_reg,
    output reg 	[1:0]   icon_out
);

// all possible icon orientations
reg [31:0] icon_0	[0:15];
reg [31:0] icon_45	[0:15];
reg [31:0] icon_90	[0:15];
reg [31:0] icon_135	[0:15];
reg [31:0] icon_180	[0:15];
reg [31:0] icon_225	[0:15];
reg [31:0] icon_270	[0:15];
reg [31:0] icon_315	[0:15];              

// parameters to hold icon colors    
parameter  blu = 2'b01, red = 2'b10, yel = 2'b11, clr = 2'b00;
	
// scaled Rojobot locations
wire [11:0] scaled_LocX, scaled_LocY;  

// difference between pixel_row/column and rojobot location
wire [11:0] diff_x, diff_y;
	
// initialize Rojobot images for each orientation - Formula 1 Car
// for diagonal orientations we chose to create an arrow due to the difficulty
// of creating the diagonal car
initial begin
        
icon_90[0]   = {blu,blu,blu,clr,clr,clr,clr,clr,clr,blu,blu,blu,clr,blu,blu,clr};
icon_90[1]   = {blu,blu,blu,clr,clr,clr,red,red,clr,blu,blu,blu,clr,blu,blu,clr};
icon_90[2]   = {blu,blu,blu,clr,clr,red,red,red,red,blu,blu,blu,clr,blu,blu,clr};
icon_90[3]   = {clr,blu,clr,clr,red,red,red,red,red,clr,blu,clr,clr,blu,blu,clr};
icon_90[4]   = {clr,blu,clr,clr,red,red,red,red,red,clr,blu,clr,clr,clr,blu,clr};
icon_90[5]   = {clr,blu,clr,clr,red,red,red,red,red,clr,blu,clr,clr,clr,blu,clr};
icon_90[6]   = {clr,blu,clr,red,red,red,red,blu,blu,red,red,red,red,clr,blu,clr};
icon_90[7]   = {clr,red,red,red,red,red,blu,yel,blu,red,red,red,red,red,blu,clr};
icon_90[8]   = {clr,red,red,red,red,red,blu,yel,blu,red,red,red,red,red,blu,clr};
icon_90[9]   = {clr,blu,clr,red,red,red,red,blu,blu,red,red,red,red,clr,blu,clr};
icon_90[10]  = {clr,blu,clr,clr,red,red,red,red,red,clr,blu,clr,clr,clr,blu,clr};
icon_90[11]  = {clr,blu,clr,clr,red,red,red,red,red,clr,blu,clr,clr,clr,blu,clr};
icon_90[12]  = {clr,blu,clr,clr,red,red,red,red,red,clr,blu,clr,clr,blu,blu,clr};
icon_90[13]  = {blu,blu,blu,clr,clr,red,red,red,red,blu,blu,blu,clr,blu,blu,clr};
icon_90[14]  = {blu,blu,blu,clr,clr,clr,red,red,clr,blu,blu,blu,clr,blu,blu,clr};
icon_90[15]  = {blu,blu,blu,clr,clr,clr,clr,clr,clr,blu,blu,blu,clr,blu,blu,clr};

icon_270[0]  = {clr,blu,blu,clr,blu,blu,blu,clr,clr,clr,clr,clr,clr,blu,blu,blu};   
icon_270[1]  = {clr,blu,blu,clr,blu,blu,blu,clr,red,red,clr,clr,clr,blu,blu,blu};
icon_270[2]  = {clr,blu,blu,clr,blu,blu,blu,red,red,red,red,clr,clr,blu,blu,blu};
icon_270[3]  = {clr,blu,blu,clr,clr,blu,clr,red,red,red,red,red,clr,clr,blu,clr};
icon_270[4]  = {clr,blu,clr,clr,clr,blu,clr,red,red,red,red,red,clr,clr,blu,clr};
icon_270[5]  = {clr,blu,clr,clr,clr,blu,clr,red,red,red,red,red,clr,clr,blu,clr};
icon_270[6]  = {clr,blu,clr,red,red,red,red,blu,blu,red,red,red,red,clr,blu,clr};
icon_270[7]  = {clr,blu,red,red,red,red,red,blu,yel,blu,red,red,red,red,red,clr};
icon_270[8]  = {clr,blu,red,red,red,red,red,blu,yel,blu,red,red,red,red,red,clr};
icon_270[9]  = {clr,blu,clr,red,red,red,red,blu,blu,red,red,red,red,clr,blu,clr};
icon_270[10] = {clr,blu,clr,clr,clr,blu,clr,red,red,red,red,red,clr,clr,blu,clr};
icon_270[11] = {clr,blu,clr,clr,clr,blu,clr,red,red,red,red,red,clr,clr,blu,clr};
icon_270[12] = {clr,blu,blu,clr,clr,blu,clr,red,red,red,red,red,clr,clr,blu,clr};
icon_270[13] = {clr,blu,blu,clr,blu,blu,blu,clr,red,red,clr,clr,clr,blu,blu,blu};
icon_270[14] = {clr,blu,blu,clr,blu,blu,blu,clr,red,red,clr,clr,clr,blu,blu,blu};
icon_270[15] = {clr,blu,blu,clr,blu,blu,blu,clr,clr,clr,clr,clr,clr,blu,blu,blu};

icon_180[0]  = {blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu};
icon_180[1]  = {blu,blu,blu,blu,blu,blu,blu,red,red,blu,blu,blu,blu,blu,blu,blu};
icon_180[2]  = {blu,blu,blu,clr,clr,clr,clr,red,red,clr,clr,clr,clr,blu,blu,blu};
icon_180[3]  = {clr,clr,clr,clr,clr,clr,red,red,red,red,clr,clr,clr,clr,clr,clr};
icon_180[4]  = {clr,clr,clr,red,red,red,red,red,red,red,red,red,red,clr,clr,clr};
icon_180[5]  = {clr,clr,red,red,red,red,red,red,red,red,red,red,red,clr,clr,clr};
icon_180[6]  = {clr,red,red,red,red,red,red,blu,blu,red,red,red,red,red,red,clr};
icon_180[7]  = {clr,red,red,red,red,red,blu,yel,yel,blu,red,red,red,red,red,clr};
icon_180[8]  = {clr,clr,red,red,red,red,blu,blu,blu,blu,red,red,red,clr,clr,clr};
icon_180[9]  = {blu,blu,blu,clr,clr,clr,red,red,red,red,clr,clr,clr,blu,blu,blu};
icon_180[10] = {blu,blu,blu,blu,blu,blu,red,red,red,red,blu,blu,blu,blu,blu,blu};
icon_180[11] = {blu,blu,blu,clr,clr,clr,red,red,red,red,clr,clr,clr,blu,blu,blu};
icon_180[12] = {clr,clr,clr,clr,clr,clr,red,red,red,red,clr,clr,clr,clr,clr,clr};
icon_180[13] = {blu,blu,blu,blu,clr,clr,clr,red,red,clr,clr,clr,blu,blu,blu,blu};
icon_180[14] = {blu,blu,blu,blu,blu,blu,blu,blu,blu,blu,blu,blu,blu,blu,blu,blu};
icon_180[15] = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr};
    
icon_0[0]    = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr};
icon_0[1]    = {blu,blu,blu,blu,blu,blu,blu,blu,blu,blu,blu,blu,blu,blu,blu,blu};
icon_0[2]    = {blu,blu,blu,blu,clr,clr,clr,red,red,clr,clr,clr,blu,blu,blu,blu};
icon_0[3]    = {clr,clr,clr,clr,clr,clr,red,red,red,red,clr,clr,clr,clr,clr,clr};
icon_0[4]    = {blu,blu,blu,clr,clr,clr,red,red,red,red,clr,clr,clr,blu,blu,blu};
icon_0[5]    = {blu,blu,blu,blu,blu,blu,red,red,red,red,blu,blu,blu,blu,blu,blu};
icon_0[6]    = {blu,blu,blu,clr,clr,clr,red,red,red,red,clr,clr,clr,blu,blu,blu};
icon_0[7]    = {clr,clr,red,red,red,red,blu,blu,blu,blu,red,red,red,red,clr,clr};
icon_0[8]    = {clr,red,red,red,red,red,blu,yel,yel,blu,red,red,red,red,red,clr};   
icon_0[9]    = {clr,red,red,red,red,red,red,blu,blu,red,red,red,red,red,red,clr};
icon_0[10]   = {clr,clr,red,red,red,red,red,red,red,red,red,red,red,red,clr,clr};
icon_0[11]   = {clr,clr,clr,red,red,red,red,red,red,red,red,red,red,clr,clr,clr};
icon_0[12]   = {clr,clr,clr,clr,clr,clr,red,red,red,red,clr,clr,clr,clr,clr,clr};
icon_0[13]   = {clr,clr,clr,clr,clr,clr,clr,red,red,clr,clr,clr,clr,clr,clr,clr};
icon_0[14]   = {blu,blu,blu,clr,clr,clr,clr,red,red,clr,clr,clr,clr,blu,blu,blu};
icon_0[15]   = {blu,blu,blu,blu,blu,blu,blu,red,red,blu,blu,blu,blu,blu,blu,blu};
icon_0[16]   = {blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu};

icon_135[0]  = {blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr};
icon_135[1]  = {blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr};
icon_135[2]  = {clr,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr};
icon_135[3]  = {clr,clr,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr};
icon_135[4]  = {clr,clr,clr,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr};
icon_135[5]  = {clr,clr,clr,clr,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr};
icon_135[6]  = {clr,clr,clr,clr,clr,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr};
icon_135[7]  = {clr,clr,clr,clr,clr,clr,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr};
icon_135[8]  = {clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,clr,clr,clr,clr,clr,blu};
icon_135[9]  = {clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,clr,clr,clr,clr,blu};
icon_135[10] = {clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,clr,clr,clr,blu};
icon_135[11] = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,clr,blu,blu};
icon_135[12] = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,blu,blu};
icon_135[13] = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,blu};
icon_135[14] = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,blu,blu};
icon_135[15] = {clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,blu,blu,blu,blu,blu};
      
icon_45[0]   = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,blu,blu,blu};
icon_45[1]   = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,blu};
icon_45[2]   = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,blu};
icon_45[3]   = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,blu};
icon_45[4]   = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,blu,blu,blu};
icon_45[5]   = {clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,blu,blu,clr,blu};
icon_45[6]   = {clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,blu,clr,clr,blu};
icon_45[7]   = {clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,blu,clr,clr,clr,blu};
icon_45[8]   = {clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,clr,clr,clr,clr,clr,clr};
icon_45[9]   = {clr,clr,clr,clr,clr,clr,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr};
icon_45[10]  = {clr,clr,clr,clr,clr,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr};
icon_45[11]  = {clr,clr,clr,blu,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr};
icon_45[12]  = {clr,clr,blu,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr};
icon_45[13]  = {clr,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr};
icon_45[14]  = {blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr};
icon_45[15]  = {blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr};

icon_225[0]  = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu};
icon_225[1]  = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu};
icon_225[2]  = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu};
icon_225[3]  = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,clr};
icon_225[4]  = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,clr,clr};
icon_225[5]  = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,clr,clr,clr};
icon_225[6]  = {clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,clr,clr,clr,clr};
icon_225[7]  = {clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,clr,clr,clr,clr,clr};
icon_225[8]  = {blu,clr,clr,clr,clr,clr,clr,blu,blu,blu,clr,clr,clr,clr,clr,clr};
icon_225[9]  = {blu,clr,clr,clr,clr,clr,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr};
icon_225[10] = {blu,clr,clr,clr,clr,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr};
icon_225[11] = {blu,blu,clr,blu,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr};
icon_225[12] = {blu,blu,blu,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr};
icon_225[13] = {blu,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr};
icon_225[14] = {blu,blu,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr};
icon_225[15] = {blu,blu,blu,blu,blu,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr};

icon_315[0]  = {blu,blu,blu,blu,blu,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr};
icon_315[1]  = {blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr};
icon_315[2]  = {blu,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr};
icon_315[3]  = {blu,clr,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr};
icon_315[4]  = {blu,clr,clr,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr};
icon_315[5]  = {blu,clr,clr,clr,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr,clr};
icon_315[6]  = {blu,clr,clr,clr,clr,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr,clr};
icon_315[7]  = {blu,clr,clr,clr,clr,clr,blu,blu,blu,clr,clr,clr,clr,clr,clr,clr};
icon_315[8]  = {blu,clr,clr,clr,clr,clr,clr,blu,blu,blu,clr,clr,clr,clr,clr,clr};
icon_315[9]  = {clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,clr,clr,clr,clr,clr};
icon_315[10] = {clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,clr,clr,clr,clr};
icon_315[11] = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,clr,clr,clr};
icon_315[12] = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,clr,clr};
icon_315[13] = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu,blu};
icon_315[14] = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu};
icon_315[15] = {clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,clr,blu,blu,blu};

end

// assign scaled locations and location differences    
assign scaled_LocX 	= LocX_reg * 8;      // Scale to 1024
assign scaled_LocY 	= LocY_reg * 6;      // Scale to 768
assign diff_x 		= (scaled_LocX + 31) - pixel_column;
assign diff_y 		= pixel_row - scaled_LocY;

always @(*) begin
	case(BotInfo_reg[2:0])
	3'b000: // 0 degrees
	begin
		// Check if the current pixel is in range of the rojobot's position.
		if(((scaled_LocX + 31 >= pixel_column) && (scaled_LocX <= pixel_column)) 
		&& ((scaled_LocY + 15 >= pixel_row) && (scaled_LocY <= pixel_row)))
		    begin
		    // Assign the output based off the current pixel position.
		    if(diff_x[0] == 1'b1)
			icon_out = icon_0[diff_y][diff_x -: 2];
		    else
			icon_out = icon_0[diff_y][(diff_x + 1) -: 2];
		    end 
		else
		    // Assign transparent output if the icon doesn't need to be displayed.
		    icon_out = 2'b00;
	end
	3'b001: // 45 degrees 
	begin
		// Check if the current pixel is in range of the rojobot's position.
		if(((scaled_LocX + 31 >= pixel_column) && (scaled_LocX <= pixel_column)) 
		&& ((scaled_LocY + 15 >= pixel_row) && (scaled_LocY <= pixel_row)))
		begin
		    // Assign the output based off the current pixel position.
		    if(diff_x[0] == 1'b1)
			icon_out = icon_45[diff_y][diff_x -: 2];
		    else
			icon_out = icon_45[diff_y][(diff_x + 1) -: 2];
		end 
		else
		    // Assign transparent output if the icon doesn't need to be displayed.
		    icon_out = 2'b00;
	end    
	3'b010: // 90 degrees 
	begin
		// Check if the current pixel is in range of the rojobot's position.
		if(((scaled_LocX + 31 >= pixel_column) && (scaled_LocX <= pixel_column)) 
		&& ((scaled_LocY + 15 >= pixel_row) && (scaled_LocY <= pixel_row)))
		begin
		    // Assign the output based off the current pixel position.
		    if(diff_x[0] == 1'b1)
			icon_out = icon_90[diff_y][diff_x -: 2];
		    else
			icon_out = icon_90[diff_y][(diff_x + 1) -: 2];
		end 
		else
		    // Assign transparent output if the icon doesn't need to be displayed.
		    icon_out = 2'b00;
	end
	3'b011: // 135 degrees
	begin
		// Check if the current pixel is in range of the rojobot's position.
		if(((scaled_LocX + 31 >= pixel_column) && (scaled_LocX <= pixel_column)) 
		&& ((scaled_LocY + 15 >= pixel_row) && (scaled_LocY <= pixel_row)))
		begin
		    // Assign the output based off the current pixel position.
		    if(diff_x[0] == 1'b1)
			icon_out = icon_135[diff_y][diff_x -: 2];
		    else
			icon_out = icon_135[diff_y][(diff_x + 1) -: 2];
		end 
		else
		    // Assign transparent output if the icon doesn't need to be displayed.
		    icon_out = 2'b00;
	end    
	3'b100: // 180 degrees
	begin
		// Check if the current pixel is in range of the rojobot's position.
		if(((scaled_LocX + 31 >= pixel_column) && (scaled_LocX <= pixel_column)) 
		&& ((scaled_LocY + 15 >= pixel_row) && (scaled_LocY <= pixel_row)))
		begin
		    // Assign the output based off the current pixel position.
		    if(diff_x[0] == 1'b1)
			icon_out = icon_180[diff_y][diff_x -: 2];
		    else
			icon_out = icon_180[diff_y][(diff_x + 1) -: 2];
		end 
		else
		    // Assign transparent output if the icon doesn't need to be displayed.
		    icon_out = 2'b00;
	end
	3'b101: // 225 degrees
	begin
	    // Check if the current pixel is in range of the rojobot's position.
	    if(((scaled_LocX + 31 >= pixel_column) && (scaled_LocX <= pixel_column)) 
	    && ((scaled_LocY + 15 >= pixel_row) && (scaled_LocY <= pixel_row)))
	    begin
		// Assign the output based off the current pixel position.
		if(diff_x[0] == 1'b1)
		    icon_out = icon_225[diff_y][diff_x -: 2];
		else
		    icon_out = icon_225[diff_y][(diff_x + 1) -: 2];
	    end 
	    else
		// Assign transparent output if the icon doesn't need to be displayed.
		icon_out = 2'b00;
	end  
	3'b110: // 270 degrees
	begin
	    // Check if the current pixel is in range of the rojobot's position.
	    if(((scaled_LocX + 31 >= pixel_column) && (scaled_LocX <= pixel_column)) 
	    && ((scaled_LocY + 15 >= pixel_row) && (scaled_LocY <= pixel_row)))
	    begin
		// Assign the output based off the current pixel position.
		if(diff_x[0] == 1'b1)
		    icon_out = icon_270[diff_y][diff_x -: 2];
		else
		    icon_out = icon_270[diff_y][(diff_x + 1) -: 2];
	    end 
	    else
		// Assign transparent output if the icon doesn't need to be displayed.
		icon_out = 2'b00;
	end
	3'b111: // 315 degrees
	begin
	    // Check if the current pixel is in range of the rojobot's position.
	    if(((scaled_LocX + 31 >= pixel_column) && (scaled_LocX <= pixel_column)) 
	    && ((scaled_LocY + 15 >= pixel_row) && (scaled_LocY <= pixel_row)))
	    begin
		// Assign the output based off the current pixel position.
		if(diff_x[0] == 1'b1)
		    icon_out = icon_315[diff_y][diff_x -: 2];
		else
		    icon_out = icon_315[diff_y][(diff_x + 1) -: 2];
	    end 
	    else
		// Assign transparent output if the icon doesn't need to be displayed.
		icon_out = 2'b00;
	end  
endcase
end

endmodule
