.\" Handle font requests with families, for instance in tbl(1) tables.
.if n \{\
.  ftr CR R
.  ftr CB B
.  ftr CI I
.  ftr CBI BI
.\}
.fchar \[dg] *
.fchar \[ps] paragraph
.fchar \[sd] \[dq]
.\" Acronym (slightly smaller type)
.de Acr
\s-1\\$1\s0\\$2
..
.\".RP
.ie t .nr LL 6.5i
.el   .nr LL 91n
.nr LT \n[LL]
.nr PS 11
.nr VS 13
.ie t .nr PI 3.5n
.el   .nr PI 4n
.ND March 2021
.EH '%''March 2021'
.EF ''''
.OH 'Using \f[I]groff\f[] with the \f[I]ms\f[] macros''%'
.OF ''''
.TL
Using
.BI groff
with the
.BI ms
Macro Package
.AU
Larry Kollar
.AI
kollar@alltel.net
.AB no
The
.I ms
(\[lq]manuscript\[rq]) package is suitable for the preparation
of reports,
letters,
memoranda,
books,
and manuals.
.
These
.I groff
macros support cover page and table of contents generation,
section
headings,
multiple paragraph styles,
text styling
(including font changes),
lists,
footnotes,
pagination control,
and indexing.
.
.
.PP
.I ms
supports the
.I tbl ,
.I eqn ,
.I pic ,
and
.I refer
preprocessors for inclusion of tables,
mathematical equations,
diagrams,
and standardized bibliographic citations.
.AE
.
.
.\" ------------------------- End of cover page ------------------------
.NH 1
Introduction
.XS
Introduction
.XE
.
.
.LP
The
.I ms
macros are the oldest surviving macro package for
.I roff
systems.\**
.
.FS
Although manual pages are even older,
the
.I man
macro language originated in Seventh Edition Unix (1979).
.
.I ms
shipped with Sixth Edition (1975) and was documented by Mike Lesk in a
Bell Labs internal memorandum.
.FE
.
While the
.I man
package was designed for brief documents to be perused at a terminal,
the
.I ms
macros are also suitable for longer documents intended for printing and
possible publication.
.
.
.PP
The
.I ms
macro package included with
.I groff
is a complete re-implementation.
.
Some macros
specific to
.Acr AT&T
or Berkeley
.I ms
are not included,
while several features have been added;
see section \[lq]Differences from
.Acr AT&T
.I ms \[rq]
below.
.
.
.PP
In this document,
a right arrow (\[->]) is used to indicate a tab character in the input.
.
.
.NH 2
Basic information
.XS
	Basic information
