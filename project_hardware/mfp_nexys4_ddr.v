// mfp_nexys4_ddr.v
// January 1, 2017
//
// Instantiate the mipsfpga system and rename signals to
// match the GPIO, LEDs and switches on Digilent's (Xilinx)
// Nexys4 DDR board

// Outputs:
// 16 LEDs (IO_LED),
// 8 7-Segment Cathode (CA, CB, CC, CD, CE, CF, CG, DP),
// 8 7-Segment Anode (AN),
// 14 VGA ports (VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS) 
// Inputs:
// 16 Slide switches (IO_Switch),
// 5 Pushbuttons (IO_PB): {BTNU, BTND, BTNL, BTNC, BTNR}
//

`include "mfp_ahb_const.vh"

module mfp_nexys4_ddr( 
 	input                   CLK100MHZ,
        input                   CPU_RESETN,
        input                   BTNU, BTND, BTNL, BTNC, BTNR, 
        input  [`MFP_N_SW-1 :0] SW,
        output [`MFP_N_LED-1:0] LED,
        inout  [ 8          :1] JB,
        input                   UART_TXD_IN,
        output                  CA, CB, CC, CD, CE, CF, CG, DP,
        output [ 7          :0] AN,
        output [ 3          :0] VGA_R, 
        output [ 3          :0] VGA_G, 
        output [ 3          :0] VGA_B, 
        output                  VGA_HS,
        output                  VGA_VS
);

    // Press btnCpuReset to reset the processor. 
  
    //------------------------------------------------
    // Initializing 50Mhz and 75Mhz clock signals.
    //------------------------------------------------
    wire clk_out_50; 
    wire clk_out_75;
    wire tck_in, tck;
  
    /*------------------------------------------------
    // Initializing wires that'll contain results
    // of debounced buttons and switches.
    //------------------------------------------------*/
    wire BTNU_d, BTND_d, BTNL_d, BTNC_d, BTNR_d, CPU_RESETN_d;
    wire [15:0] SW_d;
  
    //------------------------------------------------
    // Initializing rojobot control registers. 
    //------------------------------------------------
    wire [7:0] MotCtl_in, LocX_reg, LocY_reg, Sensors_reg, BotInfo_reg;
  
    //------------------------------------------------
    // Initializing worldmap inputs and outputs. 
    //------------------------------------------------
    wire [13:0] worldmap_addr, vid_addr;
    wire [1:0]  worldmap_data, world_pixel;
 
    //------------------------------------------------
    // Initializing flip flop acknowledgement/
    // synchronization variables.
    //------------------------------------------------
    wire IO_BotUpdt, IO_INT_ACK, IO_BotUpdt_Sync;
  
    //------------------------------------------------
    // Initializing video icon signals.
    //------------------------------------------------
    wire video_on;
    wire [11:0] pixel_row, pixel_column;
    wire [1:0] icon;
  
    //------------------------------------------------
    // Added 75Mhz clock output. 
    //------------------------------------------------
    clk_wiz_0 clk_wiz_0(
	.clk_in1(CLK100MHZ), 
	.clk_out1(clk_out_50), 
	.clk_out2(clk_out_75)
    );

    IBUF IBUF1(.O(tck_in),.I(JB[4]));
    BUFG BUFG1(.O(tck), .I(tck_in));
                      
    //------------------------------------------------
    // Connecting debounced buttons and switches to 
    // GPIOS.
    // ** Changed ordering of paramaters from project 1
    // so that the buttons are in spec with the software **
    //------------------------------------------------
    debounce debounce(
   	.clk(clk_out_50), 
        .pbtn_in({BTNC, BTNL, BTNU, BTNR, BTND, CPU_RESETN}),
        .switch_in(SW), 
        .pbtn_db({BTNC_d, BTNL_d, BTNU_d, BTNR_d, BTND_d, CPU_RESETN_d}), 
        .swtch_db(SW_d)
    );

    //------------------------------------------------
    // Instantiating world_map module.
    //------------------------------------------------  
    world_map world_map(
   	.clka(clk_out_75),		// 75MHz clock
        .addra(worldmap_addr),		// input wire [13:0] worldmap_addr
        .douta(worldmap_data),		// input wire [1:0] worldmap_data
        .clkb(clk_out_75),		// 75MHz clock
        .addrb(vid_addr),		// output [13:0] vid_addr
        .doutb(world_pixel)		// output [1:0] world_pixel
    );

    //------------------------------------------------
    // Instantiating rojotbot module.
    //------------------------------------------------                        
    rojobot31_0 rojobot (
    	.MotCtl_in(MotCtl_in),    	// input wire [7 : 0] MotCtl_in
        .LocX_reg(LocX_reg),            // output wire [7 : 0] LocX_reg
        .LocY_reg(LocY_reg),            // output wire [7 : 0] LocY_reg
        .Sensors_reg(Sensors_reg),      // output wire [7 : 0] Sensors_reg
        .BotInfo_reg(BotInfo_reg),      // output wire [7 : 0] BotInfo_reg
        .worldmap_addr(worldmap_addr),  // output wire [13 : 0] worldmap_addr
        .worldmap_data(worldmap_data),  // input wire [1 : 0] worldmap_data
        .clk_in(clk_out_75),            // input wire clk_in
        // Active High
        .reset(~CPU_RESETN_d),          // input wire reset 
        .upd_sysregs(IO_BotUpdt),       // output wire upd_sysregs
        .Bot_Config_reg(SW_d[7:0])      // input wire [7 : 0] Bot_Config_reg
    );   
                        
    //------------------------------------------------
    // Instantiating dtg module. 
    //------------------------------------------------
    dtg dtg(
	.clock(clk_out_75),		// 75 MHz clock 
        .rst(~CPU_RESETN_d), 		// RESET active high
	.horiz_sync(VGA_HS), 		// output horizontal sync
	.vert_sync(VGA_VS), 		// output vertical sync
	.video_on(video_on), 		// output video_on
	.pixel_row(pixel_row), 		// output [11:0] pixel_row
	.pixel_column(pixel_column)	// output [11:0] pixel_column
    );

    //------------------------------------------------
    // Instantiating colorizer module. 
    //------------------------------------------------
    colorizer color(
	.video_on(video_on),		// input video_on
        .world(world_pixel),		// input [1:0] world_pixel
        .icon(icon),			// input [1:0] icon
        .red(VGA_R),			// output [3:0] VGA red
        .green(VGA_G),			// output [3:0] VGA green
        .blue(VGA_B)			// output [3:0] VGA blue
    );

    //------------------------------------------------
    // Instantiating hand shake flip flop for clock
    // synchronization.
    //------------------------------------------------ 
    handshake_ff sync_clocks(
    	.clk50(clk_out_50),             	// 50Mhz clock.
        .IO_INT_ACK(IO_INT_ACK),            	// Signal received from mfp_sys.
        .IO_BotUpdt(IO_BotUpdt),            	// Signal given from rojobot.
        .IO_BotUpdt_Sync(IO_BotUpdt_Sync)   	// Signal given for mfp_sys.
    );
                    
    //------------------------------------------------
    // Instantiating scaler module. 
    //------------------------------------------------
    scale scale(			
	.pixel_row(pixel_row), 		// input [11:0] pixel_row
	.pixel_column(pixel_column), 	// input [11:0] pixel_column
	.vid_addr(vid_addr)		// output [13:0] vid_addr
    );

    //------------------------------------------------
    // Instantiating icon module
    //------------------------------------------------
    icon_new icon_new(
	.pixel_row(pixel_row),		// input [11:0] pixel_row 
	.pixel_column(pixel_column), 	// input [11:0] pixel_column
	.LocX_reg(LocX_reg), 		// input [7:0] LocX_reg
	.LocY_reg(LocY_reg), 		// input [7:0] LocY_reg
	.BotInfo_reg(BotInfo_reg), 	// input [7:0] BotInfo_reg
	.icon_out(icon)			// output [1:0] icon
     );
    

    mfp_sys mfp_sys(
	.SI_Reset_N(CPU_RESETN_d),
        .SI_ClkIn(clk_out_50),
        .HADDR(),
        .HRDATA(),
        .HWDATA(),
        .HWRITE(),
	.HSIZE(),
        .EJ_TRST_N_probe(JB[7]),
        .EJ_TDI(JB[2]),
        .EJ_TDO(JB[3]),
        .EJ_TMS(JB[1]),
        .EJ_TCK(tck),
        .SI_ColdReset_N(JB[8]),
        .EJ_DINT(1'b0),
        .IO_Switch(SW_d),
        //------------------------------------------------
        // Reordered buttons so they align with SW implementation.
        //------------------------------------------------ 
        .IO_PB({BTNC_d, BTNL_d, BTNU_d, BTNR_d, BTND_d}),
        .IO_LED(LED),
        .UART_RX(UART_TXD_IN),
        //------------------------------------------------
        // 7 segment display outputs for anodes and 
        // cathodes. 
        //------------------------------------------------
        .IO_7SEGEN_N(AN),
        .IO_SEG_N({DP, CA, CB, CC, CD, CE, CF, CG}),           
        //------------------------------------------------
        // Rojobot/flip flop inputs and outputs
        // Output: IO_INT_ACK && IO_BOTCtrl
        // Input:  IO_BotUpdt_Sync && IO_BotInfo
        //------------------------------------------------
        .IO_BotCtrl(MotCtl_in),
        .IO_INT_ACK(IO_INT_ACK),             
        .IO_BotInfo({LocX_reg, LocY_reg, Sensors_reg, BotInfo_reg}),
        .IO_BotUpdt_Sync(IO_BotUpdt_Sync)           
    );

endmodule
