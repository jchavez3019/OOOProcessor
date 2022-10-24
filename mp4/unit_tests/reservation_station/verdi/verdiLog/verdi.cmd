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
wvSetCursor -win $_nWave2 24829.879081 -snap {("itf(reservation_station_itf)" 3)}
wvSetCursor -win $_nWave2 25749.504232 -snap {("itf(reservation_station_itf)" 3)}
wvZoom -win $_nWave2 0.000000 31727.067715
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 26 )} 
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 26)}
wvExpandBus -win $_nWave2
wvSetCursor -win $_nWave2 26701.377424 -snap {("itf(reservation_station_itf)" 3)}
wvSetCursor -win $_nWave2 27526.204456 -snap \
           {("itf(reservation_station_itf)" 26)}
wvSetCursor -win $_nWave2 12408.938153 -snap \
           {("itf(reservation_station_itf)" 26)}
wvSetCursor -win $_nWave2 10625.009920 -snap \
           {("itf(reservation_station_itf)" 26)}
wvSetCursor -win $_nWave2 10625.009920 -snap \
           {("itf(reservation_station_itf)" 26)}
wvSetCursor -win $_nWave2 10126.277295 -snap \
           {("itf(reservation_station_itf)" 24)}
wvSetCursor -win $_nWave2 9992.003127 -snap {("itf(reservation_station_itf)" 24)}
wvSetCursor -win $_nWave2 27447.644977 -snap \
           {("itf(reservation_station_itf)" 26)}
wvSetCursor -win $_nWave2 26565.271873 -snap {("itf(reservation_station_itf)" 0)}
wvSetCursor -win $_nWave2 26565.271873 -snap {("itf(reservation_station_itf)" 1)}
wvSetCursor -win $_nWave2 27466.827001 -snap \
           {("itf(reservation_station_itf)" 25)}
wvSetCursor -win $_nWave2 26637.001317 -snap {("itf(reservation_station_itf)" 3)}
wvSetCursor -win $_nWave2 27557.738470 -snap \
           {("itf(reservation_station_itf)" 26)}
wvSetCursor -win $_nWave2 26521.909173 -snap {("itf(reservation_station_itf)" 1)}
wvSetCursor -win $_nWave2 25581.989997 -snap {("itf(reservation_station_itf)" 1)}
wvSetCursor -win $_nWave2 26541.091197 -snap {("itf(reservation_station_itf)" 1)}
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
wvZoomAll -win $_nWave2
wvSetCursor -win $_nWave2 25580.356711 -snap {("itf(reservation_station_itf)" 3)}
wvSetCursor -win $_nWave2 26443.497582 -snap {("itf(reservation_station_itf)" 3)}
wvSetCursor -win $_nWave2 26443.497582 -snap {("itf(reservation_station_itf)" 3)}
wvSetCursor -win $_nWave2 25423.422007 -snap {("itf(reservation_station_itf)" 3)}
wvSetCursor -win $_nWave2 25894.226119 -snap \
           {("itf(reservation_station_itf)" 14)}
wvSetCursor -win $_nWave2 26678.899637 -snap {("itf(reservation_station_itf)" 3)}
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
wvZoom -win $_nWave2 0.000000 39390.610641
wvSetCursor -win $_nWave2 27340.036890 -snap {("itf(reservation_station_itf)" 3)}
wvSetCursor -win $_nWave2 27554.375158 -snap {("itf(reservation_station_itf)" 3)}
wvSetCursor -win $_nWave2 28483.174321 -snap {("itf(reservation_station_itf)" 3)}
wvSetCursor -win $_nWave2 26601.760632 -snap {("itf(reservation_station_itf)" 3)}
wvSetCursor -win $_nWave2 27506.744432 -snap {("itf(reservation_station_itf)" 3)}
wvSetCursor -win $_nWave2 26554.129906 -snap {("itf(reservation_station_itf)" 3)}
wvSetCursor -win $_nWave2 27435.298342 -snap {("itf(reservation_station_itf)" 3)}
wvSetCursor -win $_nWave2 26625.575995 -snap {("itf(reservation_station_itf)" 3)}
wvSetCursor -win $_nWave2 27530.559795 -snap {("itf(reservation_station_itf)" 3)}
debReload
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 26 )} 
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 26)}
wvCollapseBus -win $_nWave2
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 26)}
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 26 )} 
wvExpandBus -win $_nWave2
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 29 )} 
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 26 )} 
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 3 )} 
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 3)}
wvExpandBus -win $_nWave2
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 65)}
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 3 )} 
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 3)}
wvCollapseBus -win $_nWave2
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 3)}
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 33)}
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 4 )} 
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 4)}
wvCollapseBus -win $_nWave2
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 4)}
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 24)}
verdiDockWidgetRestore -dock windowDock_nWave_2
srcDeselectAll -win $_nTrace1
srcSelect -signal "res_word" -line 21 -pos 1 -win $_nTrace1
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 3)}
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 4)}
wvAddSignal -win $_nWave2 "/top/tb/res/res_word"
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 4)}
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 5)}
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 5 )} 
wvExpandBus -win $_nWave2
wvSetCursor -win $_nWave2 26530.314543 -snap {("itf(reservation_station_itf)" 3)}
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 12 )} 
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 9 12 )} 
debReload
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 9 )} 
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 9 12 )} 
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 4 )} 
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 4)}
wvExpandBus -win $_nWave2
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 25)}
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 4 )} 
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 4)}
wvCollapseBus -win $_nWave2
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 4)}
wvSetPosition -win $_nWave2 {("itf(reservation_station_itf)" 16)}
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 9 )} 
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 9 12 )} 
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 9 12 27 )} 
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 9 12 27 28 )} 
debReload
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 28 )} 
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 27 28 )} 
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 12 27 28 )} 
wvSelectSignal -win $_nWave2 {( "itf(reservation_station_itf)" 9 12 27 28 )} 
wvSetCursor -win $_nWave2 26982.806443 -snap \
           {("itf(reservation_station_itf)" 27)}
debReload
wvSetCursor -win $_nWave2 26577.945269 -snap {("itf(reservation_station_itf)" 1)}
wvSetCursor -win $_nWave2 27506.744432 -snap {("itf(reservation_station_itf)" 1)}
wvSetCursor -win $_nWave2 27435.298342 -snap {("itf(reservation_station_itf)" 1)}
wvSetCursor -win $_nWave2 26577.945269 -snap \
           {("itf(reservation_station_itf)" 27)}
wvSetCursor -win $_nWave2 28078.313147 -snap \
           {("itf(reservation_station_itf)" 27)}
wvSetCursor -win $_nWave2 26577.945269 -snap \
           {("itf(reservation_station_itf)" 27)}
wvSetCursor -win $_nWave2 27625.821248 -snap {("itf(reservation_station_itf)" 1)}
wvSetCursor -win $_nWave2 26435.053090 -snap {("itf(reservation_station_itf)" 1)}
debReload
wvSetCursor -win $_nWave2 27625.821248 -snap {("itf(reservation_station_itf)" 1)}
debReload
debReload
wvSetCursor -win $_nWave2 26625.575996 -snap {("itf(reservation_station_itf)" 1)}
debReload
debReload
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
wvSetCursor -win $_nWave2 28459.358958 -snap {("itf(reservation_station_itf)" 1)}
