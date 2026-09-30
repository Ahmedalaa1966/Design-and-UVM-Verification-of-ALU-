`include "uvm_macros.svh"
import uvm_pkg::*;
import alu_tb_pkg::*;

class alu_driver extends uvm_driver #(alu_sequence_item);

    `uvm_component_utils(alu_driver)

    virtual alu_if vif;      // assigned by the agent in connect_phase

    function new(string name = "alu_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        if (vif == null)
            `uvm_fatal("NO_VIF", "virtual interface not assigned to driver")
    endfunction : end_of_elaboration_phase

    virtual task run_phase(uvm_phase phase);
        alu_sequence_item trn;
        forever begin
            seq_item_port.get_next_item(trn);

            @(posedge vif.clk);
            vif.a  <= trn.a;
            vif.b  <= trn.b;
            vif.op <= trn.op;

            `uvm_info(get_type_name(),
                      $sformatf("Driver driven a = %0d, b = %0d, op = %0d", trn.a, trn.b, trn.op),
                      UVM_LOW)

            @(posedge vif.clk);              // hold for one cycle so the DUT samples it
            seq_item_port.item_done();
        end
    endtask : run_phase

endclass : alu_driver