@echo off
echo Clean the original file...
del /F /S /Q a.out
del /F /S /Q TB_vgadriver.vcd
echo Generating a.out
iverilog keyboard_proc.v img_mapper.v container_switcher.v f1_keyproc.v f1_vram.v f2_gpu.v f2_keyproc.v img_vrom.v TB_vgadriver.v vgadriver.v vgaout.v
echo Simulating...
vvp a.out
echo Launching GTKWave...
gtkwave TB_vgadriver.vcd