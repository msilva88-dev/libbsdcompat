# SPDX-License-Identifier: CC0-1.0

# This file is dedicated to the public domain under CC0 1.0.
#
# To the extent possible under law, the author(s) have waived all
# copyright and related or neighboring rights to this file.
#
# You may use, copy, modify, and distribute this file without restriction.
#
# See: https://creativecommons.org/publicdomain/zero/1.0/


## Settings

# Configurations
AR = $(AR_CMD)
ARFLAGS = rcs
BUILDDIR = build
CARCH = $(CARCH_CMD)
CBUILD = $(CBUILD_CMD)
CHOST = $(CBUILD)
CTHREADS = $(CTHREADS_CMD)
CPPFLAGS = $(CPPFLAGS_CMD)
CC = $(CC_CMD)
CFLAGS = $(CFLAGS_CMD)
CVER = gnu17
DEBUG = false
DESTDIR =
DIRGRP = root
DIROWN = root
DIRPERM = 0755
DIRPGRP = false
ENABLE_BSDDB = false
ENABLE_DEVNAME = false
ENABLE_DYNAMIC = false
ENABLE_GETCAP = false
ENABLE_GETGRENT = false
ENABLE_GETGRLIST = false
ENABLE_STATIC = false
ENABLE_TTYNAME = false
ENABLE_YP = false
FILEGRP = root
FILEOWN = root
FILEPERM = 0644
INCLUDEDIR = $(PREFIX)/include
INCDGRP = $(DIRGRP)
INCDOWN = $(DIROWN)
INCDPERM = $(DIRPERM)
INCFGRP = $(FILEGRP)
INCFOWN = $(FILEOWN)
INCFPERM = $(FILEPERM)
LD = $(LD_CMD)
LDHSTYLE = both
LDHSTYLE_LEG = gnu
LIBDIR = lib
LIBDGRP = $(DIRGRP)
LIBDOWN = $(DIROWN)
LIBDPERM = $(DIRPERM)
LIBFGRP = $(FILEGRP)
LIBFOWN = $(FILEOWN)
LIBFPERM = $(FILEPERM)
MANDIR = $(SHAREDIR)/man
MANDGRP = $(DIRGRP)
MANDOWN = $(DIROWN)
MANDPERM = $(DIRPERM)
MANFGRP = $(FILEGRP)
MANFOWN = $(FILEOWN)
MANFPERM = $(FILEPERM)
MARCH = $(MARCH_CMD)
PCDGRP = $(DIRGRP)
PCDOWN = $(DIROWN)
PCDPERM = $(DIRPERM)
PCFGRP = $(FILEGRP)
PCFOWN = $(FILEOWN)
PCFPERM = $(FILEPERM)
PFIXOWN = $(DIRGRP)
PFIXGRP = $(DIROWN)
PFIXPERM = $(DIRPERM)
PKG_CONFIG = $(PKG_CONFIG_CMD)
PKGCONFIGDIR = $(LIBDIR)/pkgconfig
PREFIX = usr
SHAREDIR = $(PREFIX)/share
SHRDOWN = $(DIRGRP)
SHRDGRP = $(DIROWN)
SHRDPERM = $(DIRPERM)
USE_LIBC_WITH_BSDLIB = $(USE_LIBC_WITH_BSDLIB_CMD)
VER = $(VER_MAJOR).$(VER_MINOR).$(VER_REV)
VER_MAJOR = 1
VER_MINOR = 0
VER_REV = 0

# Number of CPU threads for parallel compilation
CTHREADS_CMD != sh -c '\
getconf _NPROCESSORS_ONLN 2>/dev/null || printf "%d" 1 \
' 2>/dev/null

# Target architecture flags
CARCH_CMD != sh -c 'uname -m 2>/dev/null || printf "%s" "x86_64"' 2>/dev/null
COS_CMD != sh -c '\
uname -s 2>/dev/null || printf "%s" "Linux" \
' 2>/dev/null
CBUILD_CMD != sh -c '\
case "$(COS_CMD)" in \
    OpenBSD) \
        printf "%s-pc-%s" "$(CARCH)" "openbsd" \
        ;; \
    HyperbolaBSD) \
        printf "%s-pc-%s" "$(CARCH)" "hyperbolabsd" \
        ;; \
    *Linux|*) \
        _=$$(ldd --version 2>&1 | head -n 1 | cut -d"(" -f2 | cut -d")" -f1) \
        if [ "$${_}" = "GNU libc" ]; then \
            printf "%s-pc-%s" "$(CARCH)" "linux-gnu"; \
        else \
            printf "%s-pc-%s" "$(CARCH)" "linux-musl"; \
        fi \
        ;; \
esac \
' 2>/dev/null || true
MARCH_CMD != sh -c '\
uname -m 2>/dev/null | sed "s/_/-/" 2>/dev/null || printf "%s" "x86-64" \
' 2>/dev/null
MALIGNF_CMD != sh -c '\
case "$(CARCH)" in \
    i686) \
        printf "%d" 16 \
        ;; \
    x86_64|*) \
        printf "%d" 32 \
        ;; \
esac \
' 2>/dev/null
MALIGNL_CMD != sh -c '\
case "$(CARCH)" in \
    i686) \
        printf "%d" 8 \
        ;; \
    x86_64|*) \
        printf "%d" 16 \
        ;; \
esac \
' 2>/dev/null
MCF_PROTECT_CMD != sh -c '\
case "$(CARCH)" in \
    i686) \
        printf "%s" "branch" \
        ;; \
    x86_64|*) \
        printf "%s" "full" \
        ;; \
esac \
' 2>/dev/null

