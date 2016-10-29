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

SHELLTYPE := msdos
ifeq (,$(ComSpec)$(COMSPEC))
  SHELLTYPE := posix
endif
ifeq (/bin,$(findstring /bin,$(SHELL)))
  SHELLTYPE := posix
endif

.PHONY: clean prebuild prelink

all: $(TARGETDIR) $(OBJDIR) prebuild prelink $(TARGET)
	@:

$(TARGET): $(GCH) $(OBJECTS) $(LDDEPS) $(RESOURCES)
	@echo Linking App_SoftDemo
	$(SILENT) $(LINKCMD)
	$(POSTBUILDCMDS)

$(TARGETDIR):
	@echo Creating $(TARGETDIR)
ifeq (posix,$(SHELLTYPE))
	$(SILENT) mkdir -p $(TARGETDIR)
else
	$(SILENT) mkdir $(subst /,\\,$(TARGETDIR))
endif

$(OBJDIR):
	@echo Creating $(OBJDIR)
ifeq (posix,$(SHELLTYPE))
	$(SILENT) mkdir -p $(OBJDIR)
else
	$(SILENT) mkdir $(subst /,\\,$(OBJDIR))
endif

clean:
	@echo Cleaning App_SoftDemo
ifeq (posix,$(SHELLTYPE))
	$(SILENT) rm -f  $(TARGET)
	$(SILENT) rm -rf $(OBJDIR)
else
	$(SILENT) if exist $(subst /,\\,$(TARGET)) del $(subst /,\\,$(TARGET))
	$(SILENT) if exist $(subst /,\\,$(OBJDIR)) rmdir /s /q $(subst /,\\,$(OBJDIR))
endif

prebuild:
	$(PREBUILDCMDS)

prelink:
	$(PRELINKCMDS)

ifneq (,$(PCH))
$(GCH): $(PCH)
	@echo $(notdir $<)
ifeq (posix,$(SHELLTYPE))
	-$(SILENT) cp $< $(OBJDIR)
else
	$(SILENT) xcopy /D /Y /Q "$(subst /,\,$<)" "$(subst /,\,$(OBJDIR))" 1>nul
endif
	$(SILENT) $(CXX) $(CXXFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"
endif

$(OBJDIR)/main.o: $(SRCDIR)/main.cpp
	@echo $(notdir $<)
	$(SILENT) $(CXX) $(CXXFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"
$(OBJDIR)/SoftDemo.o: $(SRCDIR)/SoftDemo.cpp
	@echo $(notdir $<)
	$(SILENT) $(CXX) $(CXXFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"

-include $(OBJECTS:%.o=%.d)
