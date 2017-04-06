fpga:
	iverilog vgadriver.v vgaout.v container_switcher.v f1_keyproc.v f1_vram.v f2_gpu.v f2_keyproc.v constant.v img_vrom.v keyboard_proc.v

simulate:
	iverilog TB_vgadriver.v vgadriver.v vgaout.v container_switcher.v f1_keyproc.v f1_vram.v f2_gpu.v f2_keyproc.v constant.v img_vrom.v keyboard_proc.v
	vvp a.out

clean:
	rm a.out TB_vgadriver.vcd