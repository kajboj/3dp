ifndef SILENT
  SILENT     = @
endif

CXX        = g++
AR         = ar
BULLETDIR  = ../../bullet3-2.82
SRCDIR     = ..
OBJDIR     = obj/x32/Release/App_SoftDemo
TARGETDIR  = ../target
TARGET     = $(TARGETDIR)/App_SoftDemo_gmake
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
	$(OBJDIR)/SoftDemo.o \

RESOURCES := \

.PHONY: clean prebuild prelink

all: $(TARGETDIR) $(OBJDIR) prebuild prelink $(TARGET)
	@:

$(TARGET): $(GCH) $(OBJECTS) $(LDDEPS) $(RESOURCES)
	@echo Linking App_SoftDemo
	$(SILENT) $(LINKCMD)
	$(POSTBUILDCMDS)

$(TARGETDIR):
	@echo Creating $(TARGETDIR)
	$(SILENT) mkdir -p $(TARGETDIR)

$(OBJDIR):
	@echo Creating $(OBJDIR)
	$(SILENT) mkdir -p $(OBJDIR)

clean:
	@echo Cleaning App_SoftDemo
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
$(OBJDIR)/SoftDemo.o: $(SRCDIR)/SoftDemo.cpp
	@echo $(notdir $<)
	$(SILENT) $(CXX) $(CXXFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"

-include $(OBJECTS:%.o=%.d)
