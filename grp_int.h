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

#ifndef _LIBBSDCOMPAT_GRP_INT_H
#define _LIBBSDCOMPAT_GRP_INT_H

#include "features.h"

#ifdef _BSD_SOURCE

struct group *_getgrent_yp(int *) HIDDEN_A;

#ifndef _GR_BUF_LEN
#define _GR_BUF_LEN (1024+200*sizeof(char*))
#endif

#ifndef _PATH_GROUP
#define _PATH_GROUP "/etc/group"
#endif

#endif /* _BSD_SOURCE */

#endif
