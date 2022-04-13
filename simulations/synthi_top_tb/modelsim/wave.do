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
add wave -noupdate /synthi_top_tb/DUT/inst2/fsm_state
add wave -noupdate -expand /synthi_top_tb/DUT/ins3/DACDAT_pl_i
add wave -noupdate /synthi_top_tb/DUT/ins3/DACDAT_pr_i
add wave -noupdate /synthi_top_tb/DUT/ins3/ADCDAT_pl_o
add wave -noupdate /synthi_top_tb/DUT/ins3/ADCDAT_pr_o
add wave -noupdate /synthi_top_tb/DUT/ins3/ADCDAT_s_i
add wave -noupdate /synthi_top_tb/DUT/ins3/DACDAT_s_o
add wave -noupdate /synthi_top_tb/DUT/ins3/load_sig
add wave -noupdate /synthi_top_tb/DUT/ins3/shift_l
add wave -noupdate /synthi_top_tb/DUT/ins3/shift_r
add wave -noupdate /synthi_top_tb/DUT/ins3/inst0/load
add wave -noupdate /synthi_top_tb/DUT/ins3/inst4/ws_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {80 ns} 0}
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
WaveRestoreZoom {0 ns} {1659 ns}
