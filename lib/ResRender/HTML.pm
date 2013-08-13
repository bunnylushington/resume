package ResRender::HTML;

use strict;
use autodie;
use feature qw[ :5.10 ];

use ResRender qw[ :all ];

our $AUTOLOAD = ();

sub render {
  my (undef, $data, $output) = @_;
  open my $fh, ">", filepath($data, 'html', $output);
  preamble($data, $fh);
  header($data, $fh);
  experience($data, $fh);
  postamble($fh);
  close $fh;
}

sub preamble {
  my ($data, $fh) = @_; 
  say $fh "<html><head>";
  say $fh "<title>", name($data), " -- Resume</title>";
  print $fh $_ for <DATA>;
  say $fh "</head><body>";
} 

sub postamble {
  my $fh = shift;
  say $fh "</body></html>";
}
  
sub header {
  my ($data, $fh) = @_;
  say $fh div({class => 'name'}, name($data));
  say $fh div({class => 'address'}, $_) for addresses($data);
  say $fh div({class => 'contact'}, 
              join " &mdash; ", email($data), phone($data));
}

sub experience {
  my ($data, $fh) = @_;
  for my $e (experiences($data)) {
    my $dates = join " &ndash; ", startdate($e), enddate($e);
    say $fh qq!<div class="employer">!;
    say $fh div({class => "emp_head_one"},
                span({class => "company"}, company($e)) . 
                span({class => "dates"}, $dates));
    say $fh div({class => "emp_head_two"},
                span({class => "title"}, title($e)) .
                span({class => "location"}, location($e)));
    
    if (showwork($e)) {
      say $fh qq!<ul class="worklist">!;
      for my $w (work($e)) {
        say $fh li({class => "work"}, $w);
      }
      say $fh qq!</ul>!;
    }
  }

  say $fh "</div>\n";
}

sub AUTOLOAD {
  my ($att, $text) = @_;
  my $pkg = __PACKAGE__;
  (my $tag = $AUTOLOAD) =~ s/${pkg}:://;
  my $attrs = swig_attrs($att);
  qq!<$tag $attrs>$text</$tag>!;
}

sub swig_attrs {
  my $attrs = shift;
  my @ret = ();
  while (my ($k, $v) = each %{ $attrs }) {
    push @ret => qq!$k="$v"!;
  }
  return join " " => @ret;
}



1;

__END__
