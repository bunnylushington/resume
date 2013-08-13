package ResRender;

use strict;
require Exporter;

our @ISA = qw[ Exporter ];
our @EXPORT_OK = qw[ show_work 
                     filepath 
                     name 
                     phone
                     email
                     addresses
                     experiences
                     location
                     title
                     startdate
                     enddate
                     company
                     showwork
                     work
                  ];
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

sub show_work {
  my $val = lc(shift);
  ($val eq 'no' or $val eq 'false' or $val == 0) ? 0 : 1;
}

sub filepath {
  my ($data, $ext, $output) = @_;
  "$output/" . $data->{format_options}->{basename} . ".$ext";
}

sub name { shift->{name} }
sub phone { shift->{telephone} }
sub email { shift->{email} }

sub addresses {
  my $add = shift->{address};
  (ref $add eq 'ARRAY') ? @{ $add } : ($add);
}

sub experiences { 
  my $exp = shift->{experience};
  @{ $exp }
}

sub location { shift->{location} }
sub title { shift->{title} }
sub startdate { shift->{"start-date"} }
sub enddate { shift->{"end-date"} }
sub company { shift->{company} }
sub showwork { shift->{showwork} }
sub work {}

1;

__END__

