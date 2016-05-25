onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /testbench_top/state
add wave -noupdate -radix binary /testbench_top/demo/MasterFSM/next_state
add wave -noupdate -radix binary /testbench_top/rst
add wave -noupdate /testbench_top/set
add wave -noupdate /testbench_top/start
add wave -noupdate /testbench_top/suspend
add wave -noupdate /testbench_top/turn_zero
add wave -noupdate /testbench_top/restart
add wave -noupdate -radix binary /testbench_top/ss
add wave -noupdate -radix binary /testbench_top/miso
add wave -noupdate -radix binary /testbench_top/mosi
add wave -noupdate -radix binary /testbench_top/sclk
add wave -noupdate -radix hexadecimal /testbench_top/demo/spi/send_data
add wave -noupdate -radix binary /testbench_top/demo/MasterFSM/current_state
add wave -noupdate -radix unsigned /testbench_top/demo/MasterFSM/current_value
add wave -noupdate /testbench_top/demo/MasterFSM/sus_click
add wave -noupdate -radix binary /testbench_top/demo/end_transmission
add wave -noupdate -radix binary /testbench_top/demo/begin_transmission
add wave -noupdate -radix unsigned /testbench_top/demo/MasterFSM/count_end
add wave -noupdate -radix binary /testbench_top/demo/MasterFSM/end_display
add wave -noupdate -expand -group SPI /testbench_top/demo/spi/begin_transmission
add wave -noupdate -expand -group SPI /testbench_top/demo/spi/end_transmission
add wave -noupdate -expand -group SPI /testbench_top/demo/spi/mosi
add wave -noupdate -expand -group SPI /testbench_top/demo/spi/sclk
add wave -noupdate -expand -group SPI /testbench_top/demo/spi/send_data
add wave -noupdate -expand -group SPI /testbench_top/demo/spi/shift_register
add wave -noupdate -expand -group SPI /testbench_top/demo/spi/slave_select
add wave -noupdate -expand -group SPI /testbench_top/demo/spi/STATE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2862650000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 289
configure wave -valuecolwidth 69
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
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ps} {38325010500 ps}