# Target libc flags
USE_LIBC_WITH_BSDLIB_CMD != sh -c '\
case "$(CHOST)" in \
    *-hyperbolabsd*|*-openbsd*) \
        printf "%s" "true" \
        ;; \
    *-linux-gnu*|*-linux-musl*|*) \
        printf "%s" "false" \
        ;; \
esac \
' 2>/dev/null
BUILD_PORTABLE_CMD != sh -c '\
case "$(USE_LIBC_WITH_BSDLIB)" in \
    true) \
        printf "%s" "false" \
        ;; \
    false|*) \
        printf "%s" "true" \
        ;; \
esac \
' 2>/dev/null

# Target library flags
BUILD_LIBBSDCOMPAT_CMD != sh -c '\
_DYNAMIC=""; \
_STATIC=""; \
_SP=""; \
[ "$(ENABLE_DYNAMIC)" = "true" ] && _DYNAMIC="$(BUILDDIR)/libbsdcompat.so"; \
[ "$(ENABLE_STATIC)" = "true" ] && _STATIC="$(BUILDDIR)/libbsdcompat.a"; \
if [ -z "$${_DYNAMIC}" ] && [ -z "$${_STATIC}" ]; then \
    _DYNAMIC="$(BUILDDIR)/libbsdcompat.so"; \
fi; \
[ -n "$${_DYNAMIC}" ] && _SP=" "; \
printf "%s%s%s" "$${_DYNAMIC}" "$${_SP}" "$${_STATIC}" \
' 2>/dev/null

# Default static archiver command flags
AR_PATH_CMD != sh -c '\
command -v binutils-ar 2>/dev/null || command -v llvm-ar 2>/dev/null \
  || command -v ar 2>/dev/null || printf "%s" "ar" \
' 2>/dev/null
AR_CMD != printf "%s" "$(AR_PATH_CMD)" | sed "s|.*/||" 2>/dev/null

# Default C compiler command flags
CC_PATH_CMD != sh -c '\
command -v clang 2>/dev/null || command -v gcc 2>/dev/null \
  || printf "%s" "cc" \
' 2>/dev/null
CC_CMD != printf "%s" "$(CC_PATH_CMD)" | sed "s|.*/||" 2>/dev/null

# Default linker command flags
LD_PATH_CMD != sh -c '\
command -v mold 2>/dev/null || command -v lld 2>/dev/null \
  || command -v ld.gold 2>/dev/null || command -v ld.bfd 2>/dev/null \
  || command -v ld 2>/dev/null  || printf "%s" "ld.bfd" \
' 2>/dev/null
LD_CMD != printf "%s" "$(LD_PATH_CMD)" | sed "s|.*/||" 2>/dev/null

# Default package configurator command flags
PKG_CONFIG_PATH_CMD != sh -c '\
command -v pkg-config 2>/dev/null || printf "%s" "pkg-config" \
' 2>/dev/null
PKG_CONFIG_CMD != printf "%s" "$(PKG_CONFIG_PATH_CMD)" \
  | sed "s|.*/||" 2>/dev/null


## Compiler

# Optional Feature Flags
OPTFLAG_BSDDB_CMD != sh -c '\
case "$(ENABLE_BSDDB)" in \
    true) \
        printf "%s%s" "-D" "BSDDB" \
        ;; \
    false|*) \
        printf "%s%s" "" "" \
        ;; \
esac \
' 2>/dev/null
OPTFLAG_LIBCBSD_CMD != sh -c '\
case "$(USE_LIBC_WITH_BSDLIB)" in \
    true) \
        printf "%s%s" "-D" "LIBC_WITH_BSD" \
        ;; \
    false|*) \
        printf "%s%s" "" "" \
        ;; \
esac \
' 2>/dev/null
OPTFLAG_YP_CMD != sh -c '\
case "$(ENABLE_YP)" in \
    true) \
        printf "%s%s" "-D" "YP" \
        ;; \
    false|*) \
        printf "%s%s" "" "" \
        ;; \
esac \
' 2>/dev/null
OPTFLAG_RPC_HDR_CMD != sh -c '\
case "$(ENABLE_YP)" in \
    true) \
        $(PKG_CONFIG) --cflags libtirpc \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null

# Set appropriate flags in clang v11, GCC v8 and Binutils as v2.34
# (any language)
# -march: builds exclusively for an architecture
DFT_GENFLAGS_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "%s%s=%s %s %s" "-m" "arch" "$(MARCH)" "-pipe" "-g"; \
        ;; \
    false|*) \
        printf "%s%s=%s %s" "-m" "arch" "$(MARCH)" "-pipe"; \
        ;; \
esac \
' 2>/dev/null

# Set appropriate flags in clang v11, GCC v8 and Binutils as v2.34
# -fno-plt: (GCC-only) does not support clang v11 and bellow
# -mtune: (GCC-only) optimizes for an architecture,
#   but builds for whole processor family
LD_GENFLAGS_LLVM_CMD != sh -c '\
case "$(LD)" in \
    lld) \
        printf "%s" "-flto=thin" \
        ;; \
    *) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LD_GENFLAGS_GCC_CMD != sh -c '\
case "$(LD)" in \
    ld.gold) \
        printf "%s" "" \
        ;; \
    ld.bfd|ld|*) \
        printf "%s=%s %s" "-flto" "$(CTHREADS)" "-flto-partition=max" \
        ;; \
