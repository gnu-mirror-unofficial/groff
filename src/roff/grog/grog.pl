#! /usr/bin/env perl
# grog - guess options for groff command
# Inspired by doctype script in Kernighan & Pike, Unix Programming
# Environment, pp 306-8.

# Copyright (C) 1993-2020 Free Software Foundation, Inc.
# Written by James Clark.
# Rewritten with Perl by Bernd Warken <groff-bernd.warken-72@web.de>.
# The macros for identifying the devices were taken from Ralph
# Corderoy's 'grog.sh' of 2006.

# This file is part of 'grog', which is part of 'groff'.

# 'groff' is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.

# 'groff' is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see
# <http://www.gnu.org/licenses/gpl-2.0.html>.

########################################################################

require v5.6;

use warnings;
use strict;

# $Bin is the directory where this script is located
use FindBin;
# We need to portably construct file specifications.
use File::Spec::Functions 'catfile';

my $before_make;	# script before run of 'make'
{
  my $at = '@';
  $before_make = 1 if '@VERSION@' eq "${at}VERSION${at}";
}

our %at_at;

if ($before_make) {
  $at_at{'GROFF_VERSION'} = "DEVELOPMENT";
} else {
  $at_at{'GROFF_VERSION'} = '@VERSION@';
}

# Locate our subroutines file.  We might be installed, in a source tree,
# or in a separate build tree.
my $grog_dir = $FindBin::Bin;
die 'grog: "' . $grog_dir . '" does not exist or is not a directory'
  unless -d $grog_dir;

foreach my $dir ( $grog_dir, './src/roff/grog', '../src/roff/grog' ) {
  my $subs = catfile("$dir", "subs.pl");
  if ( -f $subs ) {
    $grog_dir = $dir;
    last;
  }
}

#############
# import subs

unshift(@INC, $grog_dir);
require 'subs.pl';


##########
# run subs

&handle_args();
&handle_file_ext(); # see $tmac_ext for gotten value
&handle_whole_files();
&make_groff_device();
&make_groff_preproc();
&make_groff_tmac_man_ms() || &make_groff_tmac_others();
&make_groff_line_rest();


1;
# Local Variables:
# mode: CPerl
# End:
