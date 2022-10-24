simSetSimulator "-vcssv" -exec \
           "/home/jorgejc2/Documents/ece411/mp1/reservation_station/sim/simv" \
           -args "+lint=all,noSVA-UA,noNS,noSVA-AECASR +v2k"
debImport "-dbdir" \
          "/home/jorgejc2/Documents/ece411/mp1/reservation_station/sim/simv.daidir"
debLoadSimResult \
           /home/jorgejc2/Documents/mp4/mp4/unit_tests/reservation_station/sim/dump.fsdb
wvCreateWindow
srcDeselectAll -win $_nTrace1
srcSelect -word -line 3 -pos 2 -win $_nTrace1
wvRenameGroup -win $_nWave2 {G1} {itf(reservation_station_itf)}
wvAddSignal -win $_nWave2 "top/itf/stu_errors"
wvAddSignal -win $_nWave2 "/top/itf/clk" "/top/itf/reset_n" "/top/itf/load_word" \
           "/top/itf/rob_v1" "/top/itf/rob_v2" "/top/itf/alu_free" \
           "/top/itf/start_exe" "/top/itf/res_empty" "/top/itf/control_word" \
           "/top/itf/src1\[31:0\]" "/top/itf/src2\[31:0\]" "/top/itf/cdb" \
           "/top/itf/rob_tag1\[2:0\]" "/top/itf/rob_tag2\[2:0\]" \
           "/top/itf/alu_data" "/top/itf/timestamp\[63:0\]"
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 0)}
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 16)}
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 16)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetCursor -win $_nWave2 9970.269347 -snap {("itf(reservation_station_itf)" 9)}
wvScrollDown -win $_nWave2 1
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
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
srcHBSelect "top.tb" -win $_nTrace1
srcSetScope "top.tb" -delim "." -win $_nTrace1
srcHBSelect "top.tb" -win $_nTrace1
debReload
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvZoomAll -win $_nWave2
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 16 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetCursor -win $_nWave2 23833.618501 -snap \
           {("itf(reservation_station_itf)" 15)}
verdiDockWidgetRestore -dock windowDock_nWave_2
srcHBSelect "top.tb.res" -win $_nTrace1
srcSetScope "top.tb.res" -delim "." -win $_nTrace1
srcHBSelect "top.tb.res" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "state" -line 29 -pos 1 -win $_nTrace1
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 0)}
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 1)}
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 2)}
wvAddSignal -win $_nWave2 "/top/tb/res/state\[31:0\]"
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 2)}
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 3)}
srcDeselectAll -win $_nTrace1
srcSelect -signal "alu_data" -line 16 -pos 1 -win $_nTrace1
wvScrollDown -win $_nWave2 8
wvScrollDown -win $_nWave2 1
wvScrollUp -win $_nWave2 9
srcDeselectAll -win $_nTrace1
srcSelect -signal "control_word" -line 7 -pos 1 -win $_nTrace1
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 5)}
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 16)}
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 3)}
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 2)}
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 3)}
wvAddSignal -win $_nWave2 "/top/tb/res/control_word"
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 3)}
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 4)}
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 4 )} 
wvExpandBus -win $_nWave2
