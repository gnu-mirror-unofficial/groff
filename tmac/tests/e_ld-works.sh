#!/bin/sh
#
# Copyright (C) 2021 Free Software Foundation, Inc.
#
# This file is part of groff.
#
# groff is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your
# option) any later version.
#
# groff is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#

groff="${abs_top_builddir:-.}/test-groff"

# Test the `ld` macro.

input='.nr yr 108
.nr mo 12
.nr dy 15
.nr dw 2
.ld
.++ C
.+c "Fleeing the Impoverished, Drunken Countryside for Dublin"
.pp
The day was \\*(dw, \\*(td.
.++ A
.+c "How to Write for The Toast"
.pp
Submit it on spec.'

fail=

wail () {
    echo "...FAILED" >&2
    fail=YES
}

output=$(echo "$input" | "$groff" -Tascii -P-cbou -me)

echo 'checking that `td` string updated correctly' >&2
echo "$output" | grep -q 'The day was Monday, December 15, 2008\.$' \
    || wail

echo 'checking for correct English "Chapter" string' >&2
echo "$output" | grep -Eqx ' +Chapter 1' || wail

echo 'checking for correct English "Appendix" string' >&2
echo "$output" | grep -Eqx ' +Appendix A' || wail

test -z "$fail"

# vim:set ai et sw=4 ts=4 tw=72:
