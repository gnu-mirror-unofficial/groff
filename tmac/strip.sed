2 i\
.\\" This is a generated file, created by `tmac/strip.sed' in groff's\
.\\" source code bundle from a file having `-u' appended to its name.
# strip comments, spaces, etc., after a line containing `%beginstrip%'
#
# 1. Strip whitespace after a leading ".".
# 2. Reduce old-style comment lines (.\") to the empty request (.).
# 3. Reduce new-style comment lines (\#) to the empty request.
# 4. Truncate trailing old-style comments.
# 5. Truncate trailing new-style comments (keeping line continuation).
# 6. Remove trailing whitespace and truncated old-style comments on
#    all lines that do not define or append to string registers.
# 7. Remove truncated old-style comments, preserving trailing
#    whitespace, on lines that defined or append to string registers.
# 8. Shorten mdoc symbol names.
# 9. Delete all lines containing only the empty request.
/%beginstrip%/,$ {
  s/^\.[	 ]*/./
  s/^\.\\".*/./
  s/^\\#.*/./
  s/\\".*/\\"/
  s/\\#.*/\\/
  /.[ad]s/!s/[	 ]*\\"//
  /.[ad]s/s/\([^	 ]*\)\\"/\1/
  s/\([^/]\)doc-/\1/g
}
/^\.$/d