esac \
' 2>/dev/null
DFT_GENFLAGS_LLVM := $(DFT_GENFLAGS_CMD) $(LD_GENFLAGS_LLVM_CMD)
DFT_GENFLAGS_GCC := $(DFT_GENFLAGS_CMD)
DFT_GENFLAGS_GCC += -mtune=generic
DFT_GENFLAGS_GCC += $(LD_GENFLAGS_GCC_CMD)
DFT_GENFLAGS_GCC += -fno-plt
DFT_GENFLAGS_GCC += -falign-functions=$(MALIGNF_CMD)
DFT_GENFLAGS_GCC += -falign-loops=$(MALIGNL_CMD)
DFT_GENFLAGS_GCC += -falign-jumps=$(MALIGNF_CMD)
DFT_GENFLAGS_GCC += -fno-semantic-interposition
DFT_GENFLAGS_GCC += -fstack-clash-protection

# Optimize Flags in clang v11 and GCC v8 (any language)
DFT_OPTMFLAGS_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "%s%d" "-O" 0 \
        ;; \
    false|*) \
        printf "%s%d" "-O" 2 \
        ;; \
esac \
' 2>/dev/null

# Compiler Flags in clang v11 and GCC v8 (any language)
DFT_COMPFLAGS := $(DFT_OPTMFLAGS_CMD)
DFT_COMPFLAGS += -fno-common
DFT_COMPFLAGS += -fstack-protector-strong
DFT_COMPFLAGS += -ffunction-sections
DFT_COMPFLAGS += -fdata-sections
DFT_COMPFLAGS += -fcf-protection=$(MCF_PROTECT_CMD)
#-feliminate-unused-debug-types
DFT_COMPFLAGS_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "%s -f%s -g%s -g%s -f%s" \
        "$(DFT_COMPFLAGS)" "no-lto" "dwarf-4" "split-dwarf" \
        "no-omit-frame-pointer" \
        ;; \
    false|*) \
        printf "%s" "$(DFT_COMPFLAGS)" \
        ;; \
esac \
' 2>/dev/null

# Compiler Flags for shared library
DFT_LIBFLAGS_CMD != sh -c '\
if [ "$(ENABLE_DYNAMIC)" = "true" ] \
  || [ "$(ENABLE_STATIC)" != "true" ]; \
then \
    printf "%s%s" "-f" "PIC"; \
else \
    printf "%s" ""; \
fi \
' 2>/dev/null

# Compiler Flags in clang v11 and GCC v8 (C family language)
DFT_CFMLFLAGS_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "%s" "" \
        ;; \
    false|*) \
        printf "%s%s" "-f" "pch-preprocess" \
        ;; \
esac \
' 2>/dev/null

# C compiler flags
VER_CFLAGS_CMD != sh -c '\
case "$(CVER)" in \
    *) \
        printf "%s" "-fexceptions"; \
        ;; \
esac \
' 2>/dev/null
DFT_CFLAGS := -fno-exceptions

# C Preprocessor Flags in clang v11, GCC v8 and Binutils as v2.34
# (C family language)
CPPFLAGS_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "-D%s=%d -D%s" "_FORTIFY_SOURCE" 2 "DEBUG"; \
        ;; \
    false|*) \
        printf "-D%s=%d -D%s" "_FORTIFY_SOURCE" 2 "NDEBUG"; \
        ;; \
esac \
' 2>/dev/null || true

# Warning Flags
DFT_WFLAGS := -Wall
DFT_WFLAGS += -Wextra
DFT_WFLAGS += -Wimplicit-fallthrough
DFT_WFLAGS += -Wpedantic

# Compiler Flags
CFLAGS_CMD != sh -c '\
case "$(CC)" in \
    clang*) \
        printf "%s %s %s -std=%s %s %s %s" \
          "$(DFT_GENFLAGS_LLVM)" "$(DFT_COMPFLAGS_CMD)" \
          "$(DFT_CFMLFLAGS_CMD)" "$(CVER)" "$(DFT_CFLAGS)" "$(DFT_WFLAGS)" \
        ;; \
    gcc*) \
        printf "%s %s %s -std=%s %s %s %s" \
          "$(DFT_GENFLAGS_GCC)" "$(DFT_COMPFLAGS_CMD)" \
          "$(DFT_CFMLFLAGS_CMD)" "$(CVER)" "$(DFT_CFLAGS)" "$(DFT_WFLAGS)" \
        ;; \
    *) \
        printf "%s %s %s -std=%s %s %s %s" \
          "$(DFT_GENFLAGS)" "$(DFT_COMPFLAGS_CMD)" \
          "$(DFT_CFMLFLAGS_CMD)" "$(CVER)" "$(DFT_CFLAGS)" "$(DFT_WFLAGS)" \
        ;; \
esac \
' 2>/dev/null

## Linker Flags

# Linker Selection (Fastest available) and set appropriate flags
# in mold v1, LLVM LLD v11 and Binutils ld.bfd/ld.gold v2.34
# Use --hash-style=sysv in HyperbolaBSD (LLD uses by default)
# and --hash-style=gnu in GNU/Linux-libre (LLD doesn't support this flag)
DFT_GENLDFLAGS_CMD != sh -c '\
case "$(LD)" in \
    mold) \
        printf "%s %s,%s=%s,%s,%s,%s=%s" \
          "-fuse-ld=mold" "-Wl" "--hash-style" "$(LDHSTYLE)" \
          "--icf=safe" "--print-icf-sections" "--jobs" "$(CTHREADS)" \
        ;; \
    lld) \
        printf "%s %s,%s=%s,%s,%s" \
          "-fuse-ld=lld" "-Wl" "--hash-style" "$(LDHSTYLE)" \
          "--icf=safe" "--print-icf-sections" \
        ;; \
    ld.gold) \
        printf "%s %s,%s=%s,%s,%s,%s" \
          "-fuse-ld=gold" "-Wl" "--hash-style" "$(LDHSTYLE_LEG)" \
          "--icf=safe" "--print-icf-sections" "--threads" \
        ;; \
    ld.bfd|ld) \
        printf "%s %s,%s=%s" \
          "-fuse-ld=bfd" "-Wl" "--hash-style" "$(LDHSTYLE)" \
        ;; \
    *) \
        printf "%s,%s=%s" \
          "-Wl" "--hash-style" "$(LDHSTYLE)" \
        ;; \
esac \
' 2>/dev/null

