package ResRender::Graph;

use strict;
use Data::Dumper;
use ResRender qw[ :all ];

sub render_js {
  my (undef, $data, $output) = @_;
  my $dates = make_date_hash($data);
  my $rows = make_rows($data, $dates);
}

sub make_rows {
  my ($data, $dates) = @_;
  my $tech = $data->{technology};
  for my $category (@{ $tech }) {
    my ($cat, $list) = each %{ $category };
    for my $item ( @{ $list } ) {
      my ($label, $keys) = each %{ $item };
      for my $key ( split /\s*,\s*/ => $keys ) {
        my $start = $dates->{$key}->{start};
        my $end = $dates->{$key}->{end};
        my $co = $dates->{$key}->{label};
        print qq![ '$label', '$co',  $start, $end ],\n!;
      }
    }
  }
}


sub make_date_hash {
  my $data = shift;
  my %hash = ();
  for my $e (experiences($data)) {
    $hash{key($e)} = { start   => start_to_js(startdate($e)),
                       end     => end_to_js(enddate($e)),
                       company => company($e),
                       label   => shortname($e) }
  }
  return \%hash;
}

sub start_to_js {
  my $date = shift;
  my ($month, $year) = split /\s+/ => $date;
  qq!new Date("$month 15, $year")!;
}

sub end_to_js {
  my $date = shift;
  if (lc $date eq 'present') {
    qq!new Date()!;
  }
  else {
    my ($month, $year) = split /\s+/ => $date;
    qq!new Date("$month 15, $year")!;
  }
}


1;

__DATA__
