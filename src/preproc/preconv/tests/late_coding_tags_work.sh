#!/bin/sh
#
# Copyright (C) 2020 Free Software Foundation, Inc.
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

# Ensure a predictable character encoding.
export LC_ALL=C

set -e

preconv="${abs_top_builddir:-.}/preconv"

# We do not find a coding tag on piped input because it isn't seekable.
echo "testing preconv on document read from pipe" >&2
"$preconv" -d 2>&1 > /dev/null <<EOF | grep "no coding tag"
abc
EOF

# Instead of using temporary files, which in all fastidiousness means
# cleaning them up even if we're interrupted, which in turn means
# setting up signal handlers, we use files in the build tree.

doc=contrib/mm/mmroff.1
echo "testing preconv on Latin-1 document $doc" >&2
"$preconv" -d 2>&1 > /dev/null $doc | grep "coding tag: 'latin-1'"

doc=src/preproc/preconv/preconv.1
echo "testing preconv on US-ASCII document $doc" >&2
"$preconv" -d 2>&1 > /dev/null $doc | grep "coding tag: 'us-ascii'"
