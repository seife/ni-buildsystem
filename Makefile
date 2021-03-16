#
# Master makefile
#
# -----------------------------------------------------------------------------

UID := $(shell id -u)
ifeq ($(UID),0)
warn:
	@echo "You are running as root. Do not do this, it is dangerous."
	@echo "Aborting the build. Log in as a regular user and retry."
else

# Delete default rules. We don't use them. This saves a bit of time.
.SUFFIXES:

# we want bash as shell
SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
	 else if [ -x /bin/bash ]; then echo /bin/bash; \
	 else echo sh; fi; fi)

# Include some helper macros and variables
include support/misc/utils.mk

# bash prints the name of the directory on 'cd <dir>' if CDPATH is
# set, so unset it here to not cause problems. Notice that the export
# line doesn't affect the environment of $(shell ..) calls.
export CDPATH :=

# Disable top-level parallel build if per-package directories is not
# used. Indeed, per-package directories is necessary to guarantee
# determinism and reproducibility with top-level parallel build.
.NOTPARALLEL:

# kconfig uses CONFIG_SHELL
CONFIG_SHELL := $(SHELL)

export SHELL CONFIG_SHELL

# -----------------------------------------------------------------------------

# first target is default ...
default: all

local-files: config.local Makefile.local local

# workaround unset variables at first start
config.local: $(eval BOXMODEL=hd51)
	@clear
	@echo ""
	@echo "    ###   ###  ###"
	@echo "     ###   ##  ##"
	@echo "     ####  ##  ##"
	@echo "     ## ## ##  ##"
	@echo "     ##  ####  ##"
	@echo "     ##   ###  ##"
	@echo "     ##    ##  ##      http://www.neutrino-images.de"
	@echo "            #"
	@echo ""
	$(call draw_line);
	@echo ""
	@echo "   1)  Coolstream Nevis (HD1, BSE, Neo, Neo², Zee)"
	@echo "   2)  Coolstream Apollo (Tank)"
	@echo "   3)  Coolstream Shiner (Trinity)"
	@echo "   4)  Coolstream Kronos (Zee², Trinity V2)"
	@echo "   5)  Coolstream Kronos V2 (Link, Trinity Duo)"
	@echo "  11)  AX/Mutant HD51"
	@echo "  12)  AX/Mutant HD60"
	@echo "  13)  AX/Mutant HD61"
	@echo "  21)  WWIO BRE2ZE4K"
	@echo "  31)  Air Digital Zgemma H7S/C"
	@echo "  41)  VU+ Solo 4k"
	@echo "  42)  VU+ Duo 4k"
	@echo "  43)  VU+ Duo 4k SE"
	@echo "  44)  VU+ Ultimo 4k"
	@echo "  45)  VU+ Zero 4k"
	@echo "  46)  VU+ Uno 4k"
	@echo "  47)  VU+ Uno 4k SE"
	@echo "  51)  VU+ Duo"
	@echo ""
	@read -p "Select your boxmodel? [default: 11] " boxmodel; \
	boxmodel=$${boxmodel:-11}; \
	case "$$boxmodel" in \
		 1)	boxmodel=nevis;; \
		 2)	boxmodel=apollo;; \
		 3)	boxmodel=shiner;; \
		 4)	boxmodel=kronos;; \
		 5)	boxmodel=kronos_v2;; \
		11)	boxmodel=hd51;; \
		12)	boxmodel=hd60;; \
		13)	boxmodel=hd61;; \
		21)	boxmodel=bre2ze4k;; \
		31)	boxmodel=h7;; \
		41)	boxmodel=vusolo4k;; \
		42)	boxmodel=vuduo4k;; \
		43)	boxmodel=vuduo4kse;; \
		44)	boxmodel=vuultimo4k;; \
		45)	boxmodel=vuzero4k;; \
		46)	boxmodel=vuuno4k;; \
		47)	boxmodel=vuuno4kse;; \
		51)	boxmodel=vuduo;; \
		*)	boxmodel=hd51;; \
	esac; \
	cp support/config.example $@; \
	sed -i -e "s|^#BOXMODEL = $$boxmodel|BOXMODEL = $$boxmodel|" $@

Makefile.local:
	@cp support/Makefile.example $@

local:
	@mkdir -p $(@)/{root,scripts}

