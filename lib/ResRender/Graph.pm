package ResRender::Graph;

use strict;
use Data::Dumper;
use Date::Calc;
use ResRender qw[ :all ];
use feature qw[ :5.10 ];
use FindBin;

my @colors = qw[ orange
                 purple
                 magenta
                 redorange
                 yellow2
                 green
                 darkblue
                 lavender
                 claret
                 lightorange
                 dullyellow
                 kelleygreen
                 blue
                 lightpurple
                 coral
                 yelloworange
                 teal
                 oceanblue
                 powderblue
                 tan1
                 pink
                 drabgreen
                 skyblue
                 powderblue2
                 tan2
                 yellowgreen
                 limegreen
              ];

sub render {
  my (undef, $data, $output) = @_;
  mkdir "$output/plots" unless -d "$output/plots";
  my $dates = make_date_hash($data);
  my $categories = make_categories($data);
  my @plots = ();
  for my $c (@{ $categories }) {
    my $category = $c->[0];
    my $itemlist = $c->[1];
    my @items = map { $_->[0] } @{ $itemlist };

    open P, ">", "$output/../work/$category";
    push @plots => $category;

    say P "PlotArea = left:150 bottom:60 top:0 right:50";
    say P "Alignbars = justify";
    say P "DateFormat = dd/mm/yyyy";
    say P "ImageSize = width:800 height:300";
    say P "Period = from:01/01/1995 till:01/01/2014";
    say P "TimeAxis = orientation:horizontal format:yyyy";
    say P "ScaleMajor = increment:2 start:1995";
    say P "Fonts = \n  id:sans font:OpenSans-Regular";
    
    say P "Colors =";
    for my $i (0 .. $#items) {
      say P " id:$i value:$colors[$i]";
    }
    say P " id:job value:gray(0.8)";

    say P "BarData =";
    for my $i (0 .. $#items) {
      say P qq! bar:$i text:"$items[$i]" !;
    }
    say P qq!  bar:jobs !;

    say P "PlotData =";
    my $pd = join " " => qw[ width:10
                             textcolor:black
                             align:left
                             mark:(line,white)
                             anchor:from
                             shift:(10,-4) ];
    say P "  $pd";
    my %ends = ();
    for my $i (0 .. $#items) {
      my ($skill, $keys) =  @{ $itemlist->[$i] };
      for my $jobkey (@{ $keys }) {
        my $from = $dates->{$jobkey}->{start};
        my $till = $dates->{$jobkey}->{end};
        $ends{$till}++;
         say P "  bar:$i from:$from till:$till color:$i";
       }
    }

    my $legend_param = 'bar:jobs color:white textcolor:job';
    for my $key (keys %{ $dates }) {
      my $from = $dates->{$key}->{start};
      my $till = $dates->{$key}->{end};
      my $text = $dates->{$key}->{label};
      say P "   $legend_param from:$from till:$till text:$text";
    }
  }

  for my $plot (@plots) {
    print `$FindBin::Bin/timeline $plot`;
  }

}


sub make_categories {
  my ($data) = shift;
  my @categories = ();
  my $tech = $data->{technology};
  for my $c (@{ $tech }) {
    my @category_data = ();
    my ($category, $l) = each %{ $c };
    for my $i (@{ $l }) {
      my ($item, $key_string) = each %{ $i };
      my @keys = split /\s*,\s*/ => $key_string;
      push @category_data => [$item, \@keys];
    }
    push @categories => [$category, \@category_data];
  }
  return \@categories;
  # [ [Languages, [ [Perl, [j1, j2, j3]], [Tcl, [j1, j2]] ]], [Infra ... ] ]
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
  my ($y, $m, $d) = Date::Calc::Decode_Date_US2("$month 15, $year");
  sprintf "%02d/%02d/%d" => $d, $m, $y;
}

sub end_to_js {
  my $date = shift;
  my ($month, $year) = split /\s+/ => $date;
  my ($y, $m, $d) = (lc $date eq 'present') 
    ? Date::Calc::Today : Date::Calc::Decode_Date_US2("$month, 15, $year");
  sprintf "%02d/%02d/%d" => $d, $m, $y;
}


1;

__DATA__
