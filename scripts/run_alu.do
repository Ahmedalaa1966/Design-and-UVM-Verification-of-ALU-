# =====================================================
# Regression Script for ALU UVM Verification
# =====================================================

transcript on

if {[file exists work]} {
    vdel -all -lib work
}

vlib work
vmap work work

file mkdir logs
file mkdir coverage

puts ""
puts "===================================="
puts "COMPILING FILES"
puts "===================================="
puts ""


vlog -sv +cover=bcesfx ./rtl/alu.sv
vlog -sv ./alu_if.sv
vlog -sv +incdir+. ./alu_tb_pkg.sv
vlog -sv ./alu_tb_top.sv

puts ""
puts "===================================="
puts "ELABORATING DESIGN"
puts "===================================="
puts ""

vopt +acc tb_top -o tb_top_opt

# -----------------------------------------------------
# LIST OF TESTS (UVM class names)
# -----------------------------------------------------
set testlist {
    alu_test
}

# -----------------------------------------------------
# RUN EACH TEST IN ITS OWN vsim SESSION / LOG FILE
# -----------------------------------------------------
foreach t $testlist {

    puts ""
    puts "===================================="
    puts "RUNNING TEST: $t"
    puts "===================================="
    puts ""

    vsim -c -coverage tb_top_opt -l logs/${t}.log +UVM_TESTNAME=${t}

    # UVM calls $finish at the end of run_test.
    # Without this, vsim would exit and the commands below would never run.
    onfinish stop

    run -all

    # save this test's coverage database
    coverage save coverage/${t}.ucdb


    # write a per-test human-readable coverage report
    vcover report coverage/${t}.ucdb -output coverage/${t}_report.txt -details
}

# -----------------------------------------------------
# MERGE ALL PER-TEST COVERAGE DATABASES INTO ONE
# -----------------------------------------------------
puts ""
puts "===================================="
puts "MERGING COVERAGE DATABASES"
puts "===================================="
puts ""

set ucdb_files {}
foreach t $testlist {
    lappend ucdb_files coverage/${t}.ucdb
}

vcover merge coverage/merged.ucdb {*}$ucdb_files

vcover report coverage/merged.ucdb -output coverage/regression_summary.txt -details -du alu

