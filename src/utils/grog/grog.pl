#! /usr/bin/env perl
# grog - guess options for groff command
# Inspired by doctype script in Kernighan & Pike, Unix Programming
# Environment, pp 306-8.

# Copyright (C) 1993-2021 Free Software Foundation, Inc.
# Written by James Clark.
# Rewritten with Perl by Bernd Warken <groff-bernd.warken-72@web.de>.
# The macros for identifying the devices were taken from Ralph
# Corderoy's 'grog.sh' of 2006.
# Hacked up by G. Branden Robinson, 2021.

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

require v5.6;

use warnings;
use strict;

use File::Spec;

# for running shell based programs within Perl; use `` instead of
# use IPC::System::Simple qw(capture capturex run runx system systemx);

$\ = "\n";

my $groff_version = 'DEVELOPMENT';

my @command = ();		# the constructed groff command
my @requested_package = ();	# arguments to '-m' grog options
my $do_run = 0;			# run generated 'groff' command
my $use_compatibility_mode = 0;	# is -C being passed to groff?

my $program_name = $0;
{
  my ($v, $d, $f) = File::Spec->splitpath($program_name);
  $program_name = $f;
}

my @request = ('ab', 'ad', 'af', 'aln', 'als', 'am', 'am1', 'ami',
	       'ami1', 'as', 'as1', 'asciify', 'backtrace', 'bd', 'blm',
	       'box', 'boxa', 'bp', 'br', 'brp', 'break', 'c2', 'cc',
	       'ce', 'cf', 'cflags', 'ch', 'char', 'chop', 'class',
	       'close', 'color', 'composite', 'continue', 'cp', 'cs',
	       'cu', 'da', 'de', 'de1', 'defcolor', 'dei', 'dei1',
	       'device', 'devicem', 'di', 'do', 'ds', 'ds1', 'dt', 'ec',
	       'ecr', 'ecs', 'el', 'em', 'eo', 'ev', 'evc', 'ex', 'fam',
	       'fc', 'fchar', 'fcolor', 'fi', 'fp', 'fschar',
	       'fspecial', 'ft', 'ftr', 'fzoom', 'gcolor', 'hc',
	       'hcode', 'hla', 'hlm', 'hpf', 'hpfa', 'hpfcode', 'hw',
	       'hy', 'hym', 'hys', 'ie', 'if', 'ig', 'in', 'it', 'itc',
	       'kern', 'lc', 'length', 'linetabs', 'lf', 'lg', 'll',
	       'lsm', 'ls', 'lt', 'mc', 'mk', 'mso', 'msoquiet', 'na',
	       'ne', 'nf', 'nh', 'nm', 'nn', 'nop', 'nr', 'nroff', 'ns',
	       'nx', 'open', 'opena', 'os', 'output', 'pc', 'pev', 'pi',
	       'pl', 'pm', 'pn', 'pnr', 'po', 'ps', 'psbb', 'pso',
	       'ptr', 'pvs', 'rchar', 'rd', 'return', 'rfschar', 'rj',
	       'rm', 'rn', 'rnn', 'rr', 'rs', 'rt', 'schar', 'shc',
	       'shift', 'sizes', 'so', 'soquiet', 'sp', 'special',
	       'spreadwarn', 'ss', 'stringdown', 'stringup', 'sty',
	       'substring', 'sv', 'sy', 'ta', 'tc', 'ti', 'tkf', 'tl',
	       'tm', 'tm1', 'tmc', 'tr', 'trf', 'trin', 'trnt', 'troff',
	       'uf', 'ul', 'unformat', 'vpt', 'vs', 'warn', 'warnscale',
	       'wh', 'while', 'write', 'writec', 'writem');

my @macro_ms = ('RP', 'TL', 'AU', 'AI', 'DA', 'ND', 'AB', 'AE',
		'QP', 'QS', 'QE', 'XP',
		'NH',
		'R',
		'CW',
		'BX', 'UL', 'LG', 'NL',
		'KS', 'KF', 'KE', 'B1', 'B2',
		'DS', 'DE', 'LD', 'ID', 'BD', 'CD', 'RD',
		'FS', 'FE',
		'OH', 'OF', 'EH', 'EF', 'P1',
		'TA', '1C', '2C', 'MC',
		'XS', 'XE', 'XA', 'TC', 'PX',
		'IX', 'SG');

