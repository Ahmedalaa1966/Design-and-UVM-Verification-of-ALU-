`include "uvm_macros.svh"
import uvm_pkg::*;
import alu_tb_pkg::*;

class alu_sequence_item extends uvm_sequence_item;

    `uvm_object_utils(alu_sequence_item)                    // registration to the UVM factory

    rand logic [3:0] a;
    rand logic [3:0] b;
    rand logic [1:0] op;
         logic [3:0] result;                                // observed by the monitor, not randomized

    function new(string name = "alu_sequence_item");
        super.new(name);
    endfunction : new

    virtual function string convert2string();
        return $sformatf("a=%0d, b=%0d, op=%0d, result=%0d", a, b, op, result);
    endfunction : convert2string

endclass : alu_sequence_item