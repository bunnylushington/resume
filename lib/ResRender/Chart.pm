package ResRender::Chart;

use strict;
use Data::Dumper;
use lib '..'; # for flycheck-mode only.
use ResRender qw[ :all ];
use feature qw[ :5.10 ];
use FindBin;

chomp(our $PRESENT = `date +"%B %Y"`);


sub render {
  my ($undef, $data, $output) = @_;
  say $output;
#  say Dumper $data;
  my $date_map = experience_to_dates($data);
  my $tech_list = technology_to_dates($data, $date_map);
  my $datatable = make_datatable($tech_list);
}

sub make_datatable {
  my $list = shift;
  my $datatable = ();
  for my $tech (
    sort {$a->[0] cmp $b->[0] || $ a->[1] cmp $b->[1]} @{ $list } ) {
    my $name = $tech->[0];
    my $category = $tech->[1];
    my $acc = qq![ '$name', !;

    
  }
}

sub present {
  my $x = shift;
  lc($x) eq 'present' ? $PRESENT : $x;
}

sub technology_to_dates {
  my ($data, $date_map) = @_;
  my @map = ();
  for my $category (@{ $data->{technology} }) {
    my ($c, $list) = each %{ $category };
    for my $tech (@{ $list }) {
      my ($item, $key_string) = each %{ $tech };
      my @dates = map { $date_map->{$_} } split /\s*,\s*/, $key_string;
      push @map => [$item, $c, @dates];
    }
  }
  return wantarray ? @map : \@map;
}


sub experience_to_dates {
  my $data = shift;
  my %map = ();
  for my $e (@{ $data->{experience} }) {
    $map{$e->{key}} = [$e->{'start-date'}, present($e->{'end-date'})];
  }
  return wantarray ? %map : \%map;
}



#  my $categories = make_categories($data);
  
#   for my $c (@{ $categories }) {
#     my ($category, $itemlist) = @{ $c };

#     for my $item (@{ $itemlist }) {
#       my ($skill, $jobkeys) = @{ $item };
#       push @bar_data => qq!bar:$bar_idx text:"$skill"!;
#       for my $jobkey (@{ $jobkeys }) {
#         my $from = $dates->{$jobkey}->{start};
#         my $till = $dates->{$jobkey}->{end};
#         push @plot_data => qq!bar:$bar_idx from:$from till:$till color:$color!;
#       }


    
#     print Dumper $c;
#     last;
#   }
# }


# sub make_categories {
#   my ($data) = shift;
#   my @categories = ();
#   my $tech = $data->{technology};
#   for my $c (@{ $tech }) {
#     my @category_data = ();
#     my ($category, $l) = each %{ $c };
#     for my $i (@{ $l }) {
#       my ($item, $key_string) = each %{ $i };
#       my @keys = split /\s*,\s*/ => $key_string;
#       push @category_data => [$item, \@keys];
#     }
#     push @categories => [$category, \@category_data];
#   }
#   return \@categories;
#   # [ [Languages, [ [Perl, [j1, j2, j3]], [Tcl, [j1, j2]] ]], [Infra ... ] ]
# }

# 1;
1;
