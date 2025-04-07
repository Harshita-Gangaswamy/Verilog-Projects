module i2c_master (
    input wire clk,
    input wire rst,
    input wire start,
    input wire rw,
    input wire [7:0] data_in,
    input wire [6:0] addr,
    inout wire sda,
    output reg scl,
    output reg done,
    output reg [7:0] data_out
);

    parameter CLK_FREQ = 50000000;
    parameter I2C_FREQ = 100000;
    localparam SCL_PERIOD = CLK_FREQ / (4 * I2C_FREQ);

    reg [3:0] state = 0;
    reg [7:0] shift_reg;
    reg [3:0] bit_count;
    reg [15:0] clk_count;
    reg sda_out = 1;
    
    assign sda = (state > 1 && state < 9) ? sda_out : 1'bz;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            sda_out <= 1;
            scl <= 1;
            done <= 0;
        end else begin
            case (state)
                0: if (start) begin
                        sda_out <= 0;
                        clk_count <= 0;
                        state <= 1;
                   end
                1: if (clk_count == SCL_PERIOD) begin
                        clk_count <= 0;
                        shift_reg <= {addr, rw}; // Address + Read/Write
                        bit_count <= 8;
                        state <= 2;
                   end else clk_count <= clk_count + 1;
                2: if (clk_count == SCL_PERIOD) begin
                        scl <= ~scl;
                        if (!scl) begin
                            sda_out <= shift_reg[7];
                            shift_reg <= shift_reg << 1;
                            bit_count <= bit_count - 1;
                            if (bit_count == 0) state <= 3;
                        end
                        clk_count <= 0;
                   end else clk_count <= clk_count + 1;
                3: begin 
                        state <= rw ? 5 : 4;
                   end
                4: if (!rw && clk_count == SCL_PERIOD) begin // Write operation
                        shift_reg <= data_in;
                        bit_count <= 8;
                        state <= 2;
                   end
                5: if (rw && clk_count == SCL_PERIOD) begin // Read operation
                        scl <= ~scl;
                        if (!scl) begin
                            data_out <= {data_out[6:0], sda};
                            bit_count <= bit_count - 1;
                            if (bit_count == 0) state <= 6;
                        end
                        clk_count <= 0;
                   end else clk_count <= clk_count + 1;
                6: begin
                        sda_out <= 0;
                        scl <= 1;
                        done <= 1;
                        state <= 7;
                   end
                7: if (!start) state <= 0;
            endcase
        end
    end
endmodule
