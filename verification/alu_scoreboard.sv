`include "uvm_macros.svh"
import uvm_pkg::*;
import alu_tb_pkg::*;

class alu_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(alu_scoreboard)

    uvm_analysis_export   #(alu_sequence_item) analysis_export;
    uvm_tlm_analysis_fifo #(alu_sequence_item) fifo;

    int error_count;
    int pass_count;

    function new(string name = "alu_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        error_count = 0;
        pass_count  = 0;
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        analysis_export = new("analysis_export", this);
        fifo            = new("fifo", this);
        `uvm_info(get_type_name(), "alu scoreboard build phase", UVM_LOW)
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        analysis_export.connect(fifo.analysis_export);
    endfunction : connect_phase

    virtual task run_phase(uvm_phase phase);
        alu_sequence_item trn;
        logic [3:0]       expected;

        forever begin
            fifo.get(trn);

            // reference model
            case (trn.op)
                2'b00:   expected = trn.a + trn.b;
                2'b01:   expected = trn.a - trn.b;
                2'b10:   expected = trn.a & trn.b;
                2'b11:   expected = trn.a | trn.b;
                default: expected = '0;
            endcase

            if (trn.result !== expected) begin
                `uvm_error(get_type_name(),
                    $sformatf("Mismatch a=%0d b=%0d op=%0d => result=%0d expected=%0d",
                              trn.a, trn.b, trn.op, trn.result, expected))
                error_count++;
            end
            else begin
                `uvm_info(get_type_name(),
                    $sformatf("Match a=%0d b=%0d op=%0d => result=%0d",
                              trn.a, trn.b, trn.op, trn.result),
                    UVM_LOW)
                pass_count++;
            end
        end
    endtask : run_phase

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("PASS_COUNT",  $sformatf("pass count  = %0d", pass_count),  UVM_LOW)
        `uvm_info("ERROR_COUNT", $sformatf("error count = %0d", error_count), UVM_LOW)
        if (error_count == 0) `uvm_info(get_type_name(), "TEST PASSED", UVM_NONE)
        else                  `uvm_info(get_type_name(), "TEST FAILED", UVM_NONE)
    endfunction : report_phase

endclass : alu_scoreboard