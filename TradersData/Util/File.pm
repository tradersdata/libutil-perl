package TradersData::Util::File;
use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);
require Exporter;
use Carp qw(confess);
@ISA = qw(Exporter);
@EXPORT = qw();
@EXPORT_OK = qw(backup);
$VERSION = '0.00.02';

our($msg);

sub backup
{
  my $file = shift || confess 'missing required arg', "\n";
  confess "$file: file not found\n" unless -f $file;
  my $ver = '01';
  my $failed = 0;
  while(-f "${file}_$ver")
  {
     # Backup numbers are strings to protect leading 0,
     # but "converted" to integers for incrementing.
     $ver += 0;
     $ver = sprintf "%02d", ++$ver;
     last if $ver eq '09';
  }
  $msg = "[backup] $file";
  my $backup = "${file}_$ver";
  if(-f $backup)
  {
     $failed = 2;
  }
  elsif(rename $file,$backup)
  {
      $msg .= " => $backup";
  }
  else
  {
     $failed = 1;
  }
  ($failed > 0) and $msg .= ' FAILED';
  ($failed == 2) and $msg .= ' (backup nums exhausted)';
  $msg =~ s! \.?/?\S+/! !g;
  $failed ? 0 : $backup;
}

1;

__END__


# $Id: v 0.00.02   2012/10/08 12:35:49  deh, cetus $
