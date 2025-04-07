module spi_slave (
    input wire clk,           // System clock
    input wire rst,           // Reset
    input wire cs,            // Chip Select (Active Low)
    input wire sclk,          // SPI Clock
    input wire mosi,          // Master Out, Slave In
    output reg miso,          // Master In, Slave Out
    input wire [7:0] data_in, // Data to send
    output reg [7:0] data_out // Data received
);

    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    always @(posedge sclk or posedge rst) begin
        if (rst) begin
            shift_reg <= 8'h00;
            bit_count <= 0;
        end else if (!cs) begin
            shift_reg <= {shift_reg[6:0], mosi}; // Receive Data
            bit_count <= bit_count + 1;
            if (bit_count == 7) data_out <= shift_reg;
        end
    end

    always @(negedge sclk or posedge rst) begin
        if (rst) miso <= 0;
        else if (!cs) miso <= data_in[7 - bit_count]; // Send data bit
    end
endmodule
