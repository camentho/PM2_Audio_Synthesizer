onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/DUT/CLOCK_50
add wave -noupdate /synthi_top_tb/DUT/inst0/clk_12M
add wave -noupdate /synthi_top_tb/DUT/clk_6M
add wave -noupdate -format Analog-Step -height 74 -max 3999.9999999999995 -min -4000.0 -radix decimal /synthi_top_tb/DUT/inst5/dacdat_pl_o
add wave -noupdate -format Analog-Step -height 74 -max 3999.9999999999995 -min -4000.0 -radix decimal /synthi_top_tb/DUT/inst5/dacdat_pr_o
add wave -noupdate /synthi_top_tb/DUT/inst7/clk_6m
add wave -noupdate /synthi_top_tb/DUT/inst7/rx_data
add wave -noupdate /synthi_top_tb/DUT/inst7/rx_data_rdy
add wave -noupdate /synthi_top_tb/DUT/inst7/reset_n
add wave -noupdate /synthi_top_tb/DUT/inst7/note
add wave -noupdate /synthi_top_tb/DUT/inst7/velocity
add wave -noupdate /synthi_top_tb/DUT/inst7/fsm_status
add wave -noupdate /synthi_top_tb/DUT/inst7/next_fsm_status
add wave -noupdate /synthi_top_tb/DUT/inst7/status_reg
add wave -noupdate /synthi_top_tb/DUT/inst7/next_status_reg
add wave -noupdate /synthi_top_tb/DUT/inst7/data1_reg
add wave -noupdate /synthi_top_tb/DUT/inst7/next_data1_reg
add wave -noupdate /synthi_top_tb/DUT/inst7/data2_reg
add wave -noupdate /synthi_top_tb/DUT/inst7/next_data2_reg
add wave -noupdate /synthi_top_tb/DUT/inst6/tone_on
add wave -noupdate /synthi_top_tb/DUT/inst6/note_l
add wave -noupdate /synthi_top_tb/DUT/inst6/velocity_i
add wave -noupdate /synthi_top_tb/DUT/inst6/dds_l_o
add wave -noupdate /synthi_top_tb/DUT/inst6/dds_r_o
add wave -noupdate /synthi_top_tb/DUT/inst6/sum_reg
add wave -noupdate /synthi_top_tb/DUT/inst6/next_sum_reg
add wave -noupdate /synthi_top_tb/DUT/inst6/step_i_signal
add wave -noupdate /synthi_top_tb/DUT/inst6/clk_signal
add wave -noupdate /synthi_top_tb/DUT/inst6/reset_signal
add wave -noupdate /synthi_top_tb/DUT/inst6/tone_on_signal
add wave -noupdate /synthi_top_tb/DUT/inst6/dds_o_array
add wave -noupdate /synthi_top_tb/DUT/inst6/note_l_array
add wave -noupdate /synthi_top_tb/DUT/inst6/velocity_array
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {307049 ns} 0}
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
WaveRestoreZoom {0 ns} {1751604 ns}
