fpga:
	iverilog TB_vgadriver.v vgadriver.v vgaout.v container_switcher.v button_debouncer.v f1_keyproc.v f1_vram.v f2_gpu.v f2_keyproc.v f3_gpu.v f3_keyproc.v f3_ram.v constant.v img_vrom.v img_mapper.v keyboard_proc.v

simulate:
	vvp a.out

clean:
	rm a.out TB_vgadriver.vcd