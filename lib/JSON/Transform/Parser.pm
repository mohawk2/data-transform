package JSON::Transform::Parser;

use 5.014;
use strict;
use warnings;
use base qw(Pegex::Parser);
use Exporter 'import';
use Return::Type;
use Types::Standard -all;
use Function::Parameters;
use JSON::Transform::Grammar;
use JSON::Transform::Receiver;
use JSON::Transform::Error;

use constant DEBUG => $ENV{JSON_TRANSFORM_DEBUG};

our @EXPORT_OK = qw(
  parse
);

=head1 NAME

JSON::Transform::Parser - JSON::Transform Pegex parser

=head1 SYNOPSIS

  use JSON::Transform::Parser qw(parse);
  my $parsed = parse(
    $source
  );

=head1 DESCRIPTION

Provides both an outside-accessible point of entry into the JSON::Transform
parser (see above), and a subclass of L<Pegex::Parser> to parse a document
into an AST usable by JSON::Transform.

=head1 METHODS

=head2 parse

  parse($source);

B<NB> that unlike in C<Pegex::Parser> this is a function, not an instance
method. This achieves hiding of Pegex implementation details.

=cut

my $GRAMMAR = JSON::Transform::Grammar->new; # singleton
fun parse(
  Str $source,
) :ReturnType(ArrayRef[HashRef]) {
  my $parser = __PACKAGE__->SUPER::new(
    grammar => $GRAMMAR,
    receiver => JSON::Transform::Receiver->new,
    debug => DEBUG,
  );
  my $input = Pegex::Input->new(string => $source);
  scalar $parser->SUPER::parse($input);
}

=head2 format_error

Override of parent method. Returns a L<JSON::Transform::Error>.

=cut

sub format_error :ReturnType(InstanceOf['JSON::Transform::Error']) {
    my ($self, $msg) = @_;
    my $buffer = $self->{buffer};
    my $position = $self->{farthest};
    my $real_pos = $self->{position};
    my ($line, $column) = @{$self->line_column($position)};
    my $pretext = substr(
        $$buffer,
        $position < 50 ? 0 : $position - 50,
        $position < 50 ? $position : 50
    );
    my $context = substr($$buffer, $position, 50);
    $pretext =~ s/.*\n//gs;
    $context =~ s/\n/\\n/g;
    return JSON::Transform::Error->new(
      locations => [ { line => $line, column => $column } ],
      message => <<EOF);
Error parsing Pegex document:
  msg:      $msg
  context:  $pretext$context
            ${\ (' ' x (length($pretext)) . '^')}
  position: $position ($real_pos pre-lookahead)
EOF
}

1;
