PY := python3

%.asm: ;
%.inc: ;
%.bin: ;
%.raw: ;
DevSound.gb: %.asm %.inc %.bin
	rgbasm -o DevSound.obj -p 255 Main.asm
	rgblink -p 255 -o DevSound.gb -n DevSound.sym DevSound.obj
	rgbfix -v -p 255 DevSound.gb

#DevSound.gbs: %.asm %.inc %.bin
#	$(PY) makegbs.py