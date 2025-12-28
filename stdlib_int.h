/* SPDX-License-Identifier: CC0-1.0 */

/*
 * Public Domain
 *
 * Modifications to support HyperbolaBSD:
 * Written in 2025 by Hyperbola Project
 *
 * To the extent possible under law, the author(s) have dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 *
 * You should have received a copy of the CC0 Public Domain Dedication along
 * with this software. If not, see
 * <https://creativecommons.org/publicdomain/zero/1.0/>.
 */

#ifndef _LIBBSDCOMPAT_STDLIB_INT_H
#define _LIBBSDCOMPAT_STDLIB_INT_H

#include <stdlib.h>
#include "features.h"

#ifndef LIBC_WITH_BSD
#ifdef _BSD_SOURCE
long long strtonum(const char *, long long, long long, const char **) HIDDEN_A;
#endif
#endif

#endif
