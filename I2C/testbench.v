module tb_i2c;
    reg clk = 0;
    reg rst;
    reg start;
    reg rw;
    reg [7:0] master_data_in;
    reg [7:0] slave_data_in;
    reg [6:0] addr;
    wire sda;
    wire scl;
    wire done;
    wire [7:0] master_data_out;

    i2c_top uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .rw(rw),
        .master_data_in(master_data_in),
        .slave_data_in(slave_data_in),
        .addr(addr),
        .sda(sda),
        .scl(scl),
        .master_data_out(master_data_out),
        .done(done)
    );

    always #10 clk = ~clk;

    initial begin
        rst = 1;
        start = 0;
        addr = 7'h50;
        master_data_in = 8'hA5;
        slave_data_in = 8'h5A;
        rw = 0;
        #50 rst = 0;
        #100 start = 1;
        #20 start = 0;
        wait(done);
        #100;
        $display("Master received: %h", master_data_out);
        $stop;
    end
endmodule
