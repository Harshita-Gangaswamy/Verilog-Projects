module spi_master #(
    parameter NUM_SLAVES = 2
) (
    input wire clk,           // System clock
    input wire rst,           // Reset
    input wire start,         // Start transmission
    input wire [7:0] data_in, // Data to send
    input wire [$clog2(NUM_SLAVES)-1:0] slave_select, // Slave index
    output reg sclk,          // SPI Clock
    output reg mosi,          // Master Out, Slave In
    input wire miso,          // Master In, Slave Out
    output reg [NUM_SLAVES-1:0] cs, // Chip Selects (Active Low)
    output reg [7:0] data_out, // Data received
    output reg done            // Transmission complete flag
);

    reg [3:0] bit_count;
    reg [7:0] shift_reg;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sclk <= 0;
            mosi <= 0;
            cs <= {NUM_SLAVES{1'b1}}; // All CS high (inactive)
            done <= 0;
            bit_count <= 0;
        end else if (start) begin
            cs <= {NUM_SLAVES{1'b1}}; // Deactivate all slaves
            cs[slave_select] <= 0;    // Activate selected slave
            shift_reg <= data_in;
            bit_count <= 8;
            done <= 0;
        end else if (bit_count > 0) begin
            sclk <= ~sclk; // Toggle clock
            if (sclk) begin
                mosi <= shift_reg[7]; // Send MSB first
                shift_reg <= shift_reg << 1;
            end else begin
                data_out <= {data_out[6:0], miso}; // Receive data
                bit_count <= bit_count - 1;
            end
        end else if (bit_count == 0) begin
            cs <= {NUM_SLAVES{1'b1}}; // Disable all slaves
            done <= 1;
        end
    end
endmodule
