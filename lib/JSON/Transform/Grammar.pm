package JSON::Transform::Grammar;

use 5.014;
use strict;
use warnings;
use base 'Pegex::Grammar';
use constant file => './json-transform.pgx';

=head1 NAME

JSON::Transform::Grammar - JSON::Transform grammar

=head1 SYNOPSIS

  use Pegex::Parser;
  use JSON::Transform::Grammar;
  use Pegex::Tree::Wrap;
  use Pegex::Input;

  my $parser = Pegex::Parser->new(
    grammar => JSON::Transform::Grammar->new,
    receiver => Pegex::Tree::Wrap->new,
  );
  my $text = '"" <% [ $V+`id`:$K ]';
  my $input = Pegex::Input->new(string => $text);
  my $got = $parser->parse($input);

=head1 DESCRIPTION

This is a subclass of L<Pegex::Grammar>, with the JSON::Transform grammar.

=head1 METHODS

=head2 make_tree

Override method from L<Pegex::Grammar>.

=cut

sub make_tree {   # Generated/Inlined by Pegex::Grammar (0.67)
  {
    '+grammar' => 'json-transform',
    '+include' => 'pegex-atoms',
    '+toprule' => 'transforms',
    '+version' => '0.01',
    'colonPair' => {
      '.all' => [
        {
          '.ref' => 'exprStringValue'
        },
        {
          '-skip' => 1,
          '.rgx' => qr/\G(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*:(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*/u
        },
        {
          '.ref' => 'exprSingleValue'
        }
      ]
    },
    'exprArrayMapping' => {
      '.all' => [
        {
          '-skip' => 1,
          '.rgx' => qr/\G(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*\[(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*/u
        },
        {
          '-flat' => 1,
          '.ref' => 'exprSingleValue'
        },
        {
          '-skip' => 1,
          '.rgx' => qr/\G(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*\](?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*/u
        }
      ]
    },
    'exprKeyAdd' => {
      '.all' => [
        {
          '-skip' => 1,
          '.rgx' => qr/\G(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*\+(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*/u
        },
        {
          '-flat' => 1,
          '.ref' => 'colonPair'
        }
      ]
    },
    'exprKeyRemove' => {
      '.all' => [
        {
          '-skip' => 1,
          '.rgx' => qr/\G(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*\-(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*/u
        },
        {
          '-flat' => 1,
          '.ref' => 'exprStringValue'
        }
      ]
    },
    'exprMapping' => {
      '.all' => [
        {
          '-wrap' => 1,
          '.ref' => 'opFrom'
        },
        {
          '.any' => [
            {
              '.ref' => 'exprArrayMapping'
            },
            {
              '.ref' => 'exprObjectMapping'
            }
          ]
        }
      ]
    },
    'exprObjectMapping' => {
      '.all' => [
        {
          '-skip' => 1,
          '.rgx' => qr/\G(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*\{(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*/u
        },
        {
          '-flat' => 1,
          '.ref' => 'colonPair'
        },
        {
          '-skip' => 1,
          '.rgx' => qr/\G(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*\}(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*/u
        }
      ]
    },
    'exprSingleValue' => {
      '.all' => [
        {
          '.any' => [
            {
              '.ref' => 'jsonPointer'
            },
            {
              '.ref' => 'variableUser'
            },
            {
              '.ref' => 'variableSystem'
            }
          ]
        },
        {
          '+max' => 1,
          '-flat' => 1,
          '.ref' => 'singleValueMod'
        }
      ]
    },
    'exprStringQuoted' => {
      '.rgx' => qr/\G`((?:\\(?:[`\\\/\$bfnrt]|u[0-9a-fA-F]{4})|[^`\x00-\x1f\\])*)`/
    },
    'exprStringValue' => {
      '.any' => [
        {
          '.ref' => 'jsonPointer'
        },
        {
          '.ref' => 'variableUser'
        },
        {
          '.ref' => 'variableSystem'
        },
        {
          '.ref' => 'exprStringQuoted'
        }
      ]
    },
    'jsonPointer' => {
      '.rgx' => qr/\G"((?:\\(?:["\\\/\$bfnrt]|u[0-9a-fA-F]{4})|[^"\x00-\x1f\\])*)"/
    },
    'opArrayFrom' => {
      '.rgx' => qr/\G(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*(<\@)(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*/u
    },
    'opCopyFrom' => {
      '.rgx' => qr/\G(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*(<\-)(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*/u
    },
    'opFrom' => {
      '.any' => [
        {
          '.ref' => 'opArrayFrom'
        },
        {
          '.ref' => 'opObjectFrom'
        }
      ]
    },
    'opMoveFrom' => {
      '.rgx' => qr/\G(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*(<<)(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*/u
    },
    'opObjectFrom' => {
      '.rgx' => qr/\G(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*(<%)(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*/u
    },
    'singleValueMod' => {
      '.any' => [
        {
          '.ref' => 'exprKeyAdd'
        },
        {
          '.ref' => 'exprKeyRemove'
        }
      ]
    },
    'transformCopy' => {
      '.all' => [
        {
          '.any' => [
            {
              '.ref' => 'jsonPointer'
            },
            {
              '.ref' => 'variableUser'
            }
          ]
        },
        {
          '-skip' => 1,
          '.ref' => 'opCopyFrom'
        },
        {
          '-flat' => 1,
          '.ref' => 'exprSingleValue'
        },
        {
          '+max' => 1,
          '.ref' => 'exprMapping'
        }
      ]
    },
    'transformImpliedDest' => {
      '.all' => [
        {
          '.ref' => 'jsonPointer'
        },
        {
          '.ref' => 'exprMapping'
        }
      ]
    },
    'transformMove' => {
      '.all' => [
        {
          '.ref' => 'jsonPointer'
        },
        {
          '-skip' => 1,
          '.ref' => 'opMoveFrom'
        },
        {
          '.ref' => 'jsonPointer'
        }
      ]
    },
    'transformation' => {
      '.all' => [
        {
          '-skip' => 1,
          '.rgx' => qr/\G(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*/u
        },
        {
          '.any' => [
            {
              '.ref' => 'transformImpliedDest'
            },
            {
              '.ref' => 'transformCopy'
            },
            {
              '.ref' => 'transformMove'
            },
            {
              '-skip' => 1,
              '.ref' => 'ws2'
            }
          ]
        },
        {
          '-skip' => 1,
          '.rgx' => qr/\G(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*/u
        }
      ]
    },
    'transforms' => {
      '+min' => 1,
      '-flat' => 1,
      '.ref' => 'transformation'
    },
    'variableSystem' => {
      '.all' => [
        {
          '-skip' => 1,
          '.rgx' => qr/\G(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*\$/u
        },
        {
          '.rgx' => qr/\G([A-Z]*)/
        }
      ]
    },
    'variableUser' => {
      '.all' => [
        {
          '-skip' => 1,
          '.rgx' => qr/\G(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))*\$/u
        },
        {
          '.rgx' => qr/\G([a-z][a-zA-Z]*)/
        }
      ]
    },
    'ws2' => {
      '.rgx' => qr/\G(?:\s|\x{FEFF}|[\ \t]*\#[\ \t]*[^\r\n]*(?:\r?\n|\r!NL|\z))+/u
    }
  }
}

1;
