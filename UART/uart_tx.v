
module uart_tx (
    input wire clk,        // System clock
    input wire rst,        // Reset
    input wire tx_start,   // Start transmission
    input wire [7:0] data, // Data byte to send
    output reg tx,         // Serial output
    output reg tx_done     // Transmission complete flag
);
    
    parameter CLK_FREQ = 50000000; // 50MHz
    parameter BAUD_RATE = 9600;
    localparam BIT_PERIOD = CLK_FREQ / BAUD_RATE;
    
    reg [3:0] bit_index = 0;
    reg [15:0] clk_count = 0;
    reg busy = 0;
    reg [9:0] shift_reg;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            busy <= 0;
            tx <= 1; // Idle state
            tx_done <= 0;
        end else if (tx_start && !busy) begin
            busy <= 1;
            clk_count <= 0;
            bit_index <= 0;
            shift_reg <= {1'b1, data, 1'b0}; // Stop, Data, Start
        end else if (busy) begin
            if (clk_count < BIT_PERIOD - 1) begin
                clk_count <= clk_count + 1;
            end else begin
                clk_count <= 0;
                tx <= shift_reg[0];
                shift_reg <= shift_reg >> 1;
                bit_index <= bit_index + 1;
                if (bit_index == 9) begin
                    busy <= 0;
                    tx_done <= 1;
                end
            end
        end else begin
            tx_done <= 0;
        end
    end
endmodule
