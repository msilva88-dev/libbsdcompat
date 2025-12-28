# Changelog

This project follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-28
Initial stable release.

### Overview
This release introduces the initial import of libbsdcompat,
a BSD libc compatibility library, including build system, licensing,
public headers, core implementations, and manual pages.

### Added

#### Project scaffolding
- Added `.gitignore`
  (ignores build artifacts like `build/`, `*.o`, `*.a`, `*.so*`).
- Added `Readme.md` describing the library purpose and licensing approach.
- Added `LICENSE` covering BSD-style terms
  plus notes about CC0/public domain files and HyperbolaBSD modifications.

#### Build system
- Added a large `Makefile` implementing:
  - Configurable feature toggles
    (e.g., `ENABLE_BSDDB`, `ENABLE_YP`, `ENABLE_GETGRENT`, `ENABLE_GETGRLIST`,
    `ENABLE_TTYNAME`, `ENABLE_DEVNAME`, `ENABLE_GETCAP`,
    dynamic/static builds).
  - Portable vs libc-provided behavior (e.g., `USE_LIBC_WITH_BSDLIB`).
  - Build outputs under `build/` (`libbsdcompat.so` and/or `libbsdcompat.a`).
  - Installation targets for headers, libraries, manpages, and pkg-config.

#### pkg-config metadata
- Added `libbsdcompat.pc.in` to generate a pkg-config file for consumers.

#### New headers (public + internal)
- Added portability/visibility/attribute helpers in `features.h`
  (weak symbols, visibility, fallthrough, etc.).
- Added public compatibility headers:
  - `grp_bsdcompat.h`
  - `stdlib_bsdcompat.h` (optionally generated/installed
    from feature-specific variants such as devname/getcap)”
  - `unistd_bsdcompat.h`
- Added internal headers supporting the implementations:
  - `grp_int.h`
  - `limits_int.h`
  - `stdlib_int.h`
  - `ypexclude_int.h`

#### New libc compatibility implementations
- Device name with optional DB cache:
  - Added `devname.c` implementing `devname()`.
- Capability database (termcap-like) support:
  - Added `getcap.c` implementing the cget* family:
    - `cgetent`, `cgetcap`, `cgetnum`, `cgetstr`, `cgetustr`, `cgetmatch`
    - sequential access helpers: `cgetfirst`, `cgetnext`, `cgetclose`
    - optional `.db` support via `BSDDB` (`cgetusedb`, `dbopen` path)
- Group database support:
  - Added `getgrent.c` implementing group lookup APIs:
    - `getgrent`, `getgrnam`, `getgrgid`
    - re-entrant variants `getgrnam_r`, `getgrgid_r`
    - `setgroupent`, `setgrent`, `endgrent`
    - Thread-safety via `pthread` and thread-specific storage
    - Optional YP/NIS integration when YP is enabled
- Supplementary group list:
  - Added `getgrouplist.c` implementing `getgrouplist()`
    with optional YP/netid support logic.
- Terminal name:
  - Added `ttyname.c` implementing `ttyname()` and `ttyname_r()`
    (with optional devdb lookup when `BSDDB` is enabled,
    falling back to scanning `/dev`).
- YP exclude helper:
  - Added `ypexclude_int.c` providing internal exclusion list management
    used by YP-enabled group handling.
- Portable strtonum:
  - Added `portable/strtonum_int.c` implementing OpenBSD-style `strtonum()`
    (used when libc doesn’t provide BSD equivalents
    / when portability mode is enabled).

#### Documentation (man pages)
- Added OpenBSD-derived manual pages (with HyperbolaBSD modification notices):
  - `cgetent.3`
  - `devname.3`
  - `getgrent.3`
  - `getgrouplist.3`
  - `ttyname.3`

### Notes
- Many files include “Modifications to support HyperbolaBSD:
  Copyright (c) 2025 Hyperbola Project”.
- The codebase is largely based on OpenBSD 7.0 libc sources,
  adapted for portability/compat usage.

---

[1.0.0]: https://git.hyperbola.info:50100/hyperbolabsd/libbsdcompat.git/tag/?h=v1.0.0
