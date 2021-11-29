onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate {/lab7_tb/TB/MEM/mem[18]}
add wave -noupdate {/lab7_tb/TB/MEM/mem[17]}
add wave -noupdate {/lab7_tb/TB/MEM/mem[16]}
add wave -noupdate {/lab7_tb/TB/MEM/mem[5]}
add wave -noupdate {/lab7_tb/TB/MEM/mem[4]}
add wave -noupdate {/lab7_tb/TB/MEM/mem[3]}
add wave -noupdate {/lab7_tb/TB/MEM/mem[2]}
add wave -noupdate {/lab7_tb/TB/MEM/mem[1]}
add wave -noupdate {/lab7_tb/TB/MEM/mem[0]}
add wave -noupdate /lab7_tb/TB/CPU/DP/REGFILE/R0
add wave -noupdate /lab7_tb/TB/CPU/DP/REGFILE/R1
add wave -noupdate /lab7_tb/TB/CPU/DP/REGFILE/R2
add wave -noupdate /lab7_tb/TB/CPU/DP/REGFILE/R3
add wave -noupdate /lab7_tb/TB/CPU/PC
add wave -noupdate /lab7_tb/TB/CPU/mem_addr
add wave -noupdate /lab7_tb/TB/CPU/mem_cmd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {265 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 212
configure wave -valuecolwidth 107
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {91 ps} {311 ps}
