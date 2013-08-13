package ResRender;

use strict;
require Exporter;

our @ISA = qw[ Exporter ];
our @EXPORT_OK = qw[ show_work 
                     centerline
                     filepath 
                     name 
                     phone
                     email
                     addresses
                  ];
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

sub centerline {
  my $text = shift;
  ' ' x ((80 - length($text)) / 2) . $text;
}

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


1;

__END__

