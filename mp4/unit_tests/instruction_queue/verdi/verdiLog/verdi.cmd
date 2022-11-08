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
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 35 )} 
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 46 )} 
wvSelectAll -win $_nWave2
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSelectGroup -win $_nWave2 {itf(tb_itf)}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
verdiDockWidgetRestore -dock windowDock_nWave_2
srcDeselectAll -win $_nTrace1
srcSelect -word -line 5 -pos 2 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -word -line 1 -pos 3 -win $_nTrace1
srcDeselectAll -win $_nTrace1
debReload
srcDeselectAll -win $_nTrace1
srcSelect -word -line 1 -pos 3 -win $_nTrace1
srcSelect -win $_nTrace1 -range {2 4 4 1 3 1}
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
wvUnknownSaveResult -win $_nWave2 -clear
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 28 )} 
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 52 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
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
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 5
wvScrollUp -win $_nWave2 6
wvScrollDown -win $_nWave2 11
wvScrollUp -win $_nWave2 7
wvScrollUp -win $_nWave2 6
wvScrollDown -win $_nWave2 2
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 20 )} 
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 20)}
wvExpandBus -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvZoomAll -win $_nWave2
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 20 )} 
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 20)}
wvCollapseBus -win $_nWave2
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 20)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
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
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSetCursor -win $_nWave2 11387.536276 -snap {("itf(tb_itf)" 12)}
wvSetCursor -win $_nWave2 12443.334341 -snap {("itf(tb_itf)" 12)}
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 20 )} 
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 20)}
wvExpandBus -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetCursor -win $_nWave2 14253.273881 -snap {("itf(tb_itf)" 13)}
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 29 )} 
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 29)}
wvExpandBus -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 21 22 23 24 25 26 27 )} 
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 21 22 23 24 25 26 27 30 31 32 33 \
           34 35 36 )} 
wvSetCursor -win $_nWave2 16440.284160 -snap {("itf(tb_itf)" 12)}
wvSetCursor -win $_nWave2 18401.051995 -snap {("itf(tb_itf)" 13)}
wvSetCursor -win $_nWave2 20437.233978 -snap {("itf(tb_itf)" 12)}
wvSetCursor -win $_nWave2 22322.587666 -snap {("itf(tb_itf)" 13)}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvSetCursor -win $_nWave2 13800.788996 -snap {("itf(tb_itf)" 19)}
wvSetCursor -win $_nWave2 12292.506046 -snap {("itf(tb_itf)" 12)}
wvScrollDown -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvSetCursor -win $_nWave2 14479.516324 -snap {("itf(tb_itf)" 13)}
wvSetCursor -win $_nWave2 16364.870012 -snap {("itf(tb_itf)" 12)}
wvSetCursor -win $_nWave2 16440.284160 -snap {("itf(tb_itf)" 12)}
wvSetCursor -win $_nWave2 18476.466143 -snap {("itf(tb_itf)" 13)}
wvSetCursor -win $_nWave2 20210.991536 -snap {("itf(tb_itf)" 13)}
wvSetCursor -win $_nWave2 20286.405683 -snap {("itf(tb_itf)" 12)}
wvSetCursor -win $_nWave2 22171.759371 -snap {("itf(tb_itf)" 13)}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvSetCursor -win $_nWave2 12462.492814 -snap {("itf(tb_itf)" 20)}
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 20 )} 
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 20 )} 
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 20 )} 
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 20)}
wvCollapseBus -win $_nWave2
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 20)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetCursor -win $_nWave2 14448.122392 -snap {("itf(tb_itf)" 20)}
wvSetCursor -win $_nWave2 15431.502450 -snap {("itf(tb_itf)" 20)}
