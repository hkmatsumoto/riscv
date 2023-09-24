module TangNano9kWrapper (
    input           clk_i,
    output [5:0]    led_no
);
    wire [5:0] led_w;
    CPU CPU(
        .clk_i  (clk_i),
        .led_o  (led_w)
    );
    
    assign led_no = ~led_w;
endmodule