.XE
.
.
.LP
.I ms
exposes many aspects of document layout to user control via
.I groff
registers and strings.
.
Most
.I registers
have a default unit of measurement.
.
Specifying a unit explicitly does not cause any problems,
and can avoid problems in complex situations.
.
The following table summarizes typical units.
.
.
.TS
box center;
cb cb
cfCR l .
Unit	Description
_
i	inches
c	centimeters
p	points (1/72\[sd])
v	\[lq]vees\[rq]; height of a line using the current font
n	\[lq]ens\[rq]; width of an \[lq]n\[rq] using the current font
m	\[lq]ems\[rq]; width of an \[lq]M\[rq] using the current font
P	picas (1/6\[sd])
.TE
.
.
.PP
Set registers with using the
.CW .nr
request
and strings with the
.CW .ds
request.
.
.
.TS
box center;
lfCR.
\&.nr PS 12 \[rs]" Use 12-point type.
\&.ds FAM P \[rs]" Use Palatino font family.
.TE
.
.
.\" ------------------------
.if t .bp
.NH 1
General structure of an
.I -ms
document
.XS
General structure of an
.I -ms
document
.XE
.LP
The
.I -ms
macro package expects a certain amount of structure,
but not as much as packages such as
.I -man
or
.I -mdoc .
.PP
The simplest documents can begin with a paragraph macro
(such as
.CW .LP
or
.CW .PP ),
and consist of text separated by paragraph macros
or even blank lines.
Longer documents have a structure as follows:
.IP "\fBDocument type\fP"
If you invoke the
.CW .RP
(report) macro on the first line of the document,
.I groff
prints the cover page information on its own page;
otherwise it prints the information on the
first page with your document text immediately following.
Other document formats found in
.Acr AT&T
.I troff
are specific to
.Acr AT&T
or Berkeley, and are not supported in
.I groff .
.IP "\fBFormat and layout\fP"
By setting number registers,
you can change your document's type (font and size),
margins, spacing, headers and footers, and footnotes.
.
See
.I "Document control settings"
below for more details.
.
.IP "\fBCover page\fP"
A cover page consists of a title, the author's name and institution,
an abstract, and the date.\**
.FS
Actually, only the title is required.
.FE
See
.I "Cover page macros"
below for more details.
.IP "\fBBody\fP"
Following the cover page is your document.
You can use the
.I -ms
macros to write reports, letters, books, and so forth.
The package is designed for structured documents,
consisting of paragraphs interspersed with headings
and augmented by lists, footnotes, tables, and other
common constructs.
See
.I "Body text"
below for more details.
.IP "\fBTable of contents\fP"
Longer documents include a table of contents,
which you can invoke by placing the
.CW .TC
macro at the end of your document.\**
.FS
The
.I -ms
macros have minimal indexing facilities, consisting of the
.CW .IX
macro, which prints an entry on standard error.
.FE
.
Printing the table of contents at the end is necessary since
GNU
.I troff
is a single-pass text formatter;
it thus cannot determine the page number of a division of the text until
it has been set and output.
.
Since
.I -ms
output was intended for hardcopy,
the standard procedure was to manually relocate the pages containing
the table of contents between the cover page and the
body text.
.\" ------------------------
.if t .bp
.NH 1
Document control settings
.XS
Document control settings
.XE
.
.
.LP
For consistent document rendering,
set registers related to margins at the beginning of your document,
or just after calling
.CW .RP .
.
You can set other registers later in your document,
but keeping them together at the beginning makes them easy to find and
edit as necessary.
.
.
.TS H
box expand;
cb | cb cb cb cb
l | afCR l l lfCR .
Type	Parameter	Definition	Effective	Default
_
.TH
Margins	\[rs]n[PO]	Page offset (left margin)	next page	1i
\^	\[rs]n[LL]	Line length	next \[ps]	6i
\^	\[rs]n[LT]	Header/footer (title) length	next \[ps]	6i
\^	\[rs]n[HM]	Top (header) margin	next page	1i
\^	\[rs]n[FM]	Bottom (footer) margin	next page	1i
_
Text	\[rs]n[PS]	Point size	next \[ps]	10p
\^	\[rs]n[VS]	Line spacing (leading)	next \[ps]	12p
\^	\[rs]n[HY]	Hyphenation mode	next \[ps]	6
\^	\[rs]*[FAM]	Font family	next \[ps]	T
_
Paragraphs	\[rs]n[PI]	Initial indent	next \[ps]	5n
\^	\[rs]n[PD]	Space between paragraphs	next \[ps]	0.3v
\^	\[rs]n[QI]	Quoted paragraph indent	next \[ps]	5n
\^	\[rs]n[PORPHANS]	# of initial lines kept	next \[ps]	1
_
Headings	\[rs]n[PSINCR]	Point size increment	next heading	1p
\^	\[rs]n[GROWPS]	Size increase level limit	next heading	0
\^	\[rs]n[HORPHANS]	# of following lines kept	next heading	1
\^	\[rs]*[SN\-STYLE]	Numbering style (alias)	next heading	\[rs]*[SN\-DOT]
_
Footnotes	\[rs]n[FI]	Indentation	next footnote	2n
\^	\[rs]n[FF]	Format	next footnote	0
\^	\[rs]n[FPS]	Point size	next footnote	\[rs]n[PS]\-2
\^	\[rs]n[FVS]	Vertical spacing	next footnote	\[rs]n[FPS]+2
\^	\[rs]n[FPD]	Paragraph spacing	next footnote	\[rs]n[PD]/2
\^	\[rs]*[FR]	Line length ratio	special	11/12
_
Other	\[rs]n[DD]	Display distance (spacing)	next \[ps]	0.5v
\^	\[rs]n[MINGW]	Minimum gutter width	next page	2n
.TE
.
.
.LP
Changes to the footnote length ratio
.CW \[rs]*[FR]
take effect with the next footnote written in single-column
arrangements,
but on the next page in multiple-column contexts.
.\" ------------------------
.bp
.NH 1
Cover page macros
.XS
Cover page macros
.XE
.LP
Use the following macros to create a cover page for your document
in the order shown.
.TS H
box;
lb lb
lf(CR) lx.
Macro	Description
_
.TH
\&.RP [\fBno\fP]	T{
Specifies the report format for your document.
.
The report format creates a separate cover page.
.
The default action
(no
.CW .RP
macro)
is to print a subset of the cover page on page 1 of your document.
.
.
.sp \n[PD]u
If you use the optional
.B no
argument,
.I groff
prints a title page but
does not repeat any of the title page information
(title, author, abstract, etc.)
on page 1 of the document.
T}
_
\&.DA [\fIxxx\fP]	T{
(optional) Print the current date,
or the arguments to the macro if any,
on the title page
(if specified)
and in the footers.
.
This is the default for
.I nroff .
T}
_
\&.ND xxx [\fIxxx\fP]	T{
(optional) Print the current date,
or the arguments to the macro if any,
on the title page
(if specified)
but not in the footers.
.
This is the default for
.I troff .
T}
_
\&.TL	T{
Specifies the document title.
.
.I groff
collects text following the
.CW .TL
macro into the title, until reaching the author name or abstract.
T}
_
\&.AU	T{
Specifies the author's name,
which appears on the line
(or lines)
immediately following.
.
You can specify multiple authors as follows.
.
.
.DS I
.CW
\&.AU
John Doe
\&.AI
University of West Bumblefuzz
\&.AU
Martha Buck
\&.AI
Monolithic Corporation
.R
\&.\|.\|.
.DE
T}
_
\&.AI	T{
Specifies the author's institution.
.
You can specify multiple institutions in the same way that you specify
multiple authors.
T}
_
\&.AB [no]	T{
Begins the abstract.
.
The default is to print the word
.Acr ABSTRACT ,
centered and in italics,
above the text of the abstract.
.
The option
.CW no
suppresses this heading.
T}
_
\&.AE	End the abstract.
.TE
.
.
.KS
.LP
The following is example markup for a title page.
.
.
.\" Wrap lines in the code example below at 64 columns.
.TS
box center;
l.
T{
.nf
.CW
\&.RP
\&.TL
The Inevitability of Code Bloat in Commercial and Free Software
\&.AU
J. Random Luser
\&.AI
University of West Bumblefuzz
\&.AB
This report examines the long-term growth of the code bases in
two large,
popular software packages;
the free Emacs and the commercial Microsoft Word.
While differences appear in the type or order of features added,
due to the different methodologies used,
the results are the same in the end.
\&.PP
The free software approach is shown to be superior in that while
free software can become as bloated as commercial offerings,
free software tends to have fewer serious bugs and the added
features are in line with user demand.
\&.AE
.R
\&.\|.\|.\|the rest of the paper follows\|.\|.\|.
.fi
T}
.TE
.KE
.
.
.\" ------------------------
.bp
.NH 1
Body text
.XS
Body text
.XE
.LP
This section describes macros 
used to mark up the body of your document.
Examples include paragraphs, sections, and
other groups.
.NH 2
Paragraphs
.XS
	Paragraphs
