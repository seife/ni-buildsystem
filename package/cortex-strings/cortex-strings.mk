################################################################################
#
# cortex-strings
#
################################################################################

CORTEX_STRINGS_VERSION = git
CORTEX_STRINGS_DIR = cortex-strings.$(CORTEX_STRINGS_VERSION)
CORTEX_STRINGS_SOURCE = cortex-strings.$(CORTEX_STRINGS_VERSION)
CORTEX_STRINGS_SITE = http://git.linaro.org/git-ro/toolchain

CORTEX_STRINGS_CHECKOUT = 499d1a6edf44466ae80c00dbf1ba96c9f5e60c0b

CORTEX_STRINGS_CONF_ENV = \
	CFLAGS="-pipe -O2 $(TARGET_DEBUGGING) $(CXX11_ABI) -I$(TARGET_includedir)" \
	CPPFLAGS="-pipe -O2 $(TARGET_DEBUGGING) $(CXX11_ABI) -I$(TARGET_includedir)" \
	CXXFLAGS="-pipe -O2 $(TARGET_DEBUGGING) $(CXX11_ABI) -I$(TARGET_includedir)" \
	LDFLAGS="-Wl,-O1 -L$(TARGET_libdir)"

CORTEX_STRINGS_CONF_OPTS = \
	$(TARGET_CONFIGURE_OPTS) \
	--enable-static \
	--disable-shared

define CORTEX_STRINGS_AUTOGEN_SH
	$(CHDIR)/$($(PKG)_DIR); \
		./autogen.sh
endef
CORTEX_STRINGS_PRE_CONFIGURE_HOOKS += CORTEX_STRINGS_AUTOGEN_SH

cortex-strings: | $(STATIC_DIR)
	$(call autotools-package)
