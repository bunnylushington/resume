package ResRender::Graph;

use strict;
use Data::Dumper;
use Date::Calc;
use ResRender qw[ :all ];
use feature qw[ :5.10 ];
use FindBin;
use Digest::MD5 qw[ md5_hex ];

my @colors = qw[ drabgreen
                 orange
                 purple
                 magenta
                 teal
                 skyblue
                 claret
                 dullyellow
                 kelleygreen
                 blue
                 lightpurple
                 coral
                 yelloworange
                 green
                 oceanblue
                 powderblue
                 tan1
                 pink
                 skyblue
                 powderblue2
                 tan2
                 yellowgreen
                 limegreen
              ];

sub render {
  my (undef, $data, $output) = @_;
  my $dates = make_date_hash($data);
  my $categories = make_categories($data);
  mkdir "$output/plots" unless -d "$output/plots";
  my $data_file = "$output/../work/skills";
  open P, ">", $data_file;

  say P "PlotArea = left:200 bottom:60 top:0 right:60";
#  say P "Alignbars = justify";
  say P "DateFormat = dd/mm/yyyy";
  say P "ImageSize = width:800 height:800";
  say P "Period = from:01/01/1995 till:01/06/2016";
  say P "TimeAxis = orientation:horizontal format:yyyy";
  say P "ScaleMajor = increment:4 start:1995";
  say P "Fonts = \n  id:sans font:OpenSans-Regular";
  say P "Legend = orientation:vertical position:right";

  my $plot_spec = join " " => qw[ width:10 
                                  textcolor:black 
                                  align:left 
                                  mark:(line,white) 
                                  anchor:from
                                  shift:(10,-4) ];

  my ($color_idx, $bar_idx) = (0,1);
  my (@color_data, @plot_data, @bar_data) = ();
  for my $c (@{ $categories }) {
    my ($category, $itemlist) = @{ $c };
    my $color = md5_hex($category);
    push @color_data => sprintf qq!id:%s value:%s legend:%s! => 
      $color, $colors[$color_idx++], prep_cat($category);
    for my $item (@{ $itemlist }) {
      my ($skill, $jobkeys) = @{ $item };
      push @bar_data => qq!bar:$bar_idx text:"$skill"!;
      for my $jobkey (@{ $jobkeys }) {
        my $from = $dates->{$jobkey}->{start};
        my $till = $dates->{$jobkey}->{end};
        push @plot_data => qq!bar:$bar_idx from:$from till:$till color:$color!;
      }
      $bar_idx++;
    }
  }

  say P "Colors=";
  say P "  $_" for @color_data;
  say P "  id:job value:gray(0.8)";

  say P "BarData=";
  say P "  $_" for @bar_data;
  say P "  bar:jobs";           

  say P "PlotData=";
  say P "  $plot_spec";
  say P "  $_" for @plot_data;
  
  # my $legend_param = 'bar:jobs color:white textcolor:job';
  # for my $key (keys %{ $dates }) {
  #   my $from = $dates->{$key}->{start};
  #   my $till = $dates->{$key}->{end};
  #   my $text = $dates->{$key}->{label};
  #   say P "  $legend_param from:$from till:$till text:$text";
  # }

  close P;
  
  print `$FindBin::Bin/timeline skills`;
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

sub prep_cat {
  (my $cat = shift) =~ s/ /\\ /g;
  return $cat;
}

sub make_date_hash {
  my $data = shift;
  my %hash = ();
  for my $e (experiences($data)) {
    $hash{key($e)} = { start   => start_to_js(startdate($e)),
                       end     => end_to_js(enddate($e)),
                       company => company($e)}
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
