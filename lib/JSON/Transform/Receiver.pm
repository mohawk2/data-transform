package JSON::Transform::Receiver;

use 5.014;
use strict;
use warnings;
use base 'Pegex::Receiver';
use Types::Standard -all;
use Function::Parameters;
use JSON::MaybeXS;
use Carp;

my $JSON = JSON::MaybeXS->new->allow_nonref->canonical;

my @KINDHASH = qw(
  exprMapping
);
my %KINDHASH21 = map { ($_ => 1) } @KINDHASH;

my @KINDFIELDS = qw(
  type
  input
  interface
);
my %KINDFIELDS21 = map { ($_ => 1) } @KINDFIELDS;

=head1 NAME

JSON::Transform::Receiver - JSON::Transform Pegex AST constructor

=cut

=head1 SYNOPSIS

  # this class used internally by:
  use JSON::Transform::Parser qw(parse);
  my $parsed = parse($source);

=head1 DESCRIPTION

Subclass of L<Pegex::Receiver> to turn Pegex parsing events into data
usable by JSON::Transform.

=cut

method gotrule (Any $param = undef) {
  return unless defined $param;
  if ($KINDHASH21{$self->{parser}{rule}}) {
    return {kind => $self->{parser}{rule}, %{$self->_locate_hash(_merge_hash($param))}};
  } elsif ($KINDFIELDS21{$self->{parser}{rule}}) {
    return {kind => $self->{parser}{rule}, %{$self->_locate_hash(_merge_hash($param, 'fields'))}};
  }
  return {$self->{parser}{rule} => $param};
}

method _locate_hash(HashRef $hash) {
  my ($line, $column) = @{$self->{parser}->line_column($self->{parser}{farthest})};
  +{ %$hash, location => { line => $line, column => $column } };
}

fun _merge_hash (Any $param = undef, Any $arraykey = undef) {
  my %def = map %$_, grep ref eq 'HASH', @$param;
  if ($arraykey) {
    my @arrays = grep ref eq 'ARRAY', @$param;
    Carp::confess "More than one array found\n" if @arrays > 1;
    Carp::confess "No arrays found but \$arraykey given\n" if !@arrays;
    my %fields = map %$_, @{$arrays[0]};
    $def{$arraykey} = \%fields;
  }
  \%def;
}

method got_opArrayFrom (Any $param = undef) {
  return unless defined $param;
  return { sourceType => 'array' };
}

method got_opObjectFrom (Any $param = undef) {
  return unless defined $param;
  return { sourceType => 'object' };
}

method got_exprArrayMapping (Any $param = undef) {
  return unless defined $param;
  return { destType => 'array', %$param };
}

method got_exprObjectMapping (Any $param = undef) {
  return unless defined $param;
  return { destType => 'object', %$param };
}

method got_colonPair (Any $param = undef) {
  return unless defined $param;
  my ($key, $value) = @$param;
  return { key => $key, value => $value };
}

method got_jsonPointer (Any $param = undef) {
  return unless defined $param;
  return { locationType => 'jsonpointer', value => $param };
}

method got_variableUser (Any $param = undef) {
  return unless defined $param;
  return { locationType => 'uservariable', name => $param };
}

method got_variableSystem (Any $param = undef) {
  return unless defined $param;
  return { locationType => 'systemvariable', name => $param };
}

method got_arguments (Any $param = undef) {
  return unless defined $param;
  my %args = map { ($_->[0]{name} => $_->[1]) } @$param;
  return {$self->{parser}{rule} => \%args};
}

method got_argument (Any $param = undef) {
  return unless defined $param;
  $param;
}

method got_objectField (Any $param = undef) {
  return unless defined $param;
  return {$param->[0]{name} => $param->[1]};
}

method got_objectValue (Any $param = undef) {
  return unless defined $param;
  _merge_hash($param);
}

method got_objectField_const (Any $param = undef) {
  unshift @_, $self; goto &got_objectField;
}

method got_objectValue_const (Any $param = undef) {
  unshift @_, $self; goto &got_objectValue;
}

method got_listValue (Any $param = undef) {
  return unless defined $param;
  return $param;
}

method got_listValue_const (Any $param = undef) {
  unshift @_, $self; goto &got_listValue;
}

method got_directiveactual (Any $param = undef) {
  return unless defined $param;
  _merge_hash($param);
}

method got_inputValueDefinition (Any $param = undef) {
  return unless defined $param;
  my $def = _merge_hash($param);
  my $name = delete $def->{name};
  return { $name => $def };
}

method got_directiveLocations (Any $param = undef) {
  return unless defined $param;
  return {locations => [ map $_->{name}, @$param ]};
}

method got_namedType (Any $param = undef) {
  return unless defined $param;
  return $param->{name};
}

method got_enumValueDefinition (Any $param = undef) {
  return unless defined $param;
  my @copy = @$param;
  my $rest = pop @copy;
  my $value = pop @copy;
  my $description = $copy[0] // {};
  $rest = ref $rest eq 'HASH' ? [ $rest ] : $rest;
  my %def = (%$description, value => $value, map %$_, @$rest);
  return \%def;
}