# Linker Flags in Binutils ld.bfd/ld.gold v2.34, LLD v11 and mold v1
DFT_LDFLAGS := $(DFT_GENLDFLAGS_CMD),$(DFT_OPTMFLAGS_CMD)
DFT_LDFLAGS := $(DFT_LDFLAGS),-z,defs
DFT_LDFLAGS := $(DFT_LDFLAGS),-z,noexecstack
DFT_LDFLAGS := $(DFT_LDFLAGS),-z,now
DFT_LDFLAGS := $(DFT_LDFLAGS),-z,relro
DFT_LDFLAGS := $(DFT_LDFLAGS),--gc-sections
DFT_LDFLAGS := $(DFT_LDFLAGS),--build-id
DFT_LDFLAGS_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "%s,%s %s %s" \
          "$(DFT_LDFLAGS)" "--no-as-needed" "-g" "-rdynamic" \
        ;; \
    false|*) \
        printf "%s,%s" "$(DFT_LDFLAGS)" "--as-needed" \
        ;; \
esac \
' 2>/dev/null

# Linker Flags for optional libraries
LNK_LDFLAG_BSDDB_CMD != sh -c '\
case "$(ENABLE_BSDDB)" in \
    true) \
        printf "%s%s" "-l" "bsddb" \
        ;; \
    false|*) \
        printf "%s%s" "" "" \
        ;; \
esac \
' 2>/dev/null
LNK_LDFLAG_GETGRENT_CMD != sh -c '\
if [ "$(ENABLE_GETGRENT)" = "true" ] && [ "$(ENABLE_YP)" = "true" ]; then \
    case "$(CHOST)" in \
        *-musl*|*-hyperbolabsd*) \
            printf "%s%s" "" "" \
            ;; \
        *-gnu*|*bsd*|*) \
            printf "%s%s" "-l" "pthread" \
            ;; \
    esac; \
else \
    printf "%s%s" "" ""; \
fi \
' 2>/dev/null
LNK_LDFLAG_YP_CMD != sh -c '\
case "$(ENABLE_YP)" in \
    true) \
        printf "%s%s %s%s" "-l" "tirpc" "-l" "nsl" \
        ;; \
    false|*) \
        printf "%s%s" "" "" \
        ;; \
esac \
' 2>/dev/null
LNK_LDFLAGS := $(LNK_LDFLAG_BSDDB_CMD) $(LNK_LDFLAG_GETGRENT_CMD)
LNK_LDFLAGS += $(LNK_LDFLAG_YP_CMD)

# Linker Flags for shared code
DFT_SHAREDLDFLAGS := -shared

# Linker Flags
LDFLAGS := $(DFT_LDFLAGS_CMD)

## Make macros

LIBBSDCOMPAT_GRP_HDR_CMD != sh -c '\
case "$(ENABLE_YP)" in \
    true) \
        if [ "$(ENABLE_GETGRENT)" = "true" ]; then \
            printf "%s" "$(BUILDDIR)/grp_bsdcompat.h"; \
        else \
            printf "%s" ""; \
        fi \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSDCOMPAT_STDLIB_HDR_CMD != sh -c '\
case "$(ENABLE_BSDDB)" in \
    true) \
        if [ "$(ENABLE_DEVNAME)" = "true" ] \
          && [ "$(ENABLE_GETCAP)" = "true" ]; \
        then \
            printf "%s" "$(BUILDDIR)/stdlib_bsdcompat.h"; \
        elif [ "$(ENABLE_DEVNAME)" = "true" ]; then \
            printf "%s" "$(BUILDDIR)/stdlib_bsdcompat_devname.h"; \
        elif [ "$(ENABLE_GETCAP)" = "true" ]; then \
            printf "%s" "$(BUILDDIR)/stdlib_bsdcompat_getcap.h"; \
        else \
            printf "%s" ""; \
        fi \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSDCOMPAT_UNISTD_HDR_CMD != sh -c '\
case "$(ENABLE_BSDDB)" in \
    true) \
        if [ "$(ENABLE_TTYNAME)" = "true" ]; then \
            printf "%s" "$(BUILDDIR)/unistd_bsdcompat.h"; \
        else \
            printf "%s" ""; \
        fi \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSDCOMPAT_HDRS := $(LIBBSDCOMPAT_GRP_HDR_CMD)
LIBBSDCOMPAT_HDRS += $(LIBBSDCOMPAT_STDLIB_HDR_CMD)
LIBBSDCOMPAT_HDRS += $(LIBBSDCOMPAT_UNISTD_HDR_CMD)

LIBBSDCOMPAT_LIBS := $(BUILD_LIBBSDCOMPAT_CMD)

