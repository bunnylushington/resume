package ResRender::HTML;

use strict;
use autodie;
use feature qw[ :5.10 ];

use ResRender qw[ :all ];

sub render {
  my (undef, $data, $output) = @_;
  open my $fh, ">", filepath($data, 'html', $output);
  header($data, $fh);
  close $fh;
}

sub header {
  my ($data, $fh) = @_;
  say $fh div({class => 'name'}, name($data));
  say $fh div({class => 'address'}, $_) for addresses($data);
  say $fh div({class => 'contact'}, 
              join " &mdash; ", email($data), phone($data));
}

sub div {
  my ($attrs, $text) = @_;
  my $att = swig_attrs($attrs);
  "<div $att>$text</div>";
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
