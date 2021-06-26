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

set -e

grog="${abs_top_builddir:-.}/grog"
src="${abs_top_srcdir:-..}"

doc=src/preproc/eqn/neqn.1
echo "testing simple man(7) page $doc" >&2
"$grog" "$doc" | \
    grep -Fq 'groff -T ps -man src/preproc/eqn/neqn.1'

doc=src/preproc/tbl/tbl.1
echo "testing tbl(1)-using man(7) page $doc" >&2
"$grog" "$doc" | \
    grep -Fq 'groff -T ps -t -man src/preproc/tbl/tbl.1'

doc=man/groff_diff.7
echo "testing eqn(1)-using man(7) page $doc" >&2
"$grog" "$doc" | \
    grep -Fq 'groff -T ps -e -man man/groff_diff.7'

doc=src/preproc/soelim/soelim.1
echo "testing pic(1)-using man(7) page $doc" >&2
# BUG: grog spuriously detects a need for soelim(1).
"$grog" "$doc" | \
    grep -Fq 'groff -T ps -s -p -man src/preproc/soelim/soelim.1'

doc=tmac/groff_mdoc.7
echo "testing tbl(1)-using mdoc(7) page $doc" >&2
"$grog" "$doc" | \
    grep -Fq 'groff -T ps -t -mdoc tmac/groff_mdoc.7'

doc=$src/doc/meintro.me
echo "testing me(7) document $doc" >&2
"$grog" "$doc" | \
    grep -Fq 'groff -T ps -me '"$src"'/doc/meintro.me'

doc=$src/doc/meintro_fr.me
echo "testing tbl(1)-using me(7) document $doc" >&2
"$grog" "$doc" | \
    grep -Fq 'groff -T ps -t -me '"$src"'/doc/meintro_fr.me'

# BUG: Just plain wrong.
#   "ms requests found, but file name extension was: me"
#doc=$src/doc/meref.me
#echo "testing me(7) document $doc" >&2
#"$grog" "$doc" | \
#    grep -Fq 'groff -T ps -me '"$src"'/doc/meref.me'

doc=$src/doc/grnexmpl.me
echo "testing grn(1)- and eqn(1)-using me(7) document $doc" >&2
"$grog" "$doc" | \
    grep -Fq 'groff -T ps -e -g -me '"$src"'/doc/grnexmpl.me'

doc=$src/contrib/mm/examples/letter.mm
echo "testing mm(7) document $doc" >&2
"$grog" "$doc" | \
    grep -Fq 'groff -T ps -mm '"$src"'/contrib/mm/examples/letter.mm'

# BUG: Detection of mom documents is all messed up.
# groff -T ps ../contrib/mom/examples/copyright-chapter.mom
# groff -T ps ../contrib/mom/examples/copyright-default.mom
# groff -T ps ../contrib/mom/examples/letter.mom
# groff -T ps ../contrib/mom/examples/mom-pdf.mom
# groff -T ps ../contrib/mom/examples/mon_premier_doc.mom
# groff -T ps ../contrib/mom/examples/sample_docs.mom
# man requests found, but file name extension was: mom
# groff -T ps -t -e -p -man ../contrib/mom/examples/slide-demo.mom
# man requests found, but file name extension was: mom
# groff -T ps -man ../contrib/mom/examples/typesetting.mom

doc=$src/contrib/pdfmark/cover.ms
echo "testing ms(7) document $doc" >&2
"$grog" "$doc" | \
    grep -Fq 'groff -T ps -ms '"$src"'/contrib/pdfmark/cover.ms'

doc=$src/contrib/pdfmark/pdfmark.ms
echo "testing ms(7) document $doc" >&2
"$grog" "$doc" | \
    grep -Fq 'groff -T ps -ms '"$src"'/contrib/pdfmark/pdfmark.ms'

doc=$src/doc/ms.ms
echo "testing tbl(1)-using ms(7) document $doc" >&2
"$grog" "$doc" | \
    grep -Fq 'groff -T ps -t -ms '"$src"'/doc/ms.ms'

doc=$src/doc/pic.ms
echo "testing tbl(1)-, eqn(1)-, and pic(1)-using ms(7) document $doc" \
    >&2
"$grog" "$doc" | \
    grep -Fq 'groff -T ps -t -e -p -ms '"$src"'/doc/pic.ms'

doc=$src/doc/webpage.ms
echo "testing ms(7) document $doc" \
    >&2
# BUG: Should detect -mwww (and -mpspic?) too.
"$grog" "$doc" | \
    grep -Fq 'groff -T ps -ms '"$src"'/doc/webpage.ms'

# vim:set ai et sw=4 ts=4 tw=72:
