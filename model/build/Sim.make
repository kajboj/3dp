ifndef SILENT
  SILENT     = @
endif

NAME       = Sim
CXX        = g++
AR         = ar
BULLETDIR  = ../../bullet3-2.82
SRCDIR     = ..
OBJDIR     = obj/x32/Release/App_$(NAME)
TARGETDIR  = ../target
TARGET     = $(TARGETDIR)/App_$(NAME)_gmake
DEFINES   += 
INCLUDES  += -I$(BULLETDIR)/src -I$(BULLETDIR)/Demos/OpenGL
CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
CFLAGS    += $(CPPFLAGS) $(ARCH) -O2 -msse -ffast-math -m32
CXXFLAGS  += $(CFLAGS) -fno-rtti
LDFLAGS   += -L$(BULLETDIR)/lib -s -m32 -L/usr/lib32
RESFLAGS  += $(DEFINES) $(INCLUDES) 
LIBS      += $(BULLETDIR)/lib/libOpenGLSupport_gmake.a $(BULLETDIR)/lib/libBulletSoftBody_gmake.a $(BULLETDIR)/lib/libBulletDynamics_gmake.a $(BULLETDIR)/lib/libBulletCollision_gmake.a $(BULLETDIR)/lib/libLinearMath_gmake.a -lGL -lGLU -lglut
LDDEPS    += $(BULLETDIR)/lib/libOpenGLSupport_gmake.a $(BULLETDIR)/lib/libBulletSoftBody_gmake.a $(BULLETDIR)/lib/libBulletDynamics_gmake.a $(BULLETDIR)/lib/libBulletCollision_gmake.a $(BULLETDIR)/lib/libLinearMath_gmake.a
LINKCMD    = $(CXX) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)

OBJECTS := \
	$(OBJDIR)/main.o \
	$(OBJDIR)/$(NAME).o \

RESOURCES := \

.PHONY: clean prebuild prelink

all: $(TARGETDIR) $(OBJDIR) prebuild prelink $(TARGET)
	@:

$(TARGET): $(GCH) $(OBJECTS) $(LDDEPS) $(RESOURCES)
	@echo Linking App_$(NAME)
	$(SILENT) $(LINKCMD)
	$(POSTBUILDCMDS)

$(TARGETDIR):
	@echo Creating $(TARGETDIR)
	$(SILENT) mkdir -p $(TARGETDIR)

$(OBJDIR):
	@echo Creating $(OBJDIR)
	$(SILENT) mkdir -p $(OBJDIR)

clean:
	@echo Cleaning App_$(NAME)
	$(SILENT) rm -f  $(TARGET)
	$(SILENT) rm -rf $(OBJDIR)

ifneq (,$(PCH))
$(GCH): $(PCH)
	@echo $(notdir $<)
	-$(SILENT) cp $< $(OBJDIR)
endif

$(OBJDIR)/main.o: $(SRCDIR)/main.cpp
	@echo $(notdir $<)
	$(SILENT) $(CXX) $(CXXFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"
$(OBJDIR)/$(NAME).o: $(SRCDIR)/$(NAME).cpp
	@echo $(notdir $<)
	$(SILENT) $(CXX) $(CXXFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"

-include $(OBJECTS:%.o=%.d)
