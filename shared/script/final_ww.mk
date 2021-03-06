# ALPHA is linked with standard versions of various libraries
# taken from $(ALEPH)/lib etc. 
# > gmake     or  > gmake DBX=_dbx
#
# to link WITH JUL285 (old tracking from before May97) and then link with the
# corresponding alephlib ($(ALEPH)/gen/libalephio216.a, alephlib version 216) 
# > gmake WITH=JUL285   or  > gmake WITH=JUL285 DBX=_dbx
#
# to link with a different version of alpha
# > gmake AVER=123  or > gmake AVER=123 WITH=JUL285
#fj_test.mk
# to change the name of the module
## > gmake AVER=123 WITH=JUL285 NAME=enflw123 DBX=_dbx
# > gmake AVER=123 WITH=JUL285 DBX=_dbx
#
# to link with jetset
# > gmake CLIB=jetset WITH=JUL285
#
# to link with user library
# > gmake ULIB=/u/xu/myid/lmylib.a
#
# libraries are linked in the following order:
# ULIB alpha mini julia alephlib bos77 CERNLIBS
#
# ================================================================

include $(ALEPH)/phy/alpha.version
include $(ALEPH)/phy/mini.version

STR_g=
DBX=
ifeq ($(DBX),_dbx)
  STR_g=-g
endif
#ifeq ($(debug),y)
#  STR_g=-g
#  DBX=_dbx
#endif

AVER      = $(alphaver)
MVER      = $(miniver)
MAIN      = $(ALEPH)/phy/qmain.o $(ALEPH)/phy/qusig.o
WITH      =
NAME      = final_ww

# list of *.f files
fFILES    = 
FFILES    =  final_ww_lastmc.F
# *.f files are stored in srcdir
srcdir    =  .

# list of *.c files
CFILES  = 
# *.c files are stored in SRCDIR
SRCDIR  = 

# alpha *.h files are stored in IDIR
IDIR      = $(ALROOT)/alpha$(AVER)/inc
# general *.h files
INCDIR    =$(ALROOT)/inc

# link with some specific cernlib libraries (i.e.CLIB=jetset)
CLIB    = 

# link with some user libraries (i.e. ULIB=/u3/xu/flr/lib.a)
ULIB    =  matrix_qcd.o qnnwtag17.o mathkine.o

# ===============================================================

# set FORTRAN flags

CFLAGS  = $(STR_g) $(CCOPT) -I$(IDIR)
FFLAGS  = $(STR_g) $(FCOPT) -I$(IDIR) 
ifeq ($(OS),OSF1)
  FFLAGS += -fpe2
endif

ALIB    = -lalpha$(AVER) -lmini$(MVER)$(DBX)
#ALIB    = -lalpha$(AVER)$(DBX) -lmini$(MVER)$(DBX)

# link with julia (i.e.WITH=JUL285)
ifeq ($(WITH),JUL285)  
  ALIB     += -ljul285$(DBX) -lalephio216$(DBX)
else
  ALIB     += -ljulia$(DBX) -lalephlib$(DBX) 
endif
LDFLAGS     = $(JMUID) $(UNDEF) -L$(ALEPH)/lib -L$(ALEPH)/phy -L$(ALEPH)/jul  -L$(ALEPH)/gen
##LDFLAGS    = $(UNDEF) -L$(ALEPH)/lib -L$(ALEPH)/phy -L$(ALEPH)/jul  -L$(ALEPH)/gen

ALIB       += -lbos77$(DBX)
CERNLIBS = `cernlib $(CLIB) mathlib packlib shift`

vpath %.F $(srcdir)
vpath %.f $(srcdir)
vpath %.c $(SRCDIR)

# *.o files are stored in $(OBJDIR)

OBJDIR  = ./
vpath %.o $(OBJDIR):

O_FILES  := $(FFILES:%.F=%.o) $(fFILES:%.f=%.o) $(CFILES:%.c=%.o) 
OBJFILES := $(addprefix $(OBJDIR)/,$(notdir $(O_FILES)))


# Rules...

$(OBJDIR)/%.o : %.f
	$(FC) $(FFLAGS) $< -o $@

$(OBJDIR)/%.o : %.F
	$(FC) $(FFLAGS) $< -o $@

$(OBJDIR)/%.o : %.c
	$(CC) $(CFLAGS)  $< -o $@

$(OBJDIR)/$(NAME): $(OBJFILES) 
	$(FC) -w $(STR_g) -o $@  $(MAIN) $(OBJFILES) -I$(INCDIR) -I$(IDIR)  $(LDFLAGS) $(ULIB) $(ALIB) $(CERNLIBS)


.PHONY: help
help:
	@echo " ALPHA is linked with standard versions of various libraries"
	@echo " taken from $(ALEPH)/lib"
	@echo " to link with standard versions with (new tracking May97):"
	@echo " > gmake     or  > gmake DBX=_dbx"
	@echo ""
	@echo " to link WITH JUL285:"
	@echo " > gmake WITH=JUL285   or  > gmake WITH=JUL285 DBX=_dbx"
	@echo ""
	@echo " to link with a different version of alpha"
	@echo " > gmake AVER=123  or > gmake AVER=123 WITH=JUL285"
	@echo ""
	@echo " to change the name of the module"
	@echo " > gmake AVER=123 WITH=JUL285 DBX=_dbx"
	@echo ""
	@echo " to link with jetset"
	@echo " > gmake CLIB=jetset WITH=JUL285"
	@echo ""
	@echo " to link with user library"
	@echo " > gmake ULIB=/u/xu/myid/lmylib.a
	@echo ""
	@echo " libraries are linked in the following order:"
	@echo " ULIB alpha mini JUL285 alephlib bos77 CERNLIBS"

