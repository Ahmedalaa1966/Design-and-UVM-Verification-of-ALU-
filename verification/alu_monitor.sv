`include "uvm_macros.svh"
import uvm_pkg::*;
import alu_tb_pkg::*;

class alu_monitor extends uvm_monitor;

    `uvm_component_utils(alu_monitor)

    virtual alu_if vif;                                    // assigned by the agent in connect_phase
    uvm_analysis_port #(alu_sequence_item) mon_ap;         // broadcasts observed transactions

    function new(string name = "alu_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_ap = new("mon_ap", this);
    endfunction : build_phase

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        if (vif == null)
            `uvm_fatal("NO_VIF", "virtual interface not assigned to monitor")
    endfunction : end_of_elaboration_phase

    virtual task run_phase(uvm_phase phase);
        alu_sequence_item trn;
        logic [3:0] prev_a, prev_b;
        logic [1:0] prev_op;
        bit         prev_valid = 0;

        forever begin
            @(posedge vif.clk);

            if (vif.rst) begin
                prev_valid = 0;                            // ignore everything during reset
            end
            else begin
                // result now corresponds to the inputs seen at the previous edge
                if (prev_valid) begin
                    trn        = alu_sequence_item::type_id::create("trn");
                    trn.a      = prev_a;
                    trn.b      = prev_b;
                    trn.op     = prev_op;
                    trn.result = vif.result;
                    mon_ap.write(trn);

                    `uvm_info(get_type_name(),
                              $sformatf("monitored a = %0d, b = %0d, op = %0d, result = %0d",
                                        trn.a, trn.b, trn.op, trn.result),
                              UVM_LOW)
                end

                // remember the current inputs for the next edge
                prev_a     = vif.a;
                prev_b     = vif.b;
                prev_op    = vif.op;
                prev_valid = 1;
            end
        end
    endtask : run_phase

endclass : alu_monitor