printenv:
	$(call draw_line);
	@echo "Build Environment Varibles:"
	@echo "CROSS_DIR:   $(CROSS_DIR)"
	@echo "TARGET:      $(TARGET)"
	@echo "BASE_DIR:    $(BASE_DIR)"
	@echo "SOURCE_DIR:  $(SOURCE_DIR)"
	@echo "BUILD:       $(BUILD)"
	@echo "PATH:        `type -p fmt>/dev/null&&echo $(PATH)|sed 's/:/ /g' |fmt -65|sed 's/ /:/g; 2,$$s/^/             /;'||echo $(PATH)`"
	@echo "BOXARCH:     $(BOXARCH)"
	@echo "BOXTYPE:     $(BOXTYPE)"
	@echo "BOXSERIES:   $(BOXSERIES)"
	@echo "BOXMODEL:    $(BOXMODEL)"
	$(call draw_line);
	@echo ""
	@echo "'make help' lists useful targets."
	@echo ""
	@make --no-print-directory toolcheck
	@make -i -s $(TARGET_DIR)
	@PATH=$(PATH):$(CROSS_DIR)/bin && \
	if type -p $(TARGET_CC) >/dev/null 2>&1; then \
		echo "$(TARGET_CC) found in PATH or in \$$CROSS_DIR/bin."; \
	else \
		echo "$(TARGET_CC) not found in PATH or \$$CROSS_DIR/bin"; \
		echo "=> please check your setup. Maybe you need to 'make crosstool'."; \
	fi
	@if ! LANG=C make -n preqs|grep -q "Nothing to be done"; then \
		echo; \
		echo "Your next target to do is probably 'make preqs'"; \
	fi
	@if ! test -e $(BASE_DIR)/config.local; then \
		echo; \
		echo "If you want to change the configuration, then run 'make local-files'"; \
		echo "and edit config.local to fit your needs. See the comments in there."; \
		echo; \
	fi

help:
	$(call draw_line);
	@echo "A few helpful make targets:"
	@echo " * make preqs      - Downloads necessary stuff"
	@echo " * make crosstool  - Build cross toolchain"
	@echo " * make bootstrap  - Prepares for building"
	@echo " * make neutrino   - Builds Neutrino"
	@echo " * make image      - Builds our beautiful NI-Image"
	@echo ""
	@echo "Later, you might find those useful:"
	@echo " * make update     - Update buildsystem and all sources"
	@echo ""
	@echo "Cleanup:"
	@echo " * make clean      - Clean up from previous build an prepare for a new one"
	@echo ""
	@echo "Total renew:"
	@echo " * make all-clean  - Reset buildsystem to delivery state"
	@echo "                     but doesn't touch your local stuff"
	$(call draw_line);

all:
	@echo "'make all' is not a valid target."

# target for testing only. not useful otherwise
everything: $(shell sed -n 's/^\$$.D.\/\(.*\):.*/\1/p' make/*.mk)

# -----------------------------------------------------------------------------

-include config.local
include make/environment-box.mk
include make/environment-linux.mk
include make/environment-build.mk
include make/environment-image.mk
include make/environment-update.mk

-include internal/internal.mk

include make/buildsystem-bootstrap.mk
include make/buildsystem-clean.mk
include make/buildsystem-helpers.mk
include make/buildsystem-prerequisites.mk
include make/buildsystem-update.mk
include make/flash-updates.mk
include make/flash-images.mk
include make/linux-kernel.mk
include make/linux-drivers.mk
include make/target-neutrino.mk
include make/target-neutrino-plugins.mk
include make/target-blobs.mk
include make/target-development.mk
include make/target-ffmpeg$(if $(filter $(BOXTYPE),coolstream),-coolstream).mk
include make/target-files.mk
include make/target-libs.mk
include make/target-libs-static.mk
include make/target-libs-unused.mk
include make/target-lua.mk
include make/target-rootfs.mk
include make/target-scripts.mk
include make/target-tools.mk
include make/target-tools-unused.mk
include make/host-tools.mk

include $(sort $(wildcard package/*/*.mk))

include make/ni.mk

# for your local extensions, e.g. special plugins or similar ...
-include ./Makefile.local

# -----------------------------------------------------------------------------

.print-phony:
	@echo $(PHONY)

PHONY += local-files
PHONY += printenv help all everything
PHONY += .print-phony
.PHONY: $(PHONY)

endif