my @macro_man = ('BR', 'IB', 'IR', 'RB', 'RI', 'P', 'TH', 'TP', 'SS',
		 'HP', 'PD',
		 'AT', 'UC',
		 'SB',
		 'EE', 'EX',
		 'OP',
		 'MT', 'ME', 'SY', 'YS', 'TQ', 'UR', 'UE');

my @macro_man_or_ms = ('B', 'I', 'BI',
		       'DT',
		       'RS', 'RE',
		       'SH',
		       'SM',
		       'IP', 'LP', 'PP');

my %user_macro;
my %Groff =
  (
   # preprocessors
   'chem' => 0,
   'eqn' => 0,
   'gperl' => 0,
   'grap' => 0,
   'grn' => 0,
   'gideal' => 0,
   'gpinyin' => 0,
   'lilypond' => 0,

   'pic' => 0,
   'PS' => 0,		# opening for pic
   'PE' => 0,		# closing for pic
   'PF' => 0,		# alternative closing for pic

   'refer' => 0,
   'refer_open' => 0,
   'refer_close' => 0,
   'soelim' => 0,
   'tbl' => 0,

   # for mdoc and mdoc-old
   # .Oo and .Oc for modern mdoc, only .Oo for mdoc-old
   'Oo' => 0,		# mdoc and mdoc-old
   'Oc' => 0,		# mdoc
   'Dd' => 0,		# mdoc
  ); # end of %Groff

my @standard_macro = ();
push(@standard_macro, @macro_ms, @macro_man, @macro_man_or_ms);
for my $key (@standard_macro) {
  $Groff{$key} = 0;
}

my @filespec;

my @main_package = ('an', 'doc', 'doc-old', 'e', 'm', 'om', 's');
my $inferred_main_package = '';

# .TH is both a man(7) macro and often used with tbl(1).  We expect to
# find .TH in ms(7) documents only between .TS and .TE calls, and in
# man(7) documents only as the first macro call.
my $have_seen_first_macro_call = 0;
my $inside_tbl_table = 0;
# man(7) and ms(7) use many of the same macro names; do extra checking.
my $man_score = 0;
my $ms_score = 0;

my $had_inference_problem = 0;
my $had_processing_problem = 0;
my $have_any_valid_arguments = 0;


sub fail {
  my $text = shift;
  print STDERR "$program_name: error: $text";
  $had_processing_problem = 1;
}


sub warn {
  my $text = shift;
  print STDERR "$program_name: warning: $text";
}


sub process_arguments {
  my $no_more_options = 0;
  my $delayed_option = '';
  my $was_minus = 0;
  my $optarg = 0;
  my $pdf_with_ligatures = 0;

  foreach my $arg (@ARGV) {
    if ( $optarg ) {
      push @command, $arg;
      $optarg = 0;
      next;
    }

    if ($no_more_options) {
      push @filespec, $arg;
      next;
    }

    if ($delayed_option) {
      if ($delayed_option eq '-m') {
	push @requested_package, $arg;
      } else {
	push @command, $delayed_option;
      }

      push @command, $arg;
      $delayed_option = '';
      next;
    }

    unless ( $arg =~ /^-/ ) { # file name, no opt, no optarg
      push @filespec, $arg;
      next;
    }

    # now $arg starts with '-'

    if ($arg eq '-') {
      unless ($was_minus) {
	push @filespec, $arg;
	$was_minus = 1;
      }
      next;
    }

    if ($arg eq '--') {
      $no_more_options = 1;
      next;
    }

    # Handle options that cause an early exit.
    &version() if ($arg eq '-v' || $arg eq '--version');
    &help() if ($arg eq '-h' || $arg eq '--help');

    if ($arg =~ '^--.') {
      if ($arg =~ '^--(run|with-ligatures)$') {
	$do_run = 1             if ($arg eq '--run');
	$pdf_with_ligatures = 1 if ($arg eq '--with-ligatures');
      } else {
        &fail("unrecognized grog option '$arg'; ignored");
      }
      next;
    }

    # Handle groff options that take an argument.

    # Handle the option argument being separated by whitespace.
    if ($arg =~ /^-[dfFIKLmMnoPrTwW]$/) {
      $delayed_option = $arg;
      next;
    }

    # Handle '-m' option without subsequent whitespace.
    if ($arg =~ /^-m/) {
      my $package = $arg;
      $package =~ s/-m//;
      push @requested_package, $package;
      next;
    }

    # Treat anything else as (possibly clustered) groff options that
    # take no arguments.

    # Our do_line() needs to know if it should do compatibility parsing.
    $use_compatibility_mode = 1 if ($arg =~ /C/);

    push @command, $arg;
  }

  if ($pdf_with_ligatures) {
    push @command, '-P-y';
    push @command, '-PU';
  }

  @filespec = ('-') unless (@filespec);
} # process_arguments()


