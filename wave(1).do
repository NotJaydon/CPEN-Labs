onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab7_check_tb/err
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/PC
add wave -noupdate /lab7_check_tb/DUT/CPU/reset_pc
add wave -noupdate /lab7_check_tb/DUT/CPU/load_pc
add wave -noupdate /lab7_check_tb/DUT/CPU/increment_out
add wave -noupdate /lab7_check_tb/DUT/CPU/next_pc
add wave -noupdate /lab7_check_tb/DUT/CPU/opcode
add wave -noupdate /lab7_check_tb/DUT/CPU/controller_fsm_1/present_state
add wave -noupdate /lab7_check_tb/DUT/CPU/clk
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/R0
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/R1
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/R2
add wave -noupdate /lab7_check_tb/DUT/CPU/read_data
add wave -noupdate /lab7_check_tb/DUT/CPU/data_address_out
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/R0
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/datapath_out
add wave -noupdate /lab7_check_tb/DUT/enable
add wave -noupdate /lab7_check_tb/DUT/enablewrite
add wave -noupdate /lab7_check_tb/DUT/CPU/mem_addr
add wave -noupdate /lab7_check_tb/DUT/is_read_command
add wave -noupdate /lab7_check_tb/DUT/is_memory_address
add wave -noupdate /lab7_check_tb/DUT/CPU/mem_cmd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {158 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 287
configure wave -valuecolwidth 217
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
WaveRestoreZoom {116 ps} {189 ps}
