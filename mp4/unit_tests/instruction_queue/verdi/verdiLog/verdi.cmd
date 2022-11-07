simSetSimulator "-vcssv" -exec \
           "/home/jorgejc2/Documents/mp4/mp4/unit_tests/instruction_queue/sim/simv" \
           -args "+lint=all,noSVA-UA,noNS,noSVA-AECASR +v2k"
debImport "-dbdir" \
          "/home/jorgejc2/Documents/mp4/mp4/unit_tests/instruction_queue/sim/simv.daidir"
debLoadSimResult \
           /home/jorgejc2/Documents/mp4/mp4/unit_tests/instruction_queue/sim/dump.fsdb
wvCreateWindow
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
debReload
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcAction -pos 3 0 25 -win $_nTrace1 -name "// instruction_queue_itf itf\(\);" \
          -ctrlKey off
srcDeselectAll -win $_nTrace1
debReload
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcAction -pos 3 0 27 -win $_nTrace1 -name "// instruction_queue_itf itf\(\);" \
          -ctrlKey off
srcDeselectAll -win $_nTrace1
srcAction -pos 3 0 27 -win $_nTrace1 -name "// instruction_queue_itf itf\(\);" \
          -ctrlKey off
srcHBSelect "top.itf" -win $_nTrace1
srcSetScope "top.itf" -delim "." -win $_nTrace1
srcHBSelect "top.itf" -win $_nTrace1
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
           "/top/tb/itf/resldst_empty" "/top/tb/itf/ldst_q_full" \
           "/top/tb/itf/rob_load" "/top/tb/itf/res1_load" \
           "/top/tb/itf/res2_load" "/top/tb/itf/res3_load" \
           "/top/tb/itf/res4_load" "/top/tb/itf/resldst_load" \
           "/top/tb/itf/regfile_tag1\[4:0\]" "/top/tb/itf/regfile_tag2\[4:0\]" \
           "/top/tb/itf/control_o" "/top/tb/itf/res1_exec" \
           "/top/tb/itf/res1_alu_out" "/top/tb/itf/res2_exec" \
           "/top/tb/itf/res2_alu_out" "/top/tb/itf/res3_exec" \
           "/top/tb/itf/res3_alu_out" "/top/tb/itf/res4_exec" \
           "/top/tb/itf/res4_alu_out" "/top/tb/itf/reg_src1_data\[31:0\]" \
           "/top/tb/itf/reg_src2_data\[31:0\]" "/top/tb/itf/src1_valid" \
           "/top/tb/itf/src2_valid" "/top/tb/itf/src_a\[4:0\]" \
           "/top/tb/itf/src_b\[4:0\]" "/top/tb/itf/src_c\[4:0\]" \
           "/top/tb/itf/dest\[4:0\]" "/top/tb/itf/tag_in\[2:0\]" \
           "/top/tb/itf/tag_a\[2:0\]" "/top/tb/itf/tag_b\[2:0\]" \
           "/top/tb/itf/tag_dest\[2:0\]" "/top/tb/itf/reg_a\[31:0\]" \
           "/top/tb/itf/reg_b\[31:0\]" "/top/tb/itf/valid_a" \
           "/top/tb/itf/valid_b" "/top/tb/itf/rd_rob_tag\[4:0\]" \
           "/top/tb/itf/robs_calculated\[0:7\]" "/top/tb/itf/ld_br" \
           "/top/tb/itf/rob0_valid" "/top/tb/itf/rob1_valid" \
           "/top/tb/itf/rob2_valid" "/top/tb/itf/rob3_valid" \
           "/top/tb/itf/rob4_valid" "/top/tb/itf/rob5_valid" \
           "/top/tb/itf/rob6_valid" "/top/tb/itf/rob7_valid" \
           "/top/tb/itf/regfile_allocate" "/top/tb/itf/regfile_load" \
           "/top/tb/itf/rob_full" "/top/tb/itf/ld_commit_sel" \
           "/top/tb/itf/data_read" "/top/tb/itf/data_write" \
           "/top/tb/itf/rob_tag\[2:0\]" "/top/tb/itf/rd_inflight\[4:0\]" \
           "/top/tb/itf/st_commit\[4:0\]" "/top/tb/itf/cdb_in\[0:7\]" \
           "/top/tb/itf/cdb_out\[0:7\]" "/top/tb/itf/alu1_calculation" \
           "/top/tb/itf/alu2_calculation" "/top/tb/itf/alu3_calculation" \
           "/top/tb/itf/alu4_calculation" "/top/tb/itf/timestamp\[63:0\]"
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 0)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 72)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 72)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvUnknownSaveResult -win $_nWave2 -clear
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 72 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
verdiDockWidgetRestore -dock windowDock_nWave_2
wvScrollDown -win $_nWave2 21
debReload
verdiDockWidgetMaximize -dock windowDock_nWave_2
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
wvScrollDown -win $_nWave2 0
wvZoomAll -win $_nWave2
debReload
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
verdiDockWidgetRestore -dock windowDock_nWave_2
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 27 )} 
wvSelectAll -win $_nWave2
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
srcHBSelect "top.tb" -win $_nTrace1
srcSetScope "top.tb" -delim "." -win $_nTrace1
srcHBSelect "top.tb" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -word -line 1 -pos 3 -win $_nTrace1
wvRenameGroup -win $_nWave2 {G2} {itf(tb_itf)#1}
wvAddSignal -win $_nWave2 "top/tb/itf/stu_errors"
wvAddSignal -win $_nWave2 "/top/tb/itf/clk" "/top/tb/itf/reset_n" \
           "/top/tb/itf/instr_mem_resp" "/top/tb/itf/instr_read" \
           "/top/tb/itf/in\[31:0\]" "/top/tb/itf/instr_mem_address\[31:0\]" \
           "/top/tb/itf/res1_empty" "/top/tb/itf/res2_empty" \
           "/top/tb/itf/res3_empty" "/top/tb/itf/res4_empty" \
           "/top/tb/itf/resldst_empty" "/top/tb/itf/ldst_q_full" \
           "/top/tb/itf/rob_load" "/top/tb/itf/res1_load" \
           "/top/tb/itf/res2_load" "/top/tb/itf/res3_load" \
           "/top/tb/itf/res4_load" "/top/tb/itf/resldst_load" \
           "/top/tb/itf/regfile_tag1\[4:0\]" "/top/tb/itf/regfile_tag2\[4:0\]" \
           "/top/tb/itf/control_o" "/top/tb/itf/res1_exec" \
           "/top/tb/itf/res1_alu_out" "/top/tb/itf/res2_exec" \
           "/top/tb/itf/res2_alu_out" "/top/tb/itf/res3_exec" \
           "/top/tb/itf/res3_alu_out" "/top/tb/itf/res4_exec" \
           "/top/tb/itf/res4_alu_out" "/top/tb/itf/reg_src1_data\[31:0\]" \
           "/top/tb/itf/reg_src2_data\[31:0\]" "/top/tb/itf/src1_valid" \
           "/top/tb/itf/src2_valid" "/top/tb/itf/src_a\[4:0\]" \
           "/top/tb/itf/src_b\[4:0\]" "/top/tb/itf/src_c\[4:0\]" \
           "/top/tb/itf/dest\[4:0\]" "/top/tb/itf/tag_in\[2:0\]" \
           "/top/tb/itf/tag_a\[2:0\]" "/top/tb/itf/tag_b\[2:0\]" \
           "/top/tb/itf/tag_dest\[2:0\]" "/top/tb/itf/rd_rob_tag\[4:0\]" \
           "/top/tb/itf/robs_calculated\[0:7\]" "/top/tb/itf/ld_br" \
           "/top/tb/itf/rob0_valid" "/top/tb/itf/rob1_valid" \
           "/top/tb/itf/rob2_valid" "/top/tb/itf/rob3_valid" \
           "/top/tb/itf/rob4_valid" "/top/tb/itf/rob5_valid" \
           "/top/tb/itf/rob6_valid" "/top/tb/itf/rob7_valid" \
           "/top/tb/itf/regfile_allocate" "/top/tb/itf/regfile_load" \
           "/top/tb/itf/rob_full" "/top/tb/itf/ld_commit_sel" \
           "/top/tb/itf/data_read" "/top/tb/itf/data_write" \
           "/top/tb/itf/rob_tag\[2:0\]" "/top/tb/itf/rd_inflight\[4:0\]" \
           "/top/tb/itf/st_commit\[4:0\]" "/top/tb/itf/cdb_in\[0:7\]" \
           "/top/tb/itf/cdb_out\[0:7\]" "/top/tb/itf/alu1_calculation" \
           "/top/tb/itf/alu2_calculation" "/top/tb/itf/alu3_calculation" \
           "/top/tb/itf/alu4_calculation" "/top/tb/itf/timestamp\[63:0\]"
wvSetPosition -win $_nWave2 {("itf(tb_itf)#1" 0)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)#1" 68)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)#1" 68)}
wvSetPosition -win $_nWave2 {("G3" 0)}
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvSetCursor -win $_nWave2 527.899033 -snap {("itf(tb_itf)#1" 47)}
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)#1" 46 )} 
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)#1" 44 )} 
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)#1" 45 )} 
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
