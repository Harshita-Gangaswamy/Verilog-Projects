module tb_spi;
    reg clk = 0;
    reg rst;
    reg start;
    reg [7:0] master_data_in;
    reg [7:0] slave1_data_in;
    reg [7:0] slave2_data_in;
    reg slave_select;
    wire sclk;
    wire mosi;
    wire miso;
    wire [1:0] cs;
    wire [7:0] master_data_out;
    wire [7:0] slave1_data_out;
    wire [7:0] slave2_data_out;
    wire done;

    spi_top uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .master_data_in(master_data_in),
        .slave1_data_in(slave1_data_in),
        .slave2_data_in(slave2_data_in),
        .slave_select(slave_select),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso),
        .cs(cs),
        .master_data_out(master_data_out),
        .slave1_data_out(slave1_data_out),
        .slave2_data_out(slave2_data_out),
        .done(done)
    );

    assign miso = (cs[0] == 0) ? mosi : (cs[1] == 0) ? mosi : 1'bz; // Multiplexed MISO

    always #10 clk = ~clk;

    initial begin
        rst = 1;
        start = 0;
        master_data_in = 8'hA5;
        slave1_data_in = 8'h5A;
        slave2_data_in = 8'hC3;

        #50 rst = 0;

        // Communicating with Slave 1
        #100 slave_select = 0;
        start = 1;
        #20 start = 0;
        wait(done);
        $display("Master received from Slave 1: %h", master_data_out);
        $display("Slave 1 received: %h", slave1_data_out);

        // Communicating with Slave 2
        #100 slave_select = 1;
        start = 1;
        #20 start = 0;
        wait(done);
        $display("Master received from Slave 2: %h", master_data_out);
        $display("Slave 2 received: %h", slave2_data_out);

        $stop;
    end
endmodule