sub process_input {
  foreach my $file ( @filespec ) {
    unless ( open(FILE, $file eq "-" ? $file : "< $file") ) {
      &fail("cannot open '$file': $!");
      next;
    }

    $have_any_valid_arguments = 1;

    while (my $line = <FILE>) {
      chomp $line;
      &do_line($line);
    }

    close(FILE);
  } # end foreach
} # process_input()


sub do_line {
  my $command;			# request or macro name
  my $args;			# request or macro arguments

  my $line = shift;

  # Check for a Perl Pod::Man comment.
  #
  # An alternative to this kludge is noted below: if a "standard" macro
  # is redefined, we could delete it from the relevant lists and
  # hashes.
  if ($line =~ /\\\" Automatically generated by Pod::Man/) {
    $man_score += 100;
  }

  # Strip comments.
  $line =~ s/\\".*//;
  $line =~ s/\\#.*//;

  return unless ($line =~ /^[.']/);	# Ignore text lines.

  # Normalize control lines; convert no-break control character to the
  # regular one and remove unnecessary whitespace.
  $line =~ s/^['.]\s*/./;
  $line =~ s/\s+$//;

  return if ($line =~ /^\.$/);		# Ignore empty request.
  return if ($line =~ /^\.\\?\.$/);	# Ignore macro definition ends.

  # Split control line into a request or macro call and its arguments.

  # Handle single-letter macro names.
  if ($line =~ /^\.(\w)(\s+(.*))?$/) {
    $command = $1;
    $args = $2;
  # Handle two-letter macro/request names in compatibility mode.
  } elsif ($use_compatibility_mode) {
    $line =~ /^\.(\w\w)\s*(.*)$/;
    $command = $1;
    $args = $2;
  # Handle multi-letter macro/request names in groff mode.
  } else {
    $line =~ /^\.(\w+)(\s+(.*))?$/;
    $command = $1;
    $args = $3;
  }

  $command = '' unless ($command);
  $args = '' unless ($args);

  if ((!$have_seen_first_macro_call) && ($command eq 'TH')) {
    # .TH as the first macro call in a document screams man(7).
    $man_score += 100;
  }

  ######################################################################
  # user-defined macros

  # If the line calls a user-defined macro, skip it.
  return if (exists $user_macro{$command});

  # Add user-defined macro names to %user_macros.
  #
  # Macros can also be defined with .dei{,1}, ami{,1}, but supporting
  # that would be a heavy lift for the benefit of users that probably
  # don't require grog's help.  --GBR
  if ($command =~ /^(de|am)1?$/) {
    my $name = $args;
    # Strip off any end macro.
    $name =~ s/\W*$//;
    # XXX: If the macro name shadows a standard macro name, maybe we
    # should delete the latter from our lists and hashes.  This might
    # depend on whether the document is trying to remain compatibile
    # with an existing interface, or simply colliding with names they
    # don't care about (consider a raw roff document that defines 'PP').
    # --GBR
    $user_macro{$name} = 0 unless (exists $user_macro{$name});
    return;
  }

  # Ignore all other requests.
  return if (grep(/$command/, @request));

  $have_seen_first_macro_call = 1;


  ######################################################################
  # preprocessors

  if ( $command =~ /^(cstart)|(begin\s+chem)$/ ) {
    $Groff{'chem'}++;		# for chem
    return;
  }
  if ( $command =~ /^EQ$/ ) {
    $Groff{'eqn'}++;		# for eqn
    return;
  }
  if ( $command =~ /^G1$/ ) {
    $Groff{'grap'}++;		# for grap
    return;
  }
  if ( $command =~ /^Perl/ ) {
    $Groff{'gperl'}++;		# for gperl
    return;
  }
  if ( $command =~ /^pinyin/ ) {
    $Groff{'gpinyin'}++;		# for gperl
    return;
  }
  if ( $command =~ /^GS$/ ) {
    $Groff{'grn'}++;		# for grn
    return;
  }
  if ( $command =~ /^IS$/ ) {
    $Groff{'gideal'}++;		# preproc gideal for ideal
    return;
  }
  if ( $command =~ /^lilypond$/ ) {
    $Groff{'lilypond'}++;	# for glilypond
    return;
  }

  # pic is opened by .PS and can be closed by either .PE or .PF
  if ( $command =~ /^PS$/ ) {
    $Groff{'PS'}++;		# opening for pic
    return;
  }
  if ( $command =~ /^PE$/ ) {
    $Groff{'PE'}++;		# closing for pic
    return;
  }
  if ( $command =~ /^PF$/ ) {
    $Groff{'PF'}++;		# alternate closing for pic
    return;
  }

  if ( $command =~ /^R1$/ ) {
    $Groff{'refer'}++;		# for refer
    return;
  }
  if ( $command =~ /^\[$/ ) {
    $Groff{'refer_open'}++;	# for refer open
    return;
  }
  if ( $command =~ /^\]$/ ) {
    $Groff{'refer_close'}++;	# for refer close
    return;
  }
  if ( $command =~ /^TS$/ ) {
    $Groff{'tbl'}++;		# for tbl
    $inside_tbl_table = 1;
    return;
  }
  if ( $command =~ /^TE$/ ) {
    $Groff{'tbl'}++;		# for tbl
    $inside_tbl_table = 0;
    return;
  }
  if ( $command =~ /^TH$/ ) {
    if ($inside_tbl_table) {
      $Groff{'tbl'}++;		# for tbl
    }
    return;
  }


  ######################################################################
  # macro package (tmac)
  ######################################################################

  ##########
  # modern mdoc

  if ( $command =~ /^(Dd)$/ ) {
    $Groff{'Dd'}++;		# for modern mdoc
    return;
  }

  # In the old version of -mdoc 'Oo' is a toggle, in the new it's
  # closed by 'Oc'.
  if ( $command =~ /^Oc$/ ) {
    $Groff{'Oc'}++;		# only for modern mdoc
    return;
  }


  ##########
  # old and modern mdoc

  if ( $command =~ /^Oo$/ ) {
    $Groff{'Oo'}++;		# for mdoc and mdoc-old
    return;
  }


  ##########
  # old mdoc
  if ( $command =~ /^(Tp|Dp|De|Cx|Cl)$/ ) {
    $Groff{'mdoc-old'}++;	# true for old mdoc
    return;
  }

  ##########
  # me

  if ( $command =~ /^(
		      [ilnp]p|
		      sh
		    )$/x ) {
    $Groff{'me'}++;		# for me
    return;
  }


  #############
  # mm and mmse

  if ( $command =~ /^(
		      H|
		      MULB|
		      LO|
		      LT|
		      NCOL|
		      PH|
		      SA
		    )$/x ) {
    $Groff{'mm'}++;		# for mm and mmse
    if ( $command =~ /^LO$/ ) {
      if ( $args =~ /^(DNAMN|MDAT|BIL|KOMP|DBET|BET|SIDOR)/ ) {
	$Groff{'mmse'}++;	# for mmse
      }
    } elsif ( $command =~ /^LT$/ ) {
      if ( $args =~ /^(SVV|SVH)/ ) {
	$Groff{'mmse'}++;	# for mmse
      }
    }
    return;
  }

  ##########
  # mom

  if ( $command =~ /^(
		   ALD|
		   AUTHOR|
		   CHAPTER|
		   CHAPTER_TITLE|
		   COLLATE|
		   DOC_COVER|
		   DOCHEADER|
		   DOCTITLE|
		   DOCTYPE|
		   FAMILY|
		   FT|
		   FAM|
		   LEFT|
		   LL|
		   LS|
		   NEWPAGE|
		   NO_TOC_ENTRY|
		   PAGE|
		   PAGENUMBER|
		   PAGINATION|
		   PAPER|
		   PRINTSTYLE|
		   PT_SIZE|
		   SP|
		   START|
		   T_MARGIN|
		   TITLE|
		   TOC|
		   TOC_AFTER_HERE
		 )$/x ) {
    $Groff{'mom'}++;		# for mom
    return;
  }

  for my $key (@standard_macro) {
    $Groff{$key}++ if ($command eq $key);
  }
} # do_line()

my @m = ();
my @supplemental_package = ();
my @preprocessor = ();


sub infer_preprocessors {
  # preprocessors without 'groff' option
  if ( $Groff{'lilypond'} ) {
    push @preprocessor, 'glilypond';
  }
  if ( $Groff{'gperl'} ) {
    push @preprocessor, 'gperl';
  }
  if ( $Groff{'gpinyin'} ) {
    push @preprocessor, 'gpinyin';
  }

  # preprocessors with 'groff' option
  if ( $Groff{'PS'} &&  ( $Groff{'PE'} ||  $Groff{'PF'} ) ) {
    $Groff{'pic'} = 1;
  }
  if ( $Groff{'gideal'} ) {
    $Groff{'pic'} = 1;
  }

  $Groff{'refer'} ||= $Groff{'refer_open'} && $Groff{'refer_close'};

  if ( $Groff{'chem'} || $Groff{'eqn'} ||  $Groff{'gideal'} ||
       $Groff{'grap'} || $Groff{'grn'} || $Groff{'pic'} ||
       $Groff{'refer'} || $Groff{'tbl'} ) {
    push(@command, '-s') if $Groff{'soelim'};

    push(@command, '-R') if $Groff{'refer'};

    push(@command, '-t') if $Groff{'tbl'};	# tbl before eqn
    push(@command, '-e') if $Groff{'eqn'};

    push(@command, '-j') if $Groff{'chem'};	# chem produces pic code
    push(@command, '-J') if $Groff{'gideal'};	# gideal produces pic
    push(@command, '-G') if $Groff{'grap'};
    push(@command, '-g') if $Groff{'grn'};	# gremlin files for -me
    push(@command, '-p') if $Groff{'pic'};

  }
} # infer_preprocessors()


# Return true (1) if a main/full-service/exclusive package is inferred.
sub infer_man_or_ms_package {
  # Compute a score for each package by counting occurrences of their
  # characteristic macros.
  foreach my $key (@macro_man_or_ms) {
    $man_score += $Groff{$key};
    $ms_score += $Groff{$key};
  }

  foreach my $key (@macro_man) {
    $man_score += $Groff{$key};
  }

  foreach my $key (@macro_ms) {
    $ms_score += $Groff{$key};
  }

  if (!$ms_score && !$man_score) {
    # The input may be a "raw" roff document; this is not a problem.
    # Do nothing special.
  } elsif ($ms_score == $man_score) {
    # If there was no TH call, it's not a (valid) man(7) document.
    if (!$Groff{'TH'}) {
      $inferred_main_package = 's';
    } else {
      &warn("document ambiguous; disambiguate with -man or -ms option");
      $had_inference_problem = 1;
    }
    return 0;
  } elsif ($ms_score > $man_score) {
    $inferred_main_package = 's';
  } else {
    $inferred_main_package = 'an';
  }

  return 1;
} # infer_man_or_ms_package()


# Return true (1) if a main/full-service/exclusive package is inferred.
sub infer_macro_packages {
  # mdoc
  if ( ( $Groff{'Oo'} && $Groff{'Oc'} ) || $Groff{'Dd'} ) {
    $Groff{'Oc'} = 0;
    $Groff{'Oo'} = 0;
    $inferred_main_package = 'doc';
    return 1;	# true
  }
  if ( $Groff{'mdoc-old'} || $Groff{'Oo'} ) {
    $inferred_main_package = 'doc';
    return 1;	# true
  }

  # me
  if ( $Groff{'me'} ) {
    $inferred_main_package = 'e';
    return 1;	# true
  }

  # mm and mmse
  if ( $Groff{'mm'} ) {
    $inferred_main_package = 'm';
    return 1;	# true
  }
  # XXX: Is this necessary?  mmse "mso"s mm, but we probably already
  # detected mm macro calls anyway.  --GBR
  if ( $Groff{'mmse'} ) {	# Swedish mm
    return 1;	# true
  }

  # mom
  if ( $Groff{'mom'} ) {
    $inferred_main_package = 'om';
    return 1;	# true
  }

  return 0;
} # infer_macro_packages()


sub construct_command {
  my $file_args_included;	# file args now only at 1st preproc
  unshift @command, 'groff';
  if (@preprocessor) {
    my @progs;
    $progs[0] = shift @preprocessor;
    push(@progs, @filespec);
    for (@preprocessor) {
      push @progs, '|';
      push @progs, $_;
    }
    push @progs, '|';
    unshift @command, @progs;
    $file_args_included = 1;
  } else {
    $file_args_included = 0;
  }

  foreach (@command) {
    next unless /\s/;
    # when one argument has several words, use accents
    $_ = "'" . $_ . "'";
  }

  my @msupp = ();

  # If a full-service package was explicitly requested, clear any
  # inferred package (and warn if the inference differs from the
  # request).  This also ensures that all -m arguments are placed in the
  # same order that the user gave them; caveat dictator.
  for my $pkg (@requested_package) {
    if (grep(/$pkg/, @main_package)) {
      if ($pkg ne $inferred_main_package) {
	&warn("overriding inferred package '$inferred_main_package'"
	      . " with requested package '$pkg'");
      }
      $inferred_main_package = '';
    }
    push @msupp, '-m' . $pkg;
  }

  push @m, '-m' . $inferred_main_package if ($inferred_main_package);

  push @command, @m, @msupp;

  push(@command, @filespec) unless ( $file_args_included );

  #########
  # execute the 'groff' command here with option '--run'
  if ( $do_run ) { # with --run
    print STDERR "@command";
    my $cmd = join ' ', @command;
    system($cmd);
  } else {
    print "@command";
  }
} # construct_command()


sub help {
  my $grog = $program_name;
  print <<EOF;
usage: $grog [--ligatures] [--run] [GROFF-OPTION ...] [--] [FILE ...]
       $grog { -h | --help | -v | --version }

$grog reads each roff(7) input FILE and attempts to infer an appropriate
groff(1) command to format it.  If FILE is missing or is "-", then $grog
reads the standard input stream.  All arguments after a "--" argument
are treated as FILEs.

Options:
  -h, --help      Display this uasge message and exit.
  --ligatures     Include options '-P-y -PU' for gropdf(1) output driver,
                    which produces ligatures.  Requires '-T pdf'.
  --run           Report inferred command to the standard error stream
                    and then execute it.
  -v, --version   Display version information and exit.
EOF
  exit 0;
} # help()


sub version {
  print "$program_name (groff) $groff_version";
  exit 0;
} # version()


# initialize

my $in_unbuilt_source_tree = 0;
{
  my $at = '@';
  $in_unbuilt_source_tree = 1 if '@VERSION@' eq "${at}VERSION${at}";
}

$groff_version = '@VERSION@' unless ($in_unbuilt_source_tree);

&process_arguments();
&process_input();

if ($have_any_valid_arguments) {
  &infer_preprocessors();
  &infer_macro_packages() || &infer_man_or_ms_package();
  &construct_command();
}

exit 2 if ($had_processing_problem);
exit 1 if ($had_inference_problem);
exit 0;

# Local Variables:
# fill-column: 72
# mode: CPerl
# End:
# vim: set autoindent noexpandtab shiftwidth=2 softtabstop=2 textwidth=72:
