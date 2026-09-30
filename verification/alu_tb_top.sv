`timescale 1ns/1ps

module tb_top;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import alu_tb_pkg::*;

    // ---------------------------------------------------
    // Clock
    // ---------------------------------------------------
    logic clk = 1'b0;
    always #5 clk = ~clk;                 // 10 ns period

    // ---------------------------------------------------
    // Interface
    // ---------------------------------------------------
    alu_if alu_vif (clk);

    // ---------------------------------------------------
    // DUT
    // ---------------------------------------------------
    alu dut (
        .clk    (clk),
        .rst    (alu_vif.rst),
        .a      (alu_vif.a),
        .b      (alu_vif.b),
        .op     (alu_vif.op),
        .result (alu_vif.result)
    );

    // ---------------------------------------------------
    // Reset (active high)
    // ---------------------------------------------------
    initial begin
        alu_vif.rst = 1'b1;
        repeat (3) @(posedge clk);
        alu_vif.rst = 1'b0;
    end

    // ---------------------------------------------------
    // UVM start
    // ---------------------------------------------------
    initial begin
        uvm_config_db#(virtual alu_if)::set(null, "*", "vif", alu_vif);
        run_test("alu_test");             // +UVM_TESTNAME on the command line overrides this
    end

    // ---------------------------------------------------
    // Simulation watchdog (prevents a hung run)
    // ---------------------------------------------------
    initial begin
        #1ms;
        `uvm_fatal("TIMEOUT", "Simulation timed out")
    end

endmodule : tb_top