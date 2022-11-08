simSetSimulator "-vcssv" -exec \
           "/home/jorgejc2/Documents/mp4/mp4/unit_tests/instruction_queue/sim/simv" \
           -args "+lint=all,noSVA-UA,noNS,noSVA-AECASR +v2k"
debImport "-dbdir" \
          "/home/jorgejc2/Documents/mp4/mp4/unit_tests/instruction_queue/sim/simv.daidir"
debLoadSimResult \
           /home/jorgejc2/Documents/mp4/mp4/unit_tests/instruction_queue/sim/dump.fsdb
wvCreateWindow
srcHBSelect "top.tb" -win $_nTrace1
srcSetScope "top.tb" -delim "." -win $_nTrace1
srcHBSelect "top.tb" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -word -line 0 -pos 2 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -word -line 1 -pos 3 -win $_nTrace1
wvRenameGroup -win $_nWave2 {G1} {itf(tb_itf)}
wvAddSignal -win $_nWave2 "top/tb/itf/stu_errors"
wvAddSignal -win $_nWave2 "/top/tb/itf/clk" "/top/tb/itf/reset_n" \
           "/top/tb/itf/instr_mem_resp" "/top/tb/itf/instr_read" \
           "/top/tb/itf/in\[31:0\]" "/top/tb/itf/instr_mem_address\[31:0\]" \
           "/top/tb/itf/res1_empty" "/top/tb/itf/res2_empty" \
           "/top/tb/itf/res3_empty" "/top/tb/itf/res4_empty" \
           "/top/tb/itf/rob_load" "/top/tb/itf/res1_load" \
           "/top/tb/itf/res2_load" "/top/tb/itf/res3_load" \
           "/top/tb/itf/res4_load" "/top/tb/itf/resbr_empty" \
           "/top/tb/itf/resbr_load" "/top/tb/itf/control_o" \
           "/top/tb/itf/res1_exec" "/top/tb/itf/res1_alu_out" \
           "/top/tb/itf/res2_exec" "/top/tb/itf/res2_alu_out" \
           "/top/tb/itf/res3_exec" "/top/tb/itf/res3_alu_out" \
           "/top/tb/itf/res4_exec" "/top/tb/itf/res4_alu_out" \
           "/top/tb/itf/reg_src1_data\[31:0\]" \
           "/top/tb/itf/reg_src2_data\[31:0\]" "/top/tb/itf/src1_valid" \
           "/top/tb/itf/src2_valid" "/top/tb/itf/tag_a\[2:0\]" \
           "/top/tb/itf/tag_b\[2:0\]" "/top/tb/itf/ld_br" \
           "/top/tb/itf/regfile_load" "/top/tb/itf/rob_full" \
           "/top/tb/itf/ld_commit_sel" "/top/tb/itf/data_read" \
           "/top/tb/itf/data_write" "/top/tb/itf/status_rob_valid\[7:0\]" \
           "/top/tb/itf/set_rob_valid\[0:7\]" "/top/tb/itf/curr_ptr\[2:0\]" \
           "/top/tb/itf/head_ptr\[2:0\]" "/top/tb/itf/br_ptr\[2:0\]" \
           "/top/tb/itf/rd_commit\[4:0\]" "/top/tb/itf/st_src_commit\[4:0\]" \
           "/top/tb/itf/cdb_in\[0:7\]" "/top/tb/itf/cdb_out\[0:7\]" \
           "/top/tb/itf/alu1_calculation" "/top/tb/itf/alu2_calculation" \
           "/top/tb/itf/alu3_calculation" "/top/tb/itf/alu4_calculation" \
           "/top/tb/itf/timestamp\[63:0\]"
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 0)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 52)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 52)}
wvSetPosition -win $_nWave2 {("G2" 0)}
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 51 )} 
wvSelectGroup -win $_nWave2 {G2}
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 52 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 20 )} 
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 20)}
wvExpandBus -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 29 )} 
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 29)}
wvExpandBus -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 38 )} 
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 38)}
wvExpandBus -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 47 )} 
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 47)}
wvExpandBus -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
verdiDockWidgetRestore -dock windowDock_nWave_2
srcHBSelect "top.tb" -win $_nTrace1
srcSetScope "top.tb" -delim "." -win $_nTrace1
srcHBSelect "top.tb" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -inst "regfile" -line 127 -pos 2 -win $_nTrace1
srcAction -pos 126 2 5 -win $_nTrace1 -name "regfile" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "data" -line 22 -pos 1 -win $_nTrace1
wvScrollDown -win $_nWave2 31
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 68)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 72)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 74)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 76)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 78)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 79)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvAddSignal -win $_nWave2 "/top/tb/regfile/data\[0:31\]"
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSetPosition -win $_nWave2 {("G2" 1)}
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvSelectSignal -win $_nWave2 {( "G2" 1 )} 
wvExpandBus -win $_nWave2
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvZoomAll -win $_nWave2
wvSetCursor -win $_nWave2 19337.112436 -snap {("G2" 3)}
wvSetCursor -win $_nWave2 21568.317717 -snap {("G2" 4)}
wvSetCursor -win $_nWave2 23799.522998 -snap {("G2" 5)}
wvSelectSignal -win $_nWave2 {( "G2" 1 )} 
wvRenameSignal -win $_nWave2 {/top/tb/regfile/data[0:31]} {register_data[0:31]}
wvSetCursor -win $_nWave2 12006.009370 -snap {("itf(tb_itf)" 19)}
wvSetCursor -win $_nWave2 12537.248722 -snap {("itf(tb_itf)" 19)}
wvSetCursor -win $_nWave2 14343.462521 -snap {("itf(tb_itf)" 19)}
wvSetCursor -win $_nWave2 16680.915673 -snap {("itf(tb_itf)" 19)}
wvSetCursor -win $_nWave2 12537.248722 -snap {("itf(tb_itf)" 19)}