LIBBSDCOMPAT_DEVNAME_MAN_CMD != sh -c '\
case "$(ENABLE_DEVNAME)" in \
    true) \
        case "$(ENABLE_BSDDB)" in \
            true) \
                printf "%s" "devname.3" \
                ;; \
            false|*) \
                printf "%s" "" \
                ;; \
        esac \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSDCOMPAT_GETCAP_MAN_CMD != sh -c '\
case "$(ENABLE_GETCAP)" in \
    true) \
        case "$(ENABLE_BSDDB)" in \
            true) \
                printf "%s" "cgetent.3" \
                ;; \
            false|*) \
                printf "%s" "" \
                ;; \
        esac \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSDCOMPAT_GETGRENT_MAN_CMD != sh -c '\
case "$(ENABLE_GETGRENT)" in \
    true) \
        case "$(ENABLE_YP)" in \
            true) \
                printf "%s" "getgrent.3" \
                ;; \
            false|*) \
                printf "%s" "" \
                ;; \
        esac \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSDCOMPAT_GETGRLIST_MAN_CMD != sh -c '\
case "$(ENABLE_GETGRLIST)" in \
    true) \
        if [ "$(ENABLE_GETGRENT)" = "true" ] && [ "$(ENABLE_YP)" = "true" ]; \
        then \
            printf "%s" "getgrouplist.3"; \
        else \
            printf "%s" ""; \
        fi \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSDCOMPAT_TTYNAME_MAN_CMD != sh -c '\
case "$(ENABLE_TTYNAME)" in \
    true) \
        case "$(ENABLE_BSDDB)" in \
            true) \
                printf "%s" "ttyname.3" \
                ;; \
            false|*) \
                printf "%s" "" \
                ;; \
        esac \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSDCOMPAT_MANS := $(LIBBSDCOMPAT_GETCAP_MAN_CMD)
LIBBSDCOMPAT_MANS += $(LIBBSDCOMPAT_DEVNAME_MAN_CMD)
LIBBSDCOMPAT_MANS += $(LIBBSDCOMPAT_GETGRLIST_MAN_CMD)
LIBBSDCOMPAT_MANS += $(LIBBSDCOMPAT_GETGRENT_MAN_CMD)
LIBBSDCOMPAT_MANS += $(LIBBSDCOMPAT_TTYNAME_MAN_CMD)

PORTABLE_STRTONUM_INT_OBJ_CMD != sh -c '\
case "$(ENABLE_GETGRLIST)" in \
    true) \
        if [ "$(ENABLE_GETGRENT)" = "true" ] && [ "$(ENABLE_YP)" = "true" ]; \
        then \
            printf "%s" "$(BUILDDIR)/portable/strtonum_int.o"; \
        else \
            printf "%s" ""; \
        fi \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
PORTABLE_OBJS := $(PORTABLE_STRTONUM_INT_OBJ_CMD)
LIBBSDCOMPAT_DEVNAME_OBJ_CMD != sh -c '\
case "$(ENABLE_DEVNAME)" in \
    true) \
        case "$(ENABLE_BSDDB)" in \
            true) \
                printf "%s" "$(BUILDDIR)/devname.o" \
                ;; \
            false|*) \
                printf "%s" "" \
                ;; \
        esac \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSDCOMPAT_GETCAP_OBJ_CMD != sh -c '\
case "$(ENABLE_GETCAP)" in \
    true) \
        case "$(ENABLE_BSDDB)" in \
            true) \
                printf "%s" "$(BUILDDIR)/getcap.o" \
                ;; \
            false|*) \
                printf "%s" "" \
                ;; \
        esac \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSDCOMPAT_GETGRENT_OBJ_CMD != sh -c '\
case "$(ENABLE_GETGRENT)" in \
    true) \
        case "$(ENABLE_YP)" in \
            true) \
                printf "%s" "$(BUILDDIR)/getgrent.o" \
                ;; \
            false|*) \
                printf "%s" "" \
                ;; \
        esac \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSDCOMPAT_GETGRLIST_OBJ_CMD != sh -c '\
case "$(ENABLE_GETGRLIST)" in \
    true) \
        if [ "$(ENABLE_GETGRENT)" = "true" ] && [ "$(ENABLE_YP)" = "true" ]; \
        then \
            printf "%s" "$(BUILDDIR)/getgrouplist.o"; \
        else \
            printf "%s" ""; \
        fi \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSDCOMPAT_TTYNAME_OBJ_CMD != sh -c '\
case "$(ENABLE_TTYNAME)" in \
    true) \
        case "$(ENABLE_BSDDB)" in \
            true) \
                printf "%s" "$(BUILDDIR)/ttyname.o" \
                ;; \
            false|*) \
                printf "%s" "" \
                ;; \
        esac \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSDCOMPAT_YPEXCLUDE_INT_OBJ_CMD != sh -c '\
case "$(ENABLE_GETGRENT)" in \
    true) \
        case "$(ENABLE_YP)" in \
            true) \
                printf "%s" "$(BUILDDIR)/ypexclude_int.o" \
                ;; \
            false|*) \
                printf "%s" "" \
                ;; \
        esac \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSDCOMPAT_OBJS := $(LIBBSDCOMPAT_DEVNAME_OBJ_CMD)
LIBBSDCOMPAT_OBJS += $(LIBBSDCOMPAT_GETCAP_OBJ_CMD)
LIBBSDCOMPAT_OBJS += $(LIBBSDCOMPAT_GETGRENT_OBJ_CMD)
LIBBSDCOMPAT_OBJS += $(LIBBSDCOMPAT_GETGRLIST_OBJ_CMD)
LIBBSDCOMPAT_OBJS += $(LIBBSDCOMPAT_TTYNAME_OBJ_CMD)
LIBBSDCOMPAT_OBJS += $(LIBBSDCOMPAT_YPEXCLUDE_INT_OBJ_CMD)

