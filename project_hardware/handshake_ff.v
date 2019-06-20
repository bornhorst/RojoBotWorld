//////////////////////////////////////////////////////////////////////////////////
// Company: Portland State University
// Engineer: Andrew Capatina, Ryan Bornhorst
// 
// Create Date: 02/09/2019 11:16:21 AM
// Design Name: 
// Module Name: handshake_ff
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//      Flip Flop for syncing the system 50 MHz clock and 75 MHz clock. 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//	Handshaking signal for synchronizing the Rojobot clock(75MHz) with the 
//	cpu clock(50MHz). 
//////////////////////////////////////////////////////////////////////////////////


module handshake_ff(
    input           clk50,
    input           IO_INT_ACK,
    input           IO_BotUpdt,
    output reg      IO_BotUpdt_Sync
    );
    
    // turn off IO_BotUpdt_Sync when ACK signal received
    always @ (posedge clk50) begin
        if (IO_INT_ACK == 1'b1) begin
            IO_BotUpdt_Sync <= 1'b0;
        end
        else if (IO_BotUpdt == 1'b1) begin
            IO_BotUpdt_Sync <= 1'b1;
        end else begin
            IO_BotUpdt_Sync <= IO_BotUpdt_Sync;
        end
    end 
    
endmodule
