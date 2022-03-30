onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/DUT/CLOCK_50
add wave -noupdate /synthi_top_tb/DUT/inst0/clk_12M
add wave -noupdate /synthi_top_tb/DUT/clk_6M
add wave -noupdate /synthi_top_tb/DUT/USB_TXD
add wave -noupdate /synthi_top_tb/DUT/reset_n
add wave -noupdate /synthi_top_tb/DUT/serial_data
add wave -noupdate /synthi_top_tb/DUT/writes
add wave -noupdate /synthi_top_tb/DUT/write_data
add wave -noupdate /synthi_top_tb/DUT/write_done
add wave -noupdate /synthi_top_tb/DUT/inst3/write_data_o
add wave -noupdate /synthi_top_tb/DUT/inst3/write_o
add wave -noupdate /synthi_top_tb/DUT/inst3/count
add wave -noupdate /synthi_top_tb/DUT/inst3/write_done_i
add wave -noupdate /synthi_top_tb/DUT/inst2/fsm_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5079699 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 420
configure wave -valuecolwidth 100
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
configure wave -timelineunits ns
update
WaveRestoreZoom {5079649 ns} {5080356 ns}
