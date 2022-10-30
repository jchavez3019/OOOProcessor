simSetSimulator "-vcssv" -exec \
           "/home/jorgejc2/Documents/mp4/mp4/unit_tests/instruction_queue/sim/simv" \
           -args "+lint=all,noSVA-UA,noNS,noSVA-AECASR +v2k"
debImport "-dbdir" \
          "/home/jorgejc2/Documents/mp4/mp4/unit_tests/instruction_queue/sim/simv.daidir"
debLoadSimResult \
           /home/jorgejc2/Documents/mp4/mp4/unit_tests/instruction_queue/sim/dump.fsdb
wvCreateWindow
srcDeselectAll -win $_nTrace1
srcSelect -word -line 4 -pos 2 -win $_nTrace1
wvRenameGroup -win $_nWave2 {G1} {itf(tb_itf)}
wvAddSignal -win $_nWave2 "top/itf/stu_errors"
wvAddSignal -win $_nWave2 "/top/itf/clk" "/top/itf/reset_n" \
           "/top/itf/instr_mem_resp" "/top/itf/instr_read" \
           "/top/itf/in\[31:0\]" "/top/itf/instr_mem_address\[31:0\]" \
           "/top/itf/res1_empty" "/top/itf/res2_empty" "/top/itf/res3_empty" \
           "/top/itf/res4_empty" "/top/itf/resldst_empty" "/top/itf/rob_full" \
           "/top/itf/ldst_q_full" "/top/itf/enqueue" "/top/itf/rob_load" \
           "/top/itf/res1_load" "/top/itf/res2_load" "/top/itf/res3_load" \
           "/top/itf/res4_load" "/top/itf/resldst_load" \
           "/top/itf/regfile_tag1\[2:0\]" "/top/itf/regfile_tag2\[2:0\]" \
           "/top/itf/control_o" "/top/itf/timestamp\[63:0\]"
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 0)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 24)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 24)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvUnknownSaveResult -win $_nWave2 -clear
srcDeselectAll -win $_nTrace1
srcSelect -inst "tb" -line 7 -pos 1 -win $_nTrace1
srcAction -pos 6 2 1 -win $_nTrace1 -name "tb" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -inst "ir" -line 11 -pos 2 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -inst "ir" -line 11 -pos 2 -win $_nTrace1
srcAction -pos 10 2 0 -win $_nTrace1 -name "ir" -ctrlKey off
wvScrollDown -win $_nWave2 1
srcDeselectAll -win $_nTrace1
srcSelect -signal "state" -line 58 -pos 1 -win $_nTrace1
srcSelect -win $_nTrace1 -range {58 58 3 3 4 5} -backward
srcDeselectAll -win $_nTrace1
srcSelect -signal "state" -line 58 -pos 1 -win $_nTrace1
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 18)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 20)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 22)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvAddSignal -win $_nWave2 "/top/tb/ir/state\[31:0\]"
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSetPosition -win $_nWave2 {("G2" 1)}
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
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 24 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 23 )} 
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 23)}
wvExpandBus -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 23 )} 
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 23)}
wvCollapseBus -win $_nWave2
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 23)}
wvSetPosition -win $_nWave2 {("G2" 1)}
verdiDockWidgetRestore -dock windowDock_nWave_2
srcHBSelect "top.tb.ir.iq_ir_itf" -win $_nTrace1
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 20)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 0)}
wvAddSubGroup -win $_nWave2 -holdpost {iq_ir_itf(IR_SIG)}
wvAddSignal -win $_nWave2 "/top/tb/ir/iq_ir_itf/issue_q_full_n" \
           "/top/tb/ir/iq_ir_itf/ack_o" "/top/tb/ir/iq_ir_itf/control_word" \
           "/top/tb/ir/iq_ir_itf/ld_iq"
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 0)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 4)}
wvSetPosition -win $_nWave2 {("G2" 0)}
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvSetCursor -win $_nWave2 10605.880558 -snap {("G3" 0)}
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
wvSetCursor -win $_nWave2 10411.277245 -snap {("G2" 6)}
verdiDockWidgetRestore -dock windowDock_nWave_2
srcHBSelect "top.tb.iq" -win $_nTrace1
srcSetScope "top.tb.iq" -delim "." -win $_nTrace1
srcDeselectAll -win $_nTrace1
debReload
srcDeselectAll -win $_nTrace1
srcSelect -signal "control_o" -line 26 -pos 1 -win $_nTrace1
wvScrollDown -win $_nWave2 7
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 14)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 19)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 1)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 0)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 2)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 1)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 0)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 1)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 2)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 3)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 4)}
wvSetPosition -win $_nWave2 {("G2" 6)}
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G2" 6)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 4)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 3)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 2)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 1)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 0)}
wvAddSignal -win $_nWave2 "/top/tb/iq/control_o"
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 0)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 1)}
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 1 )} 
wvSetCursor -win $_nWave2 32498.753269 -snap {("G2" 0)}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 1 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 1)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 0)}
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 23 )} 
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
wvSetCursor -win $_nWave2 10605.880558 -snap {("iq_ir_itf(IR_SIG)" 3)}
debReload
debReload
wvSetCursor -win $_nWave2 11919.452921 -snap {("itf(tb_itf)" 22)}
wvSetCursor -win $_nWave2 12503.262860 -snap {("itf(tb_itf)" 22)}
wvSetCursor -win $_nWave2 11724.849608 -snap {("itf(tb_itf)" 22)}
debReload
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
wvZoom -win $_nWave2 0.000000 21163.110288
verdiDockWidgetRestore -dock windowDock_nWave_2
srcDeselectAll -win $_nTrace1
srcSelect -signal "enqueue" -line 36 -pos 1 -win $_nTrace1
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 21)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 22)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 0)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 1)}
wvAddSignal -win $_nWave2 "/top/tb/iq/enqueue"
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 1)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 2)}
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvSetCursor -win $_nWave2 3736.294536 -snap {("G3" 0)}
wvSetCursor -win $_nWave2 3099.740652 -snap {("G3" 0)}
wvSetCursor -win $_nWave2 5507.574909 -snap {("G2" 7)}
debReload
wvSetCursor -win $_nWave2 10480.075539 -snap {("iq_ir_itf(IR_SIG)" 2)}
wvSetCursor -win $_nWave2 11540.998679 -snap {("itf(tb_itf)" 22)}
wvSetCursor -win $_nWave2 12481.991377 -snap {("itf(tb_itf)" 22)}
wvSetCursor -win $_nWave2 11485.646168 -snap {("itf(tb_itf)" 22)}
verdiDockWidgetRestore -dock windowDock_nWave_2
srcDeselectAll -win $_nTrace1
srcSelect -signal "control_o_valid" -line 56 -pos 1 -win $_nTrace1
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 19)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 21)}
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 1)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 22)}
wvAddSignal -win $_nWave2 "/top/tb/iq/control_o_valid"
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 22)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 23)}
verdiDockWidgetMaximize -dock windowDock_nWave_2
debReload
wvSetCursor -win $_nWave2 5516.800328 -snap {("itf(tb_itf)" 1)}
debReload
wvSetCursor -win $_nWave2 12002.269610 -snap {("itf(tb_itf)" 3)}
wvSetCursor -win $_nWave2 12537.343889 -snap {("iq_ir_itf(IR_SIG)" 5)}
wvSetCursor -win $_nWave2 10535.428051 -snap {("iq_ir_itf(IR_SIG)" 4)}
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 4 )} 
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 4)}
wvExpandBus -win $_nWave2
wvSetCursor -win $_nWave2 7149.699422 -snap {("G3" 0)}
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 6 )} 
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 7 )} 
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 7 )} 
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 6 )} 
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 6 8 )} 
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 6 8 12 )} 
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 6 8 )} 
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 6 8 13 )} 
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 6 8 13 )} 
wvSetRadix -win $_nWave2 -format UDec
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 10 )} 
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 10 )} 
wvSetRadix -win $_nWave2 -format UDec
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 6 )} 
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 6 8 )} 
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 6 8 13 )} 
debReload
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 6 )} 
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 6 8 )} 
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 6 8 10 )} 
wvSelectSignal -win $_nWave2 {( "G2/iq_ir_itf(IR_SIG)" 6 8 10 13 )} 
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 22 )} 
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 22)}
wvExpandBus -win $_nWave2
wvSetPosition -win $_nWave2 {("G2/iq_ir_itf(IR_SIG)" 14)}
debReload
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 24 )} 
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 24 26 )} 
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 24 26 28 )} 
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 24 26 28 31 )} 
debReload
verdiDockWidgetRestore -dock windowDock_nWave_2
srcDeselectAll -win $_nTrace1
srcSelect -signal "res_snoop" -line 110 -pos 1 -win $_nTrace1
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 5)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 11)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 25)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 19)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 18)}
wvAddSignal -win $_nWave2 "/top/tb/iq/res_snoop\[3:0\]"
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 18)}
wvSetPosition -win $_nWave2 {("itf(tb_itf)" 19)}
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 19 )} 
wvSetRadix -win $_nWave2 -format Bin
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
debReload
debReload
debReload
wvSelectSignal -win $_nWave2 {( "itf(tb_itf)" 17 )} 
debReload
debReload
