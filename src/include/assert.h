// -*- C++ -*-
/* Copyright (C) 1989-2020 Free Software Foundation, Inc.
     Written by James Clark (jjc@jclark.com)

This file is part of groff.

groff is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or
(at your option) any later version.

groff is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>. */

#ifndef ASSERT_H
#define ASSERT_H

void assertion_failed(int, const char *, const char *, const char *);

inline void do_assert(int expr, int line, const char *file,
                      const char *func, const char *msg)
{
  if (!expr)
    assertion_failed(line, file, func, msg);
}
#endif /* ASSERT_H */

#undef assert

#ifdef NDEBUG
#define assert(ignore) /* as nothing */
#else
#define assert(expr) do_assert(expr, __LINE__, __FILE__, __func__, \
                               #expr)
#endif
