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

#ifndef _GRP_BSDCOMPAT_H_
#define _GRP_BSDCOMPAT_H_

#ifdef __cplusplus
extern "C" {
#endif

#include <grp.h>

#ifdef _BSD_SOURCE
int setgroupent(int);
#endif

#ifdef __cplusplus
}
#endif

#endif
