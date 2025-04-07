module spi_top (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] master_data_in,
    input wire [7:0] slave1_data_in,
    input wire [7:0] slave2_data_in,
    input wire slave_select, // 0 for Slave 1, 1 for Slave 2
    output wire sclk,
    output wire mosi,
    input wire miso,
    output wire [1:0] cs,
    output wire [7:0] master_data_out,
    output wire [7:0] slave1_data_out,
    output wire [7:0] slave2_data_out,
    output wire done
);

    wire [1:0] cs_signals;
    wire miso_wire;

    assign miso_wire = (!cs_signals[0]) ? miso : (!cs_signals[1]) ? miso : 1'bz; // Multiplex MISO

    spi_master #(.NUM_SLAVES(2)) master (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(master_data_in),
        .slave_select(slave_select),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso_wire),
        .cs(cs_signals),
        .data_out(master_data_out),
        .done(done)
    );

    spi_slave slave1 (
        .clk(clk),
        .rst(rst),
        .cs(cs_signals[0]),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso),
        .data_in(slave1_data_in),
        .data_out(slave1_data_out)
    );

    spi_slave slave2 (
        .clk(clk),
        .rst(rst),
        .cs(cs_signals[1]),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso),
        .data_in(slave2_data_in),
        .data_out(slave2_data_out)
    );

    assign cs = cs_signals;

endmodule
