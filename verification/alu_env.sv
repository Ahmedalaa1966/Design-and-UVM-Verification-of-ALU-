`include "uvm_macros.svh"
import uvm_pkg::*;
import alu_tb_pkg::*;


class alu_env extends uvm_env;

    `uvm_component_utils(alu_env)

    alu_agent      agenth;
    alu_scoreboard scbh;
    alu_coverage   covh;

    function new(string name = "alu_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agenth = alu_agent     ::type_id::create("agenth", this);   // agent
        scbh   = alu_scoreboard::type_id::create("scbh",   this);   // scoreboard
        covh   = alu_coverage  ::type_id::create("covh",   this);   // coverage collector
        `uvm_info(get_type_name(), "ALU Environment build phase", UVM_LOW)
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agenth.monh.mon_ap.connect(scbh.analysis_export);   // monitor -> scoreboard  ( mon_ap is the name of the anylsis port defined in the monitor )
        agenth.monh.mon_ap.connect(covh.analysis_export);   // monitor -> coverage    ( mon_ap is the bame if the analysis port defined in the monitor )
    endfunction : connect_phase

endclass : alu_env