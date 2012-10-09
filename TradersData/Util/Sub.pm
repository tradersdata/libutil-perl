package TradersData::Util::Sub;
use strict;
require Exporter;
require Carp;
our($VERSION, @ISA, @EXPORT, @EXPORT_OK);
@ISA = qw(Exporter);
@EXPORT = qw();
@EXPORT_OK = qw(validate);
$VERSION = '0.00.01';

use constant TDBG => $ENV{tdbg} || '';

sub validate
{
  # usage: validate(\%opts_given,\@required,\@optional)
  #
  # All errors fatal. (Wrap it in eval if override needed.)

    my $me = (caller 0)[3];
    my @caller = (caller 1)[1..3];

  # Incoming data structures copied to keep original data intact.
  # Anonymous array of required options "hashified" for processing.
    my %given = %{$_[0]};
    my %required = ( map { $_ => 1 } @{$_[1]} );
    my @valid = $_[2] ? ((keys %required),@{$_[2]}) : (keys %required);

  # Delete %required keys matching %given keys. Remainders are missing.
    delete @required{keys %given};
  # Delete %given keys matching @valid. Remainders are invalid.
    delete @given{@valid};
    return 1 unless %given or %required;   # everything ok

    my @err = ("[$caller[2]]");
    push @err, 'missing: ' . join(',', keys %required) if %required;
    push @err, map { "unknown: $_ $given{$_}" } sort keys %given;
    push @err, "\t " . _stackinf(), "\t " . _dump(@_);
    Carp::confess map {$_, "\n" } @err if TDBG;
    die map {$_, "\n" } @err;
}

sub _stackinf
{
    my @line = ((caller 2)[2]);
    my $another = (caller 3)[2];
    unshift @line, $another if defined($another) and $another ne $line[0];
    'at ' . (caller 2)[1] . ' line ' . join(',', @line);
}

sub _dump
{
    my $dump = 'reqd: ';
    my $enum;
    if( @{$_[1]} )
    {
        $enum = join(',', @{$_[1]});
        $dump .= $enum;
        $enum = join(',', map($_[0]->{$_} || '', @{$_[1]}));
        $dump .= ' (' . $enum . ')';
    }
    else
    {
       $dump .= 'none ()';
    }
    $dump .= ' optl: ';
    if( @{$_[2]} )
    {
        $enum = join(',', @{$_[2]});
        $dump .= $enum;
        $enum = join(',', map($_[0]->{$_} || '', @{$_[2]}));
        $dump .= ' [' . $enum . ']';
    }
    else
    {
       $dump .= 'none ()';
    }
    $dump;
}

1;

__END__

# Copyright 2012 Donald E. Hammond, TradersData.com

# This program is free software, licensed under the GPL.
# (see: http://tradersdata.com/code/gpl-v3.txt)

# Additional terms are simple:
#    All rights are granted to do anything with this code, except take
#    it and claim it as your own. If used or distributed publicly,
#    attribution is required.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# $Id: v 0.00.02   2012/10/08 03:01:52  deh, cetus $
