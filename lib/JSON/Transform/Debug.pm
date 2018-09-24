package JSON::Transform::Debug;

use 5.014;
use strict;
use warnings;
use Exporter 'import';

our @EXPORT_OK = qw(_debug);

=head1 NAME

JSON::Transform::Debug - debug JSON::Transform

=cut

=head1 SYNOPSIS

  use JSON::Transform::Debug qw(_debug);
  use constant DEBUG => $ENV{JSON_TRANSFORM_DEBUG};
  DEBUG and _debug('current_function', $value1, $value2);

=head1 DESCRIPTION

Creates debugging output when called. Intended to have its calls optimised
out when debugging not sought, using the construct shown above. The
values given will be passed through L<Data::Dumper/Dumper>.

=cut

# TODO make log instead of diag
sub _debug {
  my $func = shift;
  require Data::Dumper;
  require Test::More;
  local ($Data::Dumper::Sortkeys, $Data::Dumper::Indent, $Data::Dumper::Terse);
  $Data::Dumper::Sortkeys = $Data::Dumper::Indent = $Data::Dumper::Terse = 1;
  Test::More::diag("$func: ", Data::Dumper::Dumper([ @_ ]));
}

1;