.XE
.LP
Use the
.CW .PP
macro to create indented paragraphs
(like the next paragraph),
and the
.CW .LP
macro to create paragraphs with no initial indent (like this one).
.PP
The
.CW .QP
macro indents its text at both left and right margins.
The effect is identical to the
.Acr HTML
.CW <BLOCKQUOTE>
element.
The next paragraph or heading
returns margins to normal.
.
.
.KS
.PP
The following markup uses all three paragraph macros.
.
.
.\" Wrap lines in the code example below at 64 columns.
.TS
box center;
l.
T{
.nf
.CW
\&.NH 2
Cases used in the study
\&.LP
The following software and versions were considered for this
report.
\&.PP
For commercial software,
we chose
\&.B "Microsoft Word for Windows" ,
starting with version 1.0 through the current version
(Word 2000).
\&.PP
For free software,
we chose
\&.B Emacs ,
from its first appearance as a standalone editor through the
current version (v20).
\&.QP
Franklin's Law applied to software:
software expands to outgrow both RAM and disk space over time.
.R
.fi
T}
.TE
.KE
.
.
.NH 2
Headings
.XS
	Headings
.XE
.
.
.LP
Use headings to create a hierarchical structure for your document.
.
The
.I ms
macros print headings in
.B bold
using the same font family and,
by default,
point size as the body text.
.
Numbered and unnumbered headings are available.
.
Text lines after heading macros are treated as part of the heading,
rendered on the same output line in the same style.
.
.
.TS
box;
cb cb
afCR lx .
Macro	Description
_
\&.NH \f[I]level\f[]	T{
Numbered heading.
.
The
.I level
argument instructs
.I ms
to number headings in the form
.CW
.I a .\c
.I b .\c
.I c.\|.\|.,
.R
to any depth desired,
with the numbering of each level increasing automatically and being
reset when a more significant level is increased.
.
\[lq]1\[rq]\~is the most significant or coarsest division of the
document.
.
Only nonzero values are output.
.
If you specify heading levels with a gap in an ascending sequence,
such as by invoking
.CW ".NH\~3" \[rq] \[lq]
after
.CW ".NH\~1" \[rq], \[lq]
.I "groff ms"
emits a warning on the standard error stream.
T}
\&.NH S \f[I]heading-level-index\f[]\f[R] .\|.\|.\f[]	T{
Alternatively,
a first argument
.CW S "" of\~
can be given,
followed by integral arguments to number the levels of the heading
explicitly.
.
Further automatic numbering,
if used,
resumes using the specified heading level indices as their predecessors.
.
This feature is a GNU extension.
T}
.TE
.
.
.PP
An example may be illustrative.
.
.
.TS
box center;
cb | cb
lfCR | lB.
Code	Output
_
T{
.nf
\&.NH 1
Animalia
\&.NH 2
Arthropoda
\&.NH 3
Crustacea
\&.NH 2
Chordata
\&.NH S 6 6 6
Daimonia
\&.NH 1
Plantae
.fi
T}	T{
.nf
1.  Animalia
.sp
1.1.  Arthropoda
.sp
1.1.1.  Crustacea
.sp
1.2.  Chordata
.sp
6.6.6.  Daimonia
.sp
7.  Plantae
.fi
T}
.TE
.
.
.PP
After invocation of
.CW .NH ,
the assigned number is made available in the strings
.CW SN\-DOT
(as it appears in a printed heading with default formatting,
followed by a terminating period)
and
.CW SN\-NO\-DOT
(with the terminating period omitted).
.
.
.PP
You can control the style used to print numbered headings by defining an
appropriate alias for the string
.CW SN\-STYLE .
.
By default,
.CW \[rs]*[SN\-STYLE]
is aliased to
.CW \[rs]*[SN\-DOT] .
.
If you prefer to omit the terminating period from numbers appearing in
numbered headings,
you may define the alias as follows.
.
.
.TS
box center;
lfCR.
\&.als SN\-STYLE SN\-NO\-DOT
.TE
.
.
.LP
Any such change in numbering style becomes effective from the next use
of
.CW .NH ,
following redefinition of the alias for
.CW \[rs]*[SN\-STYLE] .
.
.
.TS
box;
cb cb
afCR lx .
Macro	Description
_
\&.SH [\f[I]level\f[]]	T{
Unnumbered heading.
.
The optional
.I level
argument is a GNU extension indicating the heading level corresponding
to the
.I level
argument of
.CW .NH .
.
It matches the point size at which the heading is printed to that of a
numbered heading at the same level when the
.CW \[rs]n[GROWPS]
and
.CW \[rs]n[PSINCR]
heading size adjustment mechanism is in effect.
T}
.TE
.
.
.PP
The
.CW PSINCR
register defines an increment in point size to be applied to headings
at nesting levels more significant
(numerically less)
than the value specified in
.CW \[rs]n[GROWPS] .
.
The value of
.CW \[rs]n[PSINCR]
should be specified in points with the
.CW p
scaling factor and may include a fractional component;
for example,
.
.
.TS
box center;
lfCR.
\&.nr PSINCR 1.5p
.TE
.
.
.LP
sets a point size increment of 1.5 points.
.
.
.PP
The
.CW GROWPS
register defines the heading level at which the point size increment set
by
.CW \[rs]n[PSINCR]
becomes effective.
.
Headings more significant
(numerically less)
than that specified by
.CW \[rs]n[GROWPS]
are printed at the point size set by
.CW \[rs]n[PS] ;
for each level below the value of
.CW \[rs]n[GROWPS] ,
the point size is increased by
.CW \[rs]n[PSINCR] .
.
Setting
.CW \[rs]n[GROWPS]
to a value less than\~2 disables the incremental heading size feature.
.
.
.PP
In other words,
if the
.CW GROWPS
register is greater than the
.I level
argument to a
.CW .NH
or
.CW .SH
call,
the point size of a heading produced by these macros increases by
.CW \[rs]n[PSINCR]
units over
.CW \[rs]n[PS]
multiplied by the difference between
.I level
and
.CW \[rs]n[GROWPS] .
.
.
For example,
the sequence
.
.TS
box center;
lfCR.
\&.nr PS 10
\&.nr GROWPS 3
\&.nr PSINCR 1.5p
\&.NH 1
Carnivora
\&.NH 2
Felinae
\&.NH 3
Felis catus
\&.SH 2
Machairodontinae
.TE
.
.
.LP
will cause \[lq]1. Carnivora\[rq] to be printed in 13-point text,
followed by \[lq]1.1. Felinae\[rq] in 11.5-point text,
while \[lq]1.1.1. Felis catus\[rq] and all more deeply nested
heading levels will remain in the 10-point text specified by the
.CW PS
register.
.
\[lq]Machairodontinae\[rq] is printed at 11.5 points,
since it corresponds to heading level\~2.
.
.
.PP
The
.CW \[rs]n[HORPHANS]
register operates in conjunction with the
.CW NH
and
.CW SH
macros to inhibit the printing of orphaned headings at the bottom of a
page;
it specifies the minimum number of lines of the subsequent paragraph
that must be kept on the same page as the heading.
.
If insufficient space remains on the current page to accommodate the
heading and this number of lines of paragraph text,
a page break is forced before the heading is printed.
.
Any display macro or
.I tbl ,
.I pic ,
or
.I eqn
region between the heading and the subsequent paragraph suppresses this
grouping.
.
.
.KS
.NH 2
Highlighting
.XS
	Highlighting