LIBBSDCOMPAT_PCS := $(BUILDDIR)/libbsdcompat.pc

## build

all: opt-err $(BUILDDIR) $(BUILDDIR)/portable \
  $(LIBBSDCOMPAT_LIBS) $(LIBBSDCOMPAT_PCS)

$(BUILDDIR):
	mkdir -p "$(BUILDDIR)"
$(BUILDDIR)/portable:
	mkdir -p "$(BUILDDIR)/portable"
$(BUILDDIR)/devname.o: devname.c
	"$(CC)" $(CFLAGS) $(OPTFLAG_BSDDB_CMD) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/getcap.o: getcap.c
	"$(CC)" $(CFLAGS) $(OPTFLAG_BSDDB_CMD) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/getgrent.o: getgrent.c
	"$(CC)" $(CFLAGS) $(OPTFLAG_YP_CMD) $(OPTFLAG_RPC_HDR_CMD) \
	  $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/getgrouplist.o: getgrouplist.c
	"$(CC)" $(CFLAGS) \
	  $(OPTFLAG_YP_CMD) $(OPTFLAG_RPC_HDR_CMD) $(OPTFLAG_LIBCBSD_CMD) \
	  $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/ttyname.o: ttyname.c
	"$(CC)" $(CFLAGS) $(OPTFLAG_BSDDB_CMD) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/ypexclude_int.o: ypexclude_int.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/portable/strtonum_int.o: portable/strtonum_int.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/libbsdcompat.a: $(LIBBSDCOMPAT_OBJS) $(PORTABLE_OBJS)
	if [ "$(BUILD_PORTABLE_CMD)" = "true" ]; then \
	    "$(AR)" $(ARFLAGS) "$(BUILDDIR)/libbsdcompat.a" $?; \
	else \
	    "$(AR)" $(ARFLAGS) "$(BUILDDIR)/libbsdcompat.a" \
	      $(LIBBSDCOMPAT_OBJS); \
	fi
$(BUILDDIR)/libbsdcompat.so: $(LIBBSDCOMPAT_OBJS) $(PORTABLE_OBJS)
	if [ "$(BUILD_PORTABLE_CMD)" = "true" ]; then \
	    "$(CC)" $(LDFLAGS) $(DFT_SHAREDLDFLAGS) \
	      -o "$(BUILDDIR)/libbsdcompat.so" $? $(LNK_LDFLAGS); \
	else \
	    "$(CC)" $(LDFLAGS) $(DFT_SHAREDLDFLAGS) \
	      -o "$(BUILDDIR)/libbsdcompat.so" \
	      $(LIBBSDCOMPAT_OBJS) $(LNK_LDFLAGS); \
	fi
$(BUILDDIR)/libbsdcompat.pc: libbsdcompat.pc.in
	if [ "$(ENABLE_DYNAMIC)" = "true" ] \
	  || [ "$(ENABLE_STATIC)" != "true" ]; \
	then \
	    _DYNAMIC=" -lbsdcompat"; \
	else \
	    _DYNAMIC=""; \
	fi; \
	sed \
	  -e "s|@DYNAMIC@|$${_DYNAMIC}|g" \
	  -e "s|@LIBDIR@|/$(LIBDIR)|g" \
	  -e "s|@INCLUDEDIR@|/$(INCLUDEDIR)|g" \
	  -e "s|@VER@|$(VER)|g" \
	  $? > $@

## Install

install: install-hdr install-lib install-man install-pkgconfig

## Install headers

install-hdr: opt-err $(LIBBSDCOMPAT_HDRS)
	([ -d "$(DESTDIR)/$(PREFIX)" ] || [ "$(DESTDIR)/$(PREFIX)" = "/" ]) \
	  || mkdir -pm "$(PFIXPERM)" "$(DESTDIR)/$(PREFIX)"
	( \
	    [ -d "$(DESTDIR)/$(INCLUDEDIR)" ] \
	    || [ "$(DESTDIR)/$(INCLUDEDIR)" = "/" ] \
	) \
	  || mkdir -pm "$(INCDPERM)" "$(DESTDIR)/$(INCLUDEDIR)"

	OGDIR="$(DESTDIR)/$(PREFIX)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(PFIXOWN)" ] \
	  || chown "$(PFIXOWN)" "$(DESTDIR)/$(PREFIX)"; \
	[ "$$2" = "$(PFIXGRP)" ] \
	  || chgrp "$(PFIXGRP)" "$(DESTDIR)/$(PREFIX)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(PREFIX)\" 2>/dev/null"; \
	    PERMS=$$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(PREFIX)"; \
	fi

	OGDIR="$(DESTDIR)/$(INCLUDEDIR)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(INCDOWN)" ] \
	  || chown "$(INCDOWN)" "$(DESTDIR)/$(INCLUDEDIR)"; \
	[ "$$2" = "$(INCDGRP)" ] \
	  || chgrp "$(INCDGRP)" "$(DESTDIR)/$(INCLUDEDIR)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(SHAREDIR)\" 2>/dev/null"; \
	    PERMS=$$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(SHAREDIR)"; \
	fi

	cp -p $(LIBBSDCOMPAT_HDRS) "$(DESTDIR)/$(INCLUDEDIR)"
	for FILE in $(LIBBSDCOMPAT_HDRS); do \
	    chmod "$(INCFPERM)" \
	      "$(DESTDIR)/$(INCLUDEDIR)/$${FILE}"; \
	    chown "$(INCFOWN):$(INCFGRP)" \
	      "$(DESTDIR)/$(INCLUDEDIR)/$${FILE}"; \
	done
	[ ! -f "$(DESTDIR)/$(INCLUDEDIR)/stdlib_bsdcompat_devname.h" ] \
	  || mv "$(DESTDIR)/$(INCLUDEDIR)/stdlib_bsdcompat_devname.h" \
	  "$(DESTDIR)/$(INCLUDEDIR)/stdlib_bsdcompat.h"
	[ ! -f "$(DESTDIR)/$(INCLUDEDIR)/stdlib_bsdcompat_getcap.h" ] \
	  || mv "$(DESTDIR)/$(INCLUDEDIR)/stdlib_bsdcompat_getcap.h" \
	  "$(DESTDIR)/$(INCLUDEDIR)/stdlib_bsdcompat.h"

