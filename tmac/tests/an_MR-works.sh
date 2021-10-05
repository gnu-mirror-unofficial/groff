#!/bin/sh
#
# Copyright (C) 2021 Free Software Foundation, Inc.
#
# This file is part of groff.
#
# groff is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or
# (at your option) any later version.
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

# Regression-test Savannah #61279.
#
# If a SH or SS (sub)section heading was about to be output at the
# bottom of a page but wasn't because of the vertical space .ne-eded,
# we want to ensure that font remapping for the headings doesn't affect
# page footers and headers.

FAIL=

INPUT='.TH \\fIfoo\\fP 1 2021-10-04 "groff test suite"
.SH Name
foo \\- a command with a very short name
.SH Description
The real work is done by
.MR bar 1 .'

OUTPUT=$(echo "$INPUT" | "$groff" -Tascii -man -Z)

# Expected:
#   87  tby
#   88  wf2
#   89  h24
#   90  tbar
#   91  f1
#   92  t(1).
#   93  n40 0

set -e
echo "$OUTPUT" | nl | grep -E '88[[:space:]]+wf2'
echo "$OUTPUT" | nl | grep -E '91[[:space:]]+f1'
echo "$OUTPUT" | nl | grep -E '92[[:space:]]+t\(1\).'

# vim:set ai et sw=4 ts=4 tw=72:
