package ResRender::Graph;

use strict;
use Data::Dumper;
use ResRender qw[ :all ];

sub render {
  my (undef, $data, $output) = @_;
  my $dates = make_date_hash($data);
  print_header();
  my @catagories = make_rows($data, $dates);
  print_footer();
  print_divs(@catagories);
}

sub print_divs {
  for (@_) {
    print qq!<div id="$_" style="height: 100%"></div>!;
  }
}

sub print_header {
  print <<"EoF";
<script type="text/javascript" src="https://www.google.com/jsapi?autoload={'modules':[{'name':'visualization',
       'version':'1','packages':['timeline']}]}"></script>
<script type="text/javascript">
  google.setOnLoadCallback(drawChart);

function drawChart() {
EoF
}

sub print_footer {
 print "}</script>";
}



sub make_rows {
  my ($data, $dates) = @_;
  my @categories = ();
  my $tech = $data->{technology};
  for my $category (@{ $tech }) {
## --------------------------------------------------
    my ($cat, $list) = each %{ $category };
    push @categories => $cat;
    print <<"EndOfJS";
var container = document.getElementById('$cat');
var chart = new google.visualization.Timeline(container);
var t = new google.visualization.DataTable();

var options = {
  timeline: { showRowLabels: true, 
              groupByRowLabel: true, 
              colorByRowLabel: true  },
  avoidOverlappingGridLines: true
};

  
t.addColumn({ type: 'string', id: 'Technology' });
t.addColumn({ type: 'string', id: 'Employer' });
t.addColumn({ type: 'date', id: 'Start'});
t.addColumn({ type: 'date', id: 'End' });
  
t.addRows([
EndOfJS
  ;

    for my $item ( @{ $list } ) {
      my ($label, $keys) = each %{ $item };
      for my $key ( split /\s*,\s*/ => $keys ) {
        my $start = $dates->{$key}->{start};
        my $end = $dates->{$key}->{end};
        my $co = $dates->{$key}->{label};
        print qq![ '$label', '$co',  $start, $end ],\n!;
      }
    }
## --------------------------------------------------
    print <<"EndOfJS"

]);
chart.draw(t, options);
EndOfJS
;

  }
  return @categories
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