## Install libraries

install-lib: opt-err $(LIBBSDCOMPAT_LIBS)
	([ -d "$(DESTDIR)/$(PREFIX)" ] || [ "$(DESTDIR)/$(PREFIX)" = "/" ]) \
	  || mkdir -pm "$(PFIXPERM)" "$(DESTDIR)/$(PREFIX)"
	([ -d "$(DESTDIR)/$(LIBDIR)" ] || [ "$(DESTDIR)/$(LIBDIR)" = "/" ]) \
	  || mkdir -pm "$(LIBDPERM)" "$(DESTDIR)/$(LIBDIR)"

	OGDIR="$(DESTDIR)/$(PREFIX)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(PFIXOWN)" ] \
	  || chown "$(PFIXOWN)" "$(DESTDIR)/$(PREFIX)"; \
	[ "$$2" = "$(PFIXGRP)" ] \
	  || chgrp "$(PFIXGRP)" "$(DESTDIR)/$(PREFIX)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(PREFIX)\" 2>/dev/null"; \
	    PERMS=$$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(PREFIX)"; \
	fi

	OGDIR="$(DESTDIR)/$(LIBDIR)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(LIBDOWN)" ] \
	  || chown "$(LIBDOWN)" "$(DESTDIR)/$(LIBDIR)"; \
	[ "$$2" = "$(LIBDGRP)" ] \
	  || chgrp "$(LIBDGRP)" "$(DESTDIR)/$(LIBDIR)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(LIBDIR)\" 2>/dev/null"; \
	    PERMS=$$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(LIBDIR)"; \
	fi

	cp -p $(LIBBSDCOMPAT_LIBS) "$(DESTDIR)/$(LIBDIR)"
	for FILE in $$(ls $(LIBBSDCOMPAT_LIBS) | xargs -n1 basename); do \
	    chmod "$(LIBFPERM)" \
	      "$(DESTDIR)/$(LIBDIR)/$${FILE}"; \
	    chown "$(LIBFOWN):$(LIBFGRP)" \
	      "$(DESTDIR)/$(LIBDIR)/$${FILE}"; \
	done
	if [ -f "$(DESTDIR)/$(LIBDIR)/libbsdcompat.so" ]; then \
	    ln -s libbsdcompat.so \
	      "$(DESTDIR)/$(LIBDIR)/libbsdcompat.so.$(VER_MAJOR)"; \
	    ln -s libbsdcompat.so \
	      "$(DESTDIR)/$(LIBDIR)/libbsdcompat.so.$(VER)"; \
	    chown "$(LIBFOWN):$(LIBFGRP)" \
	      "$(DESTDIR)/$(LIBDIR)/libbsdcompat.so.$(VER_MAJOR)"; \
	    chown "$(LIBFOWN):$(LIBFGRP)" \
	      "$(DESTDIR)/$(LIBDIR)/libbsdcompat.so.$(VER)"; \
	fi

## Install manuals

