APP=ip-country-info

$(APP): $(APP).o    
	gcc -o $(APP) $(APP).o `pkg-config --cflags --libs gtk+-2.0` -export-dynamic -lcurl 
	
$(APP).o: $(APP).asm
	nasm -f elf $(APP).asm 
