simSetSimulator "-vcssv" -exec \
           "/home/jiwonl4/ece411_mp4/mp4/mp4/unit_tests/instruction_queue/sim/simv" \
           -args "+lint=all,noSVA-UA,noNS,noSVA-AECASR +v2k"
debImport "-dbdir" \
          "/home/jiwonl4/ece411_mp4/mp4/mp4/unit_tests/instruction_queue/sim/simv.daidir"
debLoadSimResult \
           /home/jiwonl4/ece411_mp4/mp4/mp4/unit_tests/instruction_queue/sim/dump.fsdb
wvCreateWindow
srcHBSelect "top.tb" -win $_nTrace1
srcSetScope "top.tb" -delim "." -win $_nTrace1
srcHBSelect "top.tb" -win $_nTrace1
srcHBSelect "top.tb" -win $_nTrace1