method got_defaultValue (Any $param = undef) {
  # the value can be undef
  return { default_value => $param };
}

method got_implementsInterfaces (Any $param = undef) {
  return unless defined $param;
  return { interfaces => $param };
}

method got_argumentsDefinition (Any $param = undef) {
  return unless defined $param;
  return { args => _merge_hash($param) };
}

method got_fieldDefinition (Any $param = undef) {
  return unless defined $param;
  my $def = _merge_hash($param);
  my $name = delete $def->{name};
  return { $name => $def };
}

method got_typeExtensionDefinition (Any $param = undef) {
  return unless defined $param;
  return {kind => 'extend', %{$self->_locate_hash($param)}};
}

method got_enumTypeDefinition (Any $param = undef) {
  return unless defined $param;
  my $def = _merge_hash($param);
  my %values;
  map {
    my $name = ${${delete $_->{value}}};
    $values{$name} = $_;
  } @{(grep ref eq 'ARRAY', @$param)[0]};
  $def->{values} = \%values;
  return {kind => 'enum', %{$self->_locate_hash($def)}};
}

method got_unionMembers (Any $param = undef) {
  return unless defined $param;
  return { types => $param };
}

method got_boolean (Any $param = undef) {
  return unless defined $param;
  return $param eq 'true' ? JSON->true : JSON->false;
}

method got_null (Any $param = undef) {
  return unless defined $param;
  return undef;
}

method got_string (Any $param = undef) {
  return unless defined $param;
  return $param;
}

method got_int (Any $param = undef) {
  $param+0;
}

method got_float (Any $param = undef) {
  $param+0;
}

method got_enumValue (Any $param = undef) {
  return unless defined $param;
  my $varname = $param->{name};
  return \\$varname;
}

# not returning empty list if undef
method got_value_const (Any $param = undef) {
  return $param;
}

method got_value (Any $param = undef) {
  unshift @_, $self; goto &got_value_const;
}

method got_variableDefinitions (Any $param = undef) {
  return unless defined $param;
  my %def;
  map {
    my $name = ${ shift @$_ };
    $def{$name} = { map %$_, @$_ }; # merge
  } @$param;
  return {variables => \%def};
}

method got_variableDefinition (Any $param = undef) {
  return unless defined $param;
  return $param;
}

method got_selection (Any $param = undef) {
  unshift @_, $self; goto &got_value_const;
}

method got_typedef (Any $param = undef) {
  return unless defined $param;
  $param = $param->{name} if ref($param) eq 'HASH';
  return {type => $param};
}

method got_alias (Any $param = undef) {
  return unless defined $param;
  return {$self->{parser}{rule} => $param->{name}};
}

method got_typeCondition (Any $param = undef) {
  return unless defined $param;
  return {on => $param};
}

method got_fragmentName (Any $param = undef) {
  return unless defined $param;
  return $param;
}

method got_selectionSet (Any $param = undef) {
  return unless defined $param;
  return {selections => $param};
}

method got_operationDefinition (Any $param = undef) {
  return unless defined $param;
  $param = [ $param ] unless ref $param eq 'ARRAY'; # bare selectionSet
  return {kind => 'operation', %{$self->_locate_hash(_merge_hash($param))}};
}

method got_directives (Any $param = undef) {
  return unless defined $param;
  return {$self->{parser}{rule} => $param};
}

method got_graphql (Any $param = undef) {
  return unless defined $param;
  return $param;
}

method got_definition (Any $param = undef) {
  return unless defined $param;
  return $param;
}

method got_operationTypeDefinition (Any $param = undef) {
  return unless defined $param;
  return { map { ref($_) ? values %$_ : $_ } @$param };
}

method got_comment (Any $param = undef) {
  return unless defined $param;
  return $param;
}

method got_description (Any $param = undef) {
  return unless defined $param;
  my $string = join "\n", @$param;
  return $string ? {$self->{parser}{rule} => $string} : {};
}

method got_schema (Any $param = undef) {
  return unless defined $param;
  my %type2count;
  $type2count{(keys %$_)[0]}++ for @{$param->[0]};
  $type2count{$_} > 1 and die "Must provide only one $_ type in schema.\n"
    for keys %type2count;
  return {kind => $self->{parser}{rule}, %{$self->_locate_hash(_merge_hash($param->[0]))}};
}

method got_typeSystemDefinition (Any $param = undef) {
  return unless defined $param;
  my @copy = @$param;
  my $node = pop @copy;
  my $description = $copy[0] // {};
  +{ %$node, %$description };
}

method got_typeDefinition (Any $param = undef) {
  return unless defined $param;
  return $param;
}

method got_variable (Any $param = undef) {
  return unless defined $param;
  my $varname = $param->{name};
  return \$varname;
}

method got_nonNullType (Any $param = undef) {
  return unless defined $param;
  $param = $param->[0]; # zap first useless layer
  $param = { type => $param } if ref $param ne 'HASH';
  return [ 'non_null', $param ];
}

method got_listType (Any $param = undef) {
  return unless defined $param;
  $param = $param->[0]; # zap first useless layer
  $param = { type => $param } if ref $param ne 'HASH';
  return [ 'list', $param ];
}

1;