.XE
.
.
.LP
The
.I ms
macros provide a variety of methods to highlight or emphasize text.
.KE
.
.
.TS H
box;
lb lb
lf(CR) lx.
Macro	Description
_
.TH
\&.B [txt [post [pre]]]	T{
Sets its first argument in
.B "bold type" .
.
If you specify a second argument,
.I groff
prints it in the previous font after the bold text,
with no intervening space
(this allows you to set punctuation after the highlighted text without
highlighting the punctuation).
.
Similarly,
it prints the third argument
(if any)
in the previous font
.B before
the first argument.
.
For example,
.
.
.sp \n[PD]u
.ti +3n
\&.B foo ) (
.
.
.sp \n[PD]u
prints
.B foo ). (
.
.
.sp \n[PD]u
If you give this macro no arguments,
.I groff
prints all text following in bold until the next highlighting,
paragraph,
or heading macro.
T}
_
\&.R [txt [post [pre]]]	T{
Sets its first argument in roman
(or regular)
type.
.
It operates similarly to the
.CW .B
macro otherwise.
T}
_
\&.I [txt [post [pre]]]	T{
Sets its first argument in
.I "italic type" .
.
It operates similarly to the
.CW .B
macro otherwise.
T}
_
\&.BI [txt [post [pre]]]	T{
Sets its first argument in
.BI "bold italic type" .
.
It operates similarly to the
.CW .B
macro otherwise.
T}
_
\&.CW [txt [post [pre]]]	T{
Sets its first argument in a
.CW constant-width
(monospaced) roman typeface.
.
It operates similarly to the
.CW .B
macro otherwise.
.
This is a Version\~10 Research Unix extension.
.\" Possibly V9, but definitely not Berkeley.
.
.
.sp \n[PD]u
In
.I "groff ms"
you might prefer to change the font family to Courier\[em]a monospaced
typeface\[em]by setting
.CW \[rs]*[FAM]
to
.CW C \[rq]. \[lq]
.
You can then use all four style macros above,
returning to the default family (Times) with
.CW ".ds FAM T" \[rq]. \[lq]
T}
_
\&.BX [txt]	T{
Prints its argument and draws a
.BX box
around it.
.
If you want to box a string that contains spaces,
use a digit-width space (\\0).
T}
_
\&.UL [txt [post]]	T{
Prints its first argument with an
.UL underline .
.
If you specify a second argument,
.I groff
prints it in the previous font after the underlined text,
with no intervening space.
T}
_
\&.LG	T{
Prints all text following in
.LG
larger type
.NL
(2 points larger than the current point size)
until
the next font size,
highlighting,
paragraph,
or heading macro.
.
You can
.LG
specify this macro
.LG
multiple times
.NL
to enlarge the point size as needed.
T}
_
\&.SM	T{
Prints all text following in
.SM
smaller type
.NL
(2 points smaller than the current point size)
until
the next type size,
highlighting,
paragraph,
or heading macro.
.
You can
.SM
specify this macro
.SM
multiple times
.NL
to reduce the point size as needed.
T}
_
\&.NL	T{
Prints all text following in the normal point size
(that is,
the value of the
.CW PS
register).
T}
.TE
.
.
.NH 2
Lists
.XS
	Lists
