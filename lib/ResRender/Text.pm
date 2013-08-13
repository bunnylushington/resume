package ResRender::Text;

use strict;
use autodie;
use feature qw[ :5.10 ];

use ResRender qw[ :all ];

sub render {
  my (undef, $data, $output) = @_;
  open my $fh, ">", filepath($data, 'txt', $output);
  header($data, $fh);
  experience($data, $fh);
  close $fh;
}

sub header {
  my ($data, $fh) = @_;
  say $fh centerline(name($data));
  say $fh centerline($_) for addresses($data);
  say $fh centerline(join " --- ", email($data), phone($data));
  print $fh "\n";
}

sub experience {
  my ($data, $fh) = @_;
  for my $e (experiences($data)) {
    my $dates = join " -- ", startdate($e), enddate($e);
    say $fh pushline(company($e), $dates);
    say $fh pushline(title($e), location($e));

    print $fh "\n";
  }

}

sub pushline {
  my ($left, $right) = @_;
  my $space = ' ' x (80 - (length($left) + length($right)));
  $left . $space . $right;
}

sub centerline {
  my $text = shift;
  ' ' x ((80 - length($text)) / 2) . $text;
}

1;

__END__
