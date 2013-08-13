package ResRender::TeX;

use strict;
use autodie;
use feature qw[ :5.10 ];

use ResRender qw[ :all ];
our $AUTOLOAD = ();

sub render {
  my (undef, $data, $output) = @_;
  open my $fh, ">", filepath($data, 'tex', $output);
  preamble($fh);
  header($data, $fh);
  postamble($fh);
  close $fh;
}

sub preamble {
  my $fh = shift;
  print $fh $_ for <DATA>
}

sub postamble {
  my $fh = shift;
  say $fh "\\vfill\\eject";
}

sub header {
  my ($data, $fh) = @_;
  something("this is text");
  say $fh centerline(largeheadfont(name($data)));
  say $fh centerline(smallheadfont($_)) for addresses($data);
  say $fh centerline(smallheadfont(join " --- ", email($data), phone($data)));
  say "\\bigskip";
}
  
sub AUTOLOAD {
  my $text = shift;
  my $pkg = __PACKAGE__;
  (my $tag = $AUTOLOAD) =~ s/${pkg}:://;
  "\\${tag}{ $text }";
}

1;

__DATA__
% -- format.
\nopagenumbers
\overfullrule= 0pt
\nopagenumbers
\parindent=0pt
\vsize 9in
\voffset=-0.2in

% -- fonts.
\font\smallheadfont=cmr10 at 10truept
\font\largeheadfont=cmr10 at 20.74truept 
\font\headingfont=cmr10 at 14truept

% -- macros.
\def\entry#1{\parindent 5mm\item{--}{#1}\parindent 0pt}
\def\summary#1{\parindent 5mm\item{--}{#1}\parindent 0pt}

