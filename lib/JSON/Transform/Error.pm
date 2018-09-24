package JSON::Transform::Error;

use 5.014;
use strict;
use warnings;
use Moo;
use Types::Standard -all;
use JSON::Transform::Library -all;
use Return::Type;
use Function::Parameters;
use JSON::Transform::Debug qw(_debug);

use constant DEBUG => $ENV{JSON_TRANSFORM_DEBUG};
my %NONENUM = map { ($_ => 1) } qw(original_error);

=head1 NAME

JSON::Transform::Error - JSON::Transform error object

=head1 SYNOPSIS

  use JSON::Transform::Error;
  die JSON::Transform::Error->new(message => 'Something is not right...');

=head1 DESCRIPTION

Class implementing JSON::Transform error object.

=head1 ATTRIBUTES

=head2 message

=cut

has message => (is => 'ro', isa => Str, required => 1);

=head2 original_error

If there is an original error to be preserved.

=cut

has original_error => (is => 'ro', isa => Any);

=head2 locations

Array-ref of L<JSON::Transform::Library/DocumentLocation>s.

=cut

has locations => (is => 'ro', isa => ArrayRef[DocumentLocation]);

=head2 path

Array-ref of L<JSON::Transform::Library/StrNameValid>s or C<Int>s describing
the path from the top operation (being either fields, or a List offset).

=cut

has path => (is => 'ro', isa => ArrayRef[StrNameValid | Int]);

=head1 METHODS

=head2 is

Is the supplied scalar an error object?

=cut

method is(Any $item) :ReturnType(Bool) { ref $item eq __PACKAGE__ }

=head2 coerce

If supplied scalar is an error object, return. If not, return one with
it as message. If an object, message will be stringified version of that,
it will be preserved as C<original_error>.

=cut

method coerce(
  Any $item
) :ReturnType(InstanceOf[__PACKAGE__]) {
  DEBUG and _debug('Error.coerce', $item);
  return $item if __PACKAGE__->is($item);
  $item ||= 'Unknown error';
  !is_Str($item)
    ? $self->new(message => $item.'', original_error => $item)
    : $self->new(message => $item);
}

=head2 but

Returns a copy of the error object, but with the given properties (as
with a C<new> method, not coincidentally) overriding the existing ones.

=cut

sub but :ReturnType(InstanceOf[__PACKAGE__]) {
  my $self = shift;
  $self->new(%$self, @_);
}

=head2 to_string

Converts to string.

=cut

method to_string() :ReturnType(Str) {
  $self->message;
}

=head2 to_json

Converts to a JSON-able hash, in the format to send back as a member of
the C<errors> array in the results.

=cut

method to_json() :ReturnType(HashRef) {
  +{ map { ($_ => $self->{$_}) } grep !$NONENUM{$_}, keys %$self };
}

__PACKAGE__->meta->make_immutable();

1;
