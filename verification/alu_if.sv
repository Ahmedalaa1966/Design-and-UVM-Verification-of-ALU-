interface alu_if (input logic clk);

    logic       rst;       // reset (active high here, match your DUT)
    logic [3:0] a;
    logic [3:0] b;
    logic [1:0] op;
    logic [3:0] result;    // use [4:0] if your DUT keeps the carry

    // DUT view: it reads the inputs and drives the result
    modport dut (
        input  clk, rst, a, b, op,
        output result
    );

endinterface : alu_if