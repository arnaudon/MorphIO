// generated by CommonFindPackage.cmake, do not edit.

/**
 * @file include/brion/defines.h
 * Includes compile-time defines of Brion.
 */

#ifndef BRION_DEFINES_H
#define BRION_DEFINES_H

#ifdef __APPLE__
#  include <brion/definesDarwin.h>
#elif defined (__linux__)
#  include <brion/definesLinux.h>
#elif defined (_WIN32)
#  include <brion/definesWin32.h>
#else
#  error Unknown OS
#endif

#endif
