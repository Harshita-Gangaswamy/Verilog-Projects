
module uart_rx (
    input wire clk,       // System clock
    input wire rst,       // Reset
    input wire rx,        // Serial input
    output reg [7:0] data,// Received data
    output reg data_valid // Data reception complete
);
    
    parameter CLK_FREQ = 50000000; // 50MHz
    parameter BAUD_RATE = 9600;
    localparam BIT_PERIOD = CLK_FREQ / BAUD_RATE;
    
    reg [3:0] bit_index = 0;
    reg [15:0] clk_count = 0;
    reg [7:0] shift_reg;
    reg receiving = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            receiving <= 0;
            data_valid <= 0;
        end else if (!receiving && !rx) begin // Detect start bit
            receiving <= 1;
            clk_count <= BIT_PERIOD / 2; // Sample at middle of bit
            bit_index <= 0;
        end else if (receiving) begin
            if (clk_count < BIT_PERIOD - 1) begin
                clk_count <= clk_count + 1;
            end else begin
                clk_count <= 0;
                if (bit_index < 8) begin
                    shift_reg[bit_index] <= rx;
                end
                bit_index <= bit_index + 1;
                if (bit_index == 8) begin
                    receiving <= 0;
                    data <= shift_reg;
                    data_valid <= 1;
                end
            end
        end else begin
            data_valid <= 0;
        end
    end
endmodule
