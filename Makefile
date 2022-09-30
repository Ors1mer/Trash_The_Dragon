CC = fpc 	     	   # Free Pascal Compiler
CFLAGS_DEV = -g  	   # debugging
CFLAGS = -O2 -dINSTALL # optimization level 2

SRCMAIN = ttd.pas
SRCMODULES = -Fuunits
SRC = $(SRCMAIN) $(SRCMODULES)
OBJMODULES = units/*.ppu units/*.o

BINNAME = ./ttd
BINDIR_INS = $${HOME}/.local/bin/
PICNAME = ./data/dragon_pic.asc
PICDIR_INS = $${HOME}/.config/ttd/

MV = mv
CP = cp
RM = rm -f

dev:
	$(CC) $(CFLAGS_DEV) $(SRC)
	$(MV) $(BINNAME) $(BINNAME)_dev

ttd:
	$(CC) $(CFLAGS) $(SRC)

.PHONY:
install: $(BINNAME) $(BINDIR_INS) $(PICDIR_INS)
	$(CP) $(BINNAME) $(BINDIR_INS)
	$(CP) $(PICNAME) $(PICDIR_INS)

uninstall:
	$(RM) $(BINDIR_INS)$(BINNAME)
	$(RM) -r $(PICDIR_INS)

# Create directory if not exist
$${HOME}/%/:
	mkdir -p $@

.SILENT:
clean:
	$(RM) ./*.o $(OBJMODULES) $(BINNAME) $(BINNAME)_dev
