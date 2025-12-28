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

#ifndef _LIBBSDCOMPAT_YPEXCLUDE_INT_H
#define _LIBBSDCOMPAT_YPEXCLUDE_INT_H

#include "features.h"

struct _ypexclude {
	const char *name;
	struct _ypexclude *next;
};

int __ypexclude_add(struct _ypexclude **, const char *) HIDDEN_A;
int __ypexclude_is(struct _ypexclude **, const char *) HIDDEN_A;
void __ypexclude_free(struct _ypexclude **) HIDDEN_A;

#endif
