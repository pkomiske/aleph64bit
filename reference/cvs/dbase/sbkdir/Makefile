# make a module of NAME which is given on the command line
# gmake NAME=eptoda
# gmake NAME=chkcrd
# gmake NAME=cardaf
# source file resides on /al/reference/dbase
#
SRCDIR  = $(MYROOT)/dbase
OBJDIR  = $(HOME)/$(OS)
NAME    = 
DBX     =

#

FFILES   = $(NAME).F
#
vpath %.F $(SRCDIR)/prog: $(SRCDIR)/subr
vpath %.o $(OBJDIR)
#
FFLAGS  = $(FCOPT) -I$(SRCDIR)/inc -g
#
LDFLAGS =
CERNLIBS = `cernlib mathlib packlib`

LIBS    = \
		$(ALEPH)/dbase/libdbase$(DBX).a \
		$(ALEPH)/gen/libalephlib$(DBX).a \
		$(ALEPH)/gen/libbos77$(DBX).a \
		$(CERNLIBS)

# Rules...
O_FILES  := $(FFILES:%.F=%.o)
OBJFILES := $(addprefix $(OBJDIR)/,$(notdir $(O_FILES)))


$(OBJDIR)/%.o : %.F
	$(FC) $(FFLAGS)  $< -o $@

$(OBJDIR)/$(NAME): $(OBJFILES) 
	$(FC) -o $@  $(OBJFILES) $(LIBS) $(LDFLAGS)

