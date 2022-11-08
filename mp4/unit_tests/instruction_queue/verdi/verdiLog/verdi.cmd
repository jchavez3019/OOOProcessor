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
           "/top/tb/itf/tag_b\[2:0\]" "/top/tb/itf/rd_rob_tag\[4:0\]" \
           "/top/tb/itf/robs_calculated\[0:7\]" "/top/tb/itf/ld_br" \
           "/top/tb/itf/regfile_load" "/top/tb/itf/rob_full" \
           "/top/tb/itf/ld_commit_sel" "/top/tb/itf/data_read" \
           "/top/tb/itf/data_write" "/top/tb/itf/status_rob_valid\[0:7\]" \
           "/top/tb/itf/set_rob_valid\[0:7\]" "/top/tb/itf/rob_tag\[2:0\]" \
           "/top/tb/itf/curr_ptr\[2:0\]" "/top/tb/itf/head_ptr\[2:0\]" \
           "/top/tb/itf/rd_inflight\[4:0\]" "/top/tb/itf/st_commit\[4:0\]" \
           "/top/tb/itf/cdb_in\[0:7\]" "/top/tb/itf/cdb_out\[0:7\]" \
           "/top/tb/itf/alu1_calculation" "/top/tb/itf/alu2_calculation" \
           "/top/tb/itf/alu3_calculation" "/top/tb/itf/alu4_calculation" \
           "/top/tb/itf/timestamp\[63:0\]"
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 0)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 54)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 54)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvUnknownSaveResult -win $_nWave2 -clear
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 31 )} 
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 32 )} 
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 33 )} 
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 34 )} 
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 34 )} 
wvSetCursor -win $_nWave2 761.682890 -snap {("itf(tb_itf)" 34)}
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 34 )} 
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 34)}
wvExpandBus -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 34 )} 
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 34)}
wvCollapseBus -win $_nWave2
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 34)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
verdiDockWidgetRestore -dock windowDock_nWave_2
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 19 )} 
wvSelectAll -win $_nWave2
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSelectGroup -win $_nWave2 {itf(tb_itf)}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
debReload
srcDeselectAll -win $_nTrace1
srcSelect -word -line 1 -pos 3 -win $_nTrace1
srcSelect -win $_nTrace1 -range {2 16 4 1 2 1}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -word -line 1 -pos 3 -win $_nTrace1
wvRenameGroup -win $_nWave2 {G2} {itf(tb_itf)}
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
           "/top/tb/itf/data_write" "/top/tb/itf/status_rob_valid\[0:7\]" \
           "/top/tb/itf/set_rob_valid\[0:7\]" "/top/tb/itf/rob_tag\[2:0\]" \
           "/top/tb/itf/curr_ptr\[2:0\]" "/top/tb/itf/head_ptr\[2:0\]" \
           "/top/tb/itf/rd_inflight\[4:0\]" "/top/tb/itf/st_commit\[4:0\]" \
           "/top/tb/itf/cdb_in\[0:7\]" "/top/tb/itf/cdb_out\[0:7\]" \
           "/top/tb/itf/alu1_calculation" "/top/tb/itf/alu2_calculation" \
           "/top/tb/itf/alu3_calculation" "/top/tb/itf/alu4_calculation" \
           "/top/tb/itf/timestamp\[63:0\]"
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 0)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 52)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 52)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvUnknownSaveResult -win $_nWave2 -clear
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 29 )} 
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 37 )} 
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 38 )} 
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 41 )} 
wvScrollDown -win $_nWave2 0