.XE
.LP
The
.CW .IP
macro handles duties for all lists.
Its syntax is as follows:
.PP
.CW .IP
.I marker "" [
.I width ]] [
.LP
The
.I marker
is usually a bullet character
.CW \\\\(bu ) (
for unordered lists,
a number (or auto-incrementing number register) for numbered lists,
or a word or phrase for indented (glossary-style) lists.
.PP
The
.I width
specifies the indent for the body of each list item.
Once specified, the indent remains the same for all
list items in the document until specified again.
.
.
.PP
The following are examples of each type of list.
.
.TS H
box expand;
cb cb
afCR a .
Source	Result
_
.TH
T{
.nf
A bulleted list:
\&.IP \[rs][bu] 2
lawyers
\&.IP \[rs][bu]
guns
\&.IP \[rs][bu]
money
.fi
T}	T{
A bulleted list:
.IP \[bu] 2
lawyers
.IP \[bu]
guns
.IP \[bu]
money
T}
_
T{
.nf
\&.nr step 1 1
A numbered list:
\&.IP \\n[step] 3
lawyers
\&.IP \\n+[step]
guns
\&.IP \\n+[step]
money
.fi
T}	T{
.nr step 1 1
A numbered list:
.IP \n[step]. 3
lawyers
.IP \n+[step].
guns
.IP \n+[step].
money
T}
_
T{
.nf
A glossary-style list:
\&.IP lawyers 0.4i
Two or more attorneys.
\&.IP guns
Firearms,
preferably large-caliber.
\&.IP money
Gotta pay for those
lawyers and guns!
.fi
T}	T{
A glossary-style list:
.
.IP lawyers 0.4i
Two or more attorneys.
.IP guns
Firearms,
preferably large-caliber.
.IP money
Gotta pay for those lawyers and guns!
T}
.TE
.
.
.PP
The second example sets up an auto-incrementing register,
.CW step .
.
In the last example,
observe how the
.CW .IP
macro places the definition on the same line as the term if it has
enough space.
.
If this is not what you want,
there are a couple of workarounds.
.
.
.TS
box expand;
cb cb
afCR l .
Code	Result
_
T{
.nf
A glossary-style list:
\&.IP lawyers 0.4i
Two or more attorneys.
\&.IP guns
\&.br
Firearms,
preferably large-caliber.
\&.IP money
Gotta pay for those
lawyers and guns!
.fi
T}	T{
A glossary-style list:
.IP lawyers 0.4i
Two or more attorneys.
.IP guns
.br
Firearms,
preferably large-caliber.
.IP money
Gotta pay for those lawyers and guns!
T}
_
T{
.nf
A glossary-style list:
\&.IP lawyers 0.4i
Two or more attorneys.
\&.IP guns\[rs]h\[aq]0.4i\[aq]
Firearms, preferably
large-caliber.
\&.IP money
Gotta pay for those
lawyers and guns!
.fi
T}	T{
A glossary-style list:
.IP lawyers 0.4i
Two or more attorneys.
.IP guns\h'0.4i'
Firearms,
preferably large-caliber.
.IP money
Gotta pay for those lawyers and guns!
T}
.TE
.PP
The first example uses the
.CW .br
request to force a break after printing the term or label.
The second example uses the
.CW \\\\p
escape to do the same thing.
Note the space following the escape; this is important.
If you omit the space,
.I groff
prints the first word on the same line as the term or label (if it fits)
.B then
breaks the line.
.
.
.NH 2
Indented regions
.XS
	Indented regions
.XE
.
.
.LP
You may need to indent a region of text while still wrapping and
filling.
.
.
.TS
box;
cb cb
lfCR lx .
Macro	Description
_
\&.RS	T{
Begin a region indented by
.CW \[rs]n[PI] ,
affecting the placement of headings,
paragraphs,
and displays.
T}
\&.RE	T{
End the most recent indented region.
T}
.TE
.
.
.PP
You can use
.CW .RS /
.CW .RE
regions to line up text under hanging and indented paragraphs.
.
For example,
you may wish to nest lists.
.
.TS
box center;
l l .
T{
.nf
.CW
\&.IP \\[bu] 2
Lawyers:
\&.RS
\&.IP \\[bu]
Dewey,
\&.IP \\[bu]
Cheatham,
and
\&.IP \\[bu]
Howe.
\&.RE
\&.IP \\[bu]
Guns
.R
\&.\|.\|.
.fi
T}	T{
.IP \[bu] 2
Lawyers:
.RS
.IP \[bu]
Dewey,
.IP \[bu]
Cheatham,
and
.IP \[bu]
Howe.
.RE
.IP \[bu]
Guns
\&.\|.\|.
T}
.TE
.
.
.NH 2
Displays and keeps
.XS
	Displays and keeps
.XE
.LP
Use displays to show text-based examples or figures
(such as code listings).
This document shows
.I groff
code examples inside displays, for example.
.PP
Displays turn off filling, so lines of code can be
displayed as-is without inserting
.CW .br
requests in between each line.
Displays can be 
.I kept
on a single page, or allowed to break across pages.
The following table shows the display types available.
.
.
.TS
box;
cb s | cb
cb cb | ^
lfCR lfCR | lx .
Display macro	Description
With keep	No keep
_
\&.DS L	\&.LD	Left-aligns display.
\&.DS I [\fIindent\fP]	\&.ID	T{
Indents display
(by
.I indent
if given,
otherwise the value of
.CW \[rs]n[DI] ).
T}
\&.DS B	\&.BD	T{
Block-centers display
(left-aligns with the longest line centered).
T}
\&.DS C	\&.CD	Centers all lines in the display.
\&.DS R	\&.RD	Right-aligns all lines in the display.
.TE
.
.
.LP
Use the
.CW .DE
macro to end any display type.
.
.
.PP
The
.CW \[rs]n[DD]
distance used before and after each pair of display macros is also
applied to regions of the document preprocessed with
.I eqn (1),
.I pic (1),
and
.I tbl (1).
.
.
.PP
On occasion, you may want to
.I keep
other text together on a page.
For example, you may want to keep two paragraphs together, or
a paragraph that refers to a table (or list, or other item)
immediately following.
The
.I -ms
macros provide the
.CW .KS
and
.CW .KE
macros for this purpose.
The
.CW .KS
macro begins a block of text to be kept on a single page,
and the
.CW .KE
macro ends the block.
.PP
You can specify a
.I "floating keep" ;
if the keep cannot fit on the current page,
.I groff
holds the contents of the keep and allows text following
the keep (in the source file) to fill in the remainder of
the current page.
When the page breaks,
whether by an explicit
.CW .bp
request or by reaching the end of the page,
.I groff
prints the floating keep at the top of the new page.
This is useful for printing large graphics or tables
that do not need to appear exactly where specified.
Use the
.CW .KF
and
.CW .KE
macros to specify a floating keep.
.PP
You can also use the
.CW .ne
request to force a page break if there is
not enough vertical space remaining on the page.
.\" ----------------------------
.KS
.NH 2
Tables, figures, equations, and references
.XS
	Tables, figures, equations, and references
.XE
.LP
The
.I -ms
macros support the standard
.I groff
preprocessors:
.I tbl ,
.I pic ,
.I eqn ,
and
.I refer .
You mark text meant for preprocessors by enclosing it
in pairs of tags as follows:
.
.
.TS
box;
cb cb
lfCR lx .
Tag pair	Description
_
T{
\&.TS [H]
.br
\&.TE
T}	T{
Denotes a table to be processed by the
.I tbl
preprocessor.
.
The optional
.B H
argument to
.CW .TS
instructs
.I groff
to create a running header with the information
up to the
.CW .TH
macro.
.
.I groff
prints the header at the beginning of the table;
if the table runs onto another page,
.I groff
prints the header on the next page as well.
T}
_
T{
\&.PS
.br
\&.PE
T}	T{
Denotes a graphic to be processed by the
.I pic
preprocessor.
.
You can create a
.I pic
file by hand using the
.Acr AT&T
.I pic
manual available on the Web as a reference,
or by using a graphics program such as
.I xfig .
T}
_
T{
\&.EQ
.I align ] [
.br
\&.EN
T}	T{
Denotes an equation to be processed by the
.I eqn
preprocessor.
.
The optional
.I align
argument can be
.B C ,
.B L ,
or
.B I
to center
(the default),
left-justify,
or indent the equation.
T}
_
T{
\&.[
.br
\&.]
T}	T{
Denotes a reference to be processed by the
.I refer
preprocessor.
.
The
.Acr GNU
.I refer (1)
man page provides a comprehensive reference to the preprocessor and the
format of the bibliographic database.
T}
.TE
.KE
.
.
.KS
.NH 3
An example multi-page table
.XS
		An example multi-page table
.XE
.
.
.LP
The following is an example of how to set up a table that may print
across two or more pages.
.
.
.TS
box center;
l .
T{
.nf
.CW
\&.TS H
allbox expand;
cb | cb .
Part\[->]Description
_
\&.TH
\&.T&
l | l .
GH-1978\[->]Fribulating gonkulator
.R
\&.\|.\|.\|the rest of the table follows\|.\|.\|.
.CW
\&.TE
.R
.fi
T}
.TE
.KE
.
.
.PP
Attempting to place a multi-page table inside a keep can lead to
unpleasant results,
particularly if the
.I tbl
.CW allbox
option is used.
.
.
.NH 2
Footnotes
.XS
	Footnotes
.XE
.
.
.LP
The
.I ms
macros provide a flexible footnote system.
.
You can specify a numbered footnote\**
.FS
This is a numbered footnote.
.FE
by using the
.CW \\\\**
escape,
followed by the text of the footnote enclosed by
.CW .FS
and
.CW .FE
macros.
.
.
.PP
You can specify symbolic footnotes\[dg]
.FS
\[dg]This is a symbolic footnote.
.FE
by placing the mark character
(such as
.CW \\\\[dg]
for the
.if !'\[dg]'*' dagger
character used here),
followed by the symbol and the text of the footnote enclosed by
.CW .FS
and
.CW .FE
macros.
.
.
.KS
.PP
You can control how
.I ms
prints footnote numbers by changing the value of the
.CW FF
register as follows.
.
.
.TS
box;
cb cb
lfCR lx .
Value	Description
_
0	T{
Prints the footnote number as a superscript and indents the footnote
(default).
T}
1	T{
Prints the number followed by a period
(that is,\~\[lq]1.\[rq]\&)
and indents the footnote.
T}
2	T{
Like\~1,
without an indent.
T}
3	T{
Like\~1,
but prints the footnote number as a paragraph with a hanging indent.
T}
.TE
.KE
.
.
.LP
You can use footnotes safely within keeps and displays,
but avoid using numbered footnotes within floating keeps.
.
You can set a second
.CW \[rs]**
between a
.CW \[rs]**
and its corresponding
.CW .FS ,
as long as each
.CW .FS
occurs
.I after
the corresponding
.CW \[rs]**
and the occurrences of
.CW .FS
are in the same order as the corresponding occurrences of
.CW \[rs]** .
.
.
.PP
The default footnote line length is 11/12ths of the normal line length
for compatibility with the expectations of historical
.I ms
documents;
you may wish to set
.CW \[rs]*[FR]
to
.CW 1
to align with contemporary typesetting practices.
.
In the past,\**
.FS
in Version 7 Unix
.I ms ,
its descendants,
and GNU
.I ms
prior to
.I groff
version 1.23.0
.FE
an
.CW FL
register was used for the line length in footnotes;
however,
setting this register at document initialization time had no effect on
the footnote line length in multi-column arrangements.\**
.
.FS
You could reset it after each call to
.CW .1C ,
.CW .2C ,
or
.CW .MC .
.FE
.
.
.PP
.CW \[rs]*[FR]
should be used in preference to
.CW \[rs]n[FL]
in contemporary documents.
.
The footnote line length is effectively computed as
.CW "\[rs]n[\f[I]column-width\f[]] * \[rs]*[FR]" \[rq]. \[lq]
.
If an absolute footnote line length is required,
recall that arithmetic expressions in
.I roff
languages are evaluated from left to right.
.
.
.TS
box center;
lfCR.
\&.ds FR 0+3i \[rs]" Set footnote line length to 3 inches.
.TE
.
.
.PP
Changes to the footnote length ratio
.CW \[rs]*[FR]
take effect with the next footnote written in single-column
arrangements,
but on the next page in multiple-column contexts.
.
.
.\" ------------------------
.NH 1
Page layout
.XS
Page layout
.XE
.LP
The default output from the
.I -ms
macros provides a minimalist
page layout:
it prints a single column, with
the page number centered at the top of each page.
It prints no footers.
.PP
You can change the layout by setting
the proper number registers and strings.
.NH 2
Headers and footers
.XS
	Headers and footers
.XE
.LP
There are two ways to define headers and footers:
.IP \(bu 2
Set the strings
.CW LH ,
.CW CH ,
and
.CW RH ,
to set the left, center, and right headers; and
.CW LF ,
.CW CF ,
and
.CW RF
to set the left, center, and right footers.
This works best for documents that do not distinguish
between odd and even pages.
.IP \(bu
Use the
.CW .OH
and
.CW .EH
macros to define headers for the odd and even pages; and
.CW .OF
and
.CW .EF
macros to define footers for the odd and even pages.
This is more flexible than defining the individual strings.
The syntax for these macros is as follows:
.DS I
.CW
\&.OH \[aq]\f[I]left\f[]\[aq]\f[I]center\f[]\[aq]\f[I]right\f[]\[aq]
.R
.DE
.LP
You can replace the neutral apostrophes (\[aq]) with any character not
appearing in the header or footer text.
.\" ------------------------
.KS
.NH 2
Margins
.XS
	Margins
.XE
.
.
.LP
Control margins using registers.
.
These are summarized in the \[lq]Margins\[rq] section of the table in
section \[lq]Document control settings\[rq] above.
.
There is no right margin setting;
the combination of page offset and line length provide the information
necessary to derive the right margin.
.KE
.
.
.KS
.NH 2
Multiple columns
.XS
	Multiple columns
.XE
.LP
The
.I -ms
macros can set text in as many columns as will reasonably
fit on the page.
The following macros are available.
All of them force a page break if a multi-column mode is already set.
However, if the current mode is single-column, starting a multi-column
mode does
.B not
force a page break.
.
.
.TS
box;
cb cb
lfCR lx .
Macro	Description
_
\&.1C	Single-column mode.
_
\&.2C	Two-column mode.
_
\&.MC [\fIwidth\fP [\fIgutter\fP]]	T{
Multi-column mode.
.
If you specify no arguments,
it is equivalent to the
.CW .2C
macro.
.
Otherwise,
.I width
is the width of each column and
.I gutter
is the space between columns.
.
The
.CW MINGW
number register is the default gutter width.
T}
.TE
.KE
.
.
.NH 2
Creating a table of contents
.XS
	Creating a table of contents
.XE
.LP
The facilities in the
.I -ms
macro package for creating a table of contents
are semi-automated at best.
Assuming that you want the table of contents to
consist of the document's headings, you need to
repeat those headings wrapped in
.CW .XS
and
.CW .XE
macros.
.
.
.PP
In addition,
the
.CW XS
macro does not know to indent a heading based on its level.
.
The easiest way to work around this is to add tabs to the table of
contents string.
.
The following is an example.
.
.
.TS
box center;
l .
T{
.nf
.CW
\&.NH 1
Introduction
\&.XS
Introduction
\&.XE
.R
\&.\|.\|.
.CW
\&.NH 2
Methodology
\&.XS
\[->]Methodology
\&.XE
.R
\&.\|.\|.
.fi
T}
.TE
.
.
.LP
The
.I "Groff and Friends HOWTO"
includes a
.I sed
script that automatically inserts
.CW .XS
and
.CW .XE
entries after each heading in a document.
.PP
Altering the
.CW .NH
macro to automatically build the table of contents
is perhaps initially more difficult, but would save
a great deal of time in the long run if you use
.I -ms
regularly.
.\" ------------------------
.NH 1
Differences from AT&T
.I -ms
.XS
Differences from AT&T
.I -ms
.XE
.LP
This section lists the (minor) differences between the
.I "groff -ms"
macros and
.Acr AT&T
.I "troff -ms"
macros.
.NH 2
.I troff
macros not appearing in
.I groff
.XS
	\fItroff\fP
macros not appearing in
.I groff
.XE
.LP
Macros missing from
.I "groff -ms"
are cover page macros specific to
Bell Labs.
The macros known to be missing are:
.IP \&.TM 0.5i
Technical memorandum; a cover sheet style
.IP \&.IM
Internal memorandum; a cover sheet style
.IP \&.MR
Memo for record; a cover sheet style
.IP \&.MF
Memo for file; a cover sheet style
.IP \&.EG
Engineer's notes; a cover sheet style
.IP \&.TR
Computing Science Tech Report; a cover sheet style
.IP \&.OK
Other keywords
.IP \&.CS
Cover sheet information
.IP \&.MH
A cover sheet macro
.NH 2
.I groff
macros not appearing in
AT&T
.I troff
.XS
	\fIgroff\fP
macros not appearing in
AT&T
.I troff
.XE
.LP
The
.I "groff -ms"
macros have a few minor extensions compared to the
.Acr AT&T
.I "troff -ms"
macros.
.IP \&.AM 0.5i
Improved accent marks.
.IP "\&.DS I"
Indented display.
The default behavior of
.Acr AT&T
.I "troff -ms"
was to indent; the
.I groff
default prints displays flush left with the body text.
.IP \&.CW
Print text in
.CW "constant width"
(Courier) font.
.IP \&.IX
Indexing term (printed on standard error).
.PP
The
.CW MINGW
number register specifies a minimum space between columns
(for multi-column output); this takes the place of the
.CW GW
register that was documented but apparently not implemented in
.Acr AT&T
.I troff .
Several new string registers are available as well.
You can change these to handle (for example) the local language.
.IP REFERENCES 0.5i
Contains the string printed at the beginning of the
references (bibliography) page.
.IP ABSTRACT
Contains the string printed at the beginning of the abstract.
.IP TOC
.br
Contains the string printed at the beginning of the table of contents.
.\" ------------------------
.if t .bp
.NH 1
Acknowledgements
.XS
Acknowledgements
.XE
.LP
Two documents provided essential reference material:
.IP \(bu
The
.I "Groff and Friends HOWTO" ,
.R
by Dean Allen Provins.
.IP \(bu
.I "Using the -ms Macros with Troff and Nroff" ,
.R
the original
.Acr AT&T
document by M. E. Lesk.
.LP
Without these documents close at hand,
writing this document would have been a
much more difficult task.
.\" ------------------------
.\" Toc here at end...
.\" We need to fix the headers...
.TC
.
.
.\" Local Variables:
.\" fill-column: 72
.\" mode: nroff
.\" End:
.\" vim: set filetype=groff textwidth=72:
