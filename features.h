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

#ifndef _LIBBSDCOMPAT_FEATURES_INT_H
#define _LIBBSDCOMPAT_FEATURES_INT_H

#ifdef __GNUC__
#define DEF_WEAK(x) \
        extern __typeof(x) x __attribute__((__weak__)); \
        extern __typeof(x) __bsdcompat_##x __attribute__((__alias__(#x)))
        /*
         * No trailing ";" after this macro
         * to prevent Clang's [-Wextra-semi] warning.
         */
#define FALLTHROUGH_A __attribute__((__fallthrough__))
#define HIDDEN_A __attribute__((__visibility__("hidden")))
#define UNUSED_A __attribute__((__unused__))
#else
#define DEF_WEAK(x)
#define FALLTHROUGH_A
#define HIDDEN_A
#define UNUSED_A
#endif

#endif
