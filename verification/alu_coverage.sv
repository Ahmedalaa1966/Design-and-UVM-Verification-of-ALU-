`include "uvm_macros.svh"
import uvm_pkg::*;
import alu_tb_pkg::*;

class alu_coverage extends uvm_component;

    `uvm_component_utils(alu_coverage)

    uvm_analysis_export   #(alu_sequence_item) analysis_export;
    uvm_tlm_analysis_fifo #(alu_sequence_item) fifo;
    alu_sequence_item trn;

    covergroup alu_cg with function sample(alu_sequence_item t);
        option.per_instance = 1;
        option.auto_bin_max = 8;          // limit bins for wide a / b (avoids cross explosion)

        cp_a  : coverpoint t.a;
        cp_b  : coverpoint t.b;
        cp_op : coverpoint t.op;

        cross_all : cross cp_a, cp_b, cp_op;
    endgroup : alu_cg

    function new(string name = "alu_coverage", uvm_component parent = null);
        super.new(name, parent);
        alu_cg = new();
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        analysis_export = new("analysis_export", this);
        fifo            = new("fifo", this);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        analysis_export.connect(fifo.analysis_export);
    endfunction : connect_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            fifo.get(trn);
            alu_cg.sample(trn);
        end
    endtask : run_phase

endclass : alu_coverage