#!/bin/sh
#
# Copyright (C) 2022 Free Software Foundation, Inc.
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
gnu_eps="${abs_top_builddir:-.}/gnu.eps"
gnu_pdf="${abs_top_builddir:-.}/gnu.pdf"

# Regression-test Savannah #58206.

if ! command -v gs >/dev/null
then
    echo "cannot locate 'gs' command" >&2
    exit 77 # skip
fi

if [ -e "$gnu_pdf" ]
then
    echo "temporary output file '$gnu_pdf' already exists" >&2
    exit 77 # skip
fi

fail=

input='
.am pdfpic@error
.  ab
..
Here is a picture of a wildebeest.
.PDFPIC '"$gnu_pdf"'
'

if ! gs -o - -sDEVICE=pdfwrite -f "$gnu_eps" \
    -c "[ /Title (\000B\000U\000S\000T\000E\000D) /DOCINFO pdfmark" \
    > "$gnu_pdf"
then
    echo "gs command failed" >&2
    exit 77 # skip
fi

test -z $fail \
    && printf '%s\n' "$input" | "$groff" -Tpdf -U -z || fail=YES

rm -f "$gnu_pdf"
test -z $fail

# vim:set ai et sw=4 ts=4 tw=72: