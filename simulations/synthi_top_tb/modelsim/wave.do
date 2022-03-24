onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /synthi_top_tb/CLOCK_50
add wave -noupdate -radix hexadecimal /synthi_top_tb/KEY_0
add wave -noupdate -radix hexadecimal /synthi_top_tb/USB_TXD
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/inst1/rx_data_rdy
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/inst1/rx_data
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/inst1/b2v_inst2/start_bit
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/inst1/b2v_inst2/baud_tick
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/inst1/b2v_inst2/count
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/inst1/b2v_inst10/parallel_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ns} {538 ns}
