onerror {resume}
radix define fixed#22#decimal#signed -fixed -fraction 22 -signed -base signed -precision 6
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TOP -color Gray40 /tb_mandelbrot/clk
add wave -noupdate -expand -group TOP -color Gray40 /tb_mandelbrot/done
add wave -noupdate -expand -group TOP -color Gray40 /tb_mandelbrot/rst
add wave -noupdate -expand -group TOP -color Gray40 /tb_mandelbrot/start
add wave -noupdate -expand -group TOP -color Gray40 /tb_mandelbrot/vga_colour
add wave -noupdate -expand -group TOP /tb_mandelbrot/vga_plot
add wave -noupdate -expand -group TOP -radix unsigned /tb_mandelbrot/vga_x
add wave -noupdate -expand -group TOP -radix unsigned /tb_mandelbrot/vga_y
add wave -noupdate -expand -group SM /tb_mandelbrot/MB/SM/current
add wave -noupdate -expand -group COND /tb_mandelbrot/MB/dist_gt_max_dist
add wave -noupdate -expand -group COND /tb_mandelbrot/MB/n_equals_iterations
add wave -noupdate -expand -group COND /tb_mandelbrot/MB/donei
add wave -noupdate -expand -group COND /tb_mandelbrot/MB/donej
add wave -noupdate -expand -group CALC /tb_mandelbrot/MB/distance
add wave -noupdate -expand -group CONST -radix fixed#22#decimal#signed /tb_mandelbrot/MB/max_distance
add wave -noupdate -expand -group REG -radix unsigned /tb_mandelbrot/MB/i
add wave -noupdate -expand -group REG -radix unsigned /tb_mandelbrot/MB/n
add wave -noupdate -group INIT /tb_mandelbrot/MB/inita
add wave -noupdate -group INIT /tb_mandelbrot/MB/initb
add wave -noupdate -group INIT /tb_mandelbrot/MB/initi
add wave -noupdate -group INIT /tb_mandelbrot/MB/initj
add wave -noupdate -group INIT /tb_mandelbrot/MB/initn
add wave -noupdate -group INIT /tb_mandelbrot/MB/initx
add wave -noupdate -group INIT /tb_mandelbrot/MB/inity
add wave -noupdate -expand -group EN /tb_mandelbrot/MB/ena
add wave -noupdate -expand -group EN /tb_mandelbrot/MB/enb
add wave -noupdate -expand -group EN /tb_mandelbrot/MB/eni
add wave -noupdate -expand -group EN /tb_mandelbrot/MB/enj
add wave -noupdate -expand -group EN -color Salmon /tb_mandelbrot/MB/enn
add wave -noupdate -expand -group EN /tb_mandelbrot/MB/enx
add wave -noupdate -expand -group EN /tb_mandelbrot/MB/eny
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {30 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 190
configure wave -valuecolwidth 230
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
WaveRestoreZoom {0 ps} {42 ps}
