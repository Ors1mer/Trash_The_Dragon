CC = fpc 	 # Free Pascal Compiler
CFLAGS = -O2 # optimization level 2

SRCMAIN = ttd.pas
SRCMODULES = -Fuunits
OBJMODULES = units/*.ppu units/*.o
SRC = $(SRCMAIN) $(SRCMODULES)

BINNAME = ./ttd
BINDIR_INS = $${HOME}/.local/bin/
CP = cp
RM = rm -f

ttd:
	$(CC) $(CFLAGS) $(SRC)

.PHONY:
install: $(BINNAME) $(BINDIR_INS)
	$(CP) $(BINNAME) $(BINDIR_INS)

# Create directory if not exist
$${HOME}/%/:
	mkdir -p $@

.SILENT:
clean:
	$(RM) ./*.o $(OBJMODULES) ttd
