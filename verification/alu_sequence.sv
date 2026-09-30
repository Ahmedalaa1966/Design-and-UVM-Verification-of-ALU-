`include "uvm_macros.svh"
import uvm_pkg::*;
import alu_tb_pkg::*;

class alu_sequence extends uvm_sequence #(alu_sequence_item);

    `uvm_object_utils(alu_sequence)                                  // registration in the UVM factory

    function new(string name = "alu_sequence");                      // constructor
        super.new(name);
    endfunction : new

    virtual task body();
        alu_sequence_item trn;                                       // handle for the sequence item
        `uvm_info(get_type_name(), "starting the uvm sequence", UVM_LOW)

        repeat (10) begin
            trn = alu_sequence_item::type_id::create("trn");         // create the transaction
            start_item(trn);                                         // blocks until the sequencer grants access
            if (!trn.randomize())                                    // randomize the transaction's fields
                `uvm_error(get_type_name(), "randomization failed")
            finish_item(trn);                                        // blocks until the driver finishes the item
            `uvm_info(get_type_name(),
                      $sformatf("generated transaction %s", trn.convert2string()),
                      UVM_LOW)
        end
    endtask : body

endclass : alu_sequence