install-man: opt-err $(LIBBSDCOMPAT_MANS)
	([ -d "$(DESTDIR)/$(PREFIX)" ] || [ "$(DESTDIR)/$(PREFIX)" = "/" ]) \
	  || mkdir -pm "$(PFIXPERM)" "$(DESTDIR)/$(PREFIX)"
	( \
	    [ -d "$(DESTDIR)/$(SHAREDIR)" ] \
	    || [ "$(DESTDIR)/$(SHAREDIR)" = "/" ] \
	) \
	  || mkdir -pm "$(SHRDPERM)" "$(DESTDIR)/$(SHAREDIR)"
	([ -d "$(DESTDIR)/$(MANDIR)" ] || [ "$(DESTDIR)/$(MANDIR)" = "/" ]) \
	  || mkdir -pm "$(MANDPERM)" "$(DESTDIR)/$(MANDIR)"
	[ -d "$(DESTDIR)/$(MANDIR)/man3" ] \
	  || mkdir -pm "$(MANDPERM)" "$(DESTDIR)/$(MANDIR)/man3"

	OGDIR="$(DESTDIR)/$(PREFIX)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(PFIXOWN)" ] \
	  || chown "$(PFIXOWN)" "$(DESTDIR)/$(PREFIX)"; \
	[ "$$2" = "$(PFIXGRP)" ] \
	  || chgrp "$(PFIXGRP)" "$(DESTDIR)/$(PREFIX)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(PREFIX)\" 2>/dev/null"; \
	    PERMS=$$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(PREFIX)"; \
	fi

	OGDIR="$(DESTDIR)/$(SHAREDIR)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(SHRDOWN)" ] \
	  || chown "$(SHRDOWN)" "$(DESTDIR)/$(SHAREDIR)"; \
	[ "$$2" = "$(SHRDGRP)" ] \
	  || chgrp "$(SHRDGRP)" "$(DESTDIR)/$(SHAREDIR)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(SHAREDIR)\" 2>/dev/null"; \
	    PERMS=$$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(SHAREDIR)"; \
	fi

	OGDIR="$(DESTDIR)/$(MANDIR)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(MANDOWN)" ] \
	  || chown "$(MANDOWN)" "$(DESTDIR)/$(MANDIR)"; \
	[ "$$2" = "$(MANDGRP)" ] \
	  || chgrp "$(MANDGRP)" "$(DESTDIR)/$(MANDIR)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(MANDIR)\" 2>/dev/null"; \
	    PERMS=$$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(MANDIR)"; \
	fi

	OGDIR="$(DESTDIR)/$(MANDIR)/man3"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(MANDOWN)" ] \
	  || chown "$(MANDOWN)" "$(DESTDIR)/$(MANDIR)/man3"; \
	[ "$$2" = "$(MANDGRP)" ] \
	  || chgrp "$(MANDGRP)" "$(DESTDIR)/$(MANDIR)/man3"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(MANDIR)/man3\" 2>/dev/null"; \
	    PERMS=$$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(MANDIR)/man3"; \
	fi

	cp -p $(LIBBSDCOMPAT_MANS) "$(DESTDIR)/$(MANDIR)/man3"
	for FILE in $(LIBBSDCOMPAT_MANS); do \
	    chmod "$(MANFPERM)" \
	      "$(DESTDIR)/$(MANDIR)/man3/$${FILE}"; \
	    chown "$(MANFOWN):$(MANFGRP)" \
	      "$(DESTDIR)/$(MANDIR)/man3/$${FILE}"; \
	done

# Install pkg-config files

install-pkgconfig: opt-err $(LIBBSDCOMPAT_PCS)
	([ -d "$(DESTDIR)/$(PREFIX)" ] || [ "$(DESTDIR)/$(PREFIX)" = "/" ]) \
	  || mkdir -pm "$(PFIXPERM)" "$(DESTDIR)/$(PREFIX)"
	([ -d "$(DESTDIR)/$(PKGCONFIGDIR)" ] \
	  || [ "$(DESTDIR)/$(PKGCONFIGDIR)" = "/" ]) \
	  || mkdir -pm "$(PCDPERM)" "$(DESTDIR)/$(PKGCONFIGDIR)"

	OGDIR="$(DESTDIR)/$(PREFIX)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(PFIXOWN)" ] \
	  || chown "$(PFIXOWN)" "$(DESTDIR)/$(PREFIX)"; \
	[ "$$2" = "$(PFIXGRP)" ] \
	  || chgrp "$(PFIXGRP)" "$(DESTDIR)/$(PREFIX)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(PREFIX)\" 2>/dev/null"; \
	    PERMS=$$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(PREFIX)"; \
	fi

	OGDIR="$(DESTDIR)/$(PKGCONFIGDIR)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(PCDOWN)" ] \
	  || chown "$(PCDOWN)" "$(DESTDIR)/$(PKGCONFIGDIR)"; \
	[ "$$2" = "$(PCDGRP)" ] \
	  || chgrp "$(PCDGRP)" "$(DESTDIR)/$(PKGCONFIGDIR)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(PKGCONFIGDIR)\" 2>/dev/null"; \
	    PERMS=$$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(PKGCONFIGDIR)"; \
	fi

	cp -p $(LIBBSDCOMPAT_PCS) "$(DESTDIR)/$(PKGCONFIGDIR)"
	for FILE in $$(ls $(LIBBSDCOMPAT_PCS) | xargs -n1 basename); do \
	    chmod "$(PCFPERM)" \
	      "$(DESTDIR)/$(PKGCONFIGDIR)/$${FILE}"; \
	    chown "$(PCFOWN):$(PCFGRP)" \
	      "$(DESTDIR)/$(PKGCONFIGDIR)/$${FILE}"; \
	done

## Clean

clean:
	rm -frv "$(BUILDDIR)"

## Error mensajes

opt-err:
	@if ([ "$(ENABLE_BSDDB)" != "true" ] && [ "$(ENABLE_YP)" != "true" ]) \
	  || ( \
	      [ "$(ENABLE_DEVNAME)" != "true" ] \
	      && [ "$(ENABLE_GETCAP)" != "true" ] \
	      && [ "$(ENABLE_GETGRENT)" != "true" ] \
	      && [ "$(ENABLE_GETCRLIST)" != "true" ] \
	      && [ "$(ENABLE_TTYNAME)" != "true" ] \
	  ); \
	then \
	    printf "%s%s\n%s\n%s\n%s\n" \
	    "Please enable BSDDB" \
	    " with some of DEVNAME, GETCAP and/or TTYNAME" \
	    "(make ENABLE_BSDDB=true ENABLE_DEVNAME=true);" \
	    "and/or YP with some of GETGRENT and/or GETGRLIST" \
	    "(make ENABLE_YP=true ENABLE_GETGRENT=true)"; \
	    exit 1; \
	fi

.PHONY: all clean \
  install install-hdr install-lib install-man install-pkgconfig opt-err \
  $(LIBBSDCOMPAT_HDRS) $(LIBBSDCOMPAT_LIBS) $(LIBBSDCOMPAT_MANS) \
  $(LIBBSDCOMPAT_PCS)
