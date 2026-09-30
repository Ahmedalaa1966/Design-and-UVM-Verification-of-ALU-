`include "uvm_macros.svh"
import uvm_pkg::*;
import alu_tb_pkg::*;

class alu_sequencer extends uvm_sequencer #(alu_sequence_item);

    `uvm_component_utils(alu_sequencer)                                    // registration in the UVM factory

    function new(string name = "alu_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

endclass : alu_sequencer