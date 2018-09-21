use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME             => 'JSON::Transform',
  AUTHOR           => q{Ed J <etj@cpan.org>},
  VERSION_FROM     => 'lib/JSON/Transform.pm',
  ABSTRACT_FROM    => 'lib/JSON/Transform.pm',
  LICENSE          => 'artistic_2',
  MIN_PERL_VERSION => '5.014', # Function::Parameters
  CONFIGURE_REQUIRES => {
    'ExtUtils::MakeMaker' => '6.64', # TEST_REQUIRES
  },
  TEST_REQUIRES => {
    'Test::More' => '0.88', # done_testing
    'Test::Exception' => '0.42',
    'Test::Deep' => '1.127',
    'Import::Into' => '0',
  },
  PREREQ_PM => {
    'Moo' => '0',
    'Type::Tiny' => '0',
    'Module::Runtime' => '0',
    'Function::Parameters' => '2.001001',
    'Return::Type' => '0',
    'Pegex' => '0.64',
    'MooX::Thunking' => '0.07', # takes care of Thunk in isa
    'JSON::MaybeXS' => '1.003009', # is_bool, also . @INC
    'JSON::PP' => '2.92', # number detection
  },
  dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
  clean => { FILES => 'JSON-Transform-*' },
  META_MERGE => {
    "meta-spec" => { version => 2 },
    dynamic_config => 0,
    resources => {
      x_IRC => 'irc://irc.perl.org/#graphql-perl',
      repository => {
        type => 'git',
        url => 'git@github.com:mohawk2/json-transform.git',
        web => 'https://github.com/mohawk2/json-transform',
      },
      bugtracker  => {
        web => 'https://github.com/mohawk2/json-transform/issues',
      },
      license => [ 'http://dev.perl.org/licenses/' ],
    },
    prereqs => {
      develop => {
        requires => {
          'Test::CheckManifest' => '0.9',
          'Test::Pod::Coverage' => '1.08',
          'Test::Pod' => '1.22',
          'Pod::Markdown' => 0,
        },
      },
      runtime => {
        suggests => {
          'Cpanel::JSON::XS' => '3.0237',
          'JSON::XS' => 0,
        },
      },
    },
  },
);

sub MY::postamble {
  my $container = 'graphqlperl/graphql';
  my $prereq = "${container}-prereq";
  <<EOF;
lib/JSON/Transform/Grammar.pm : json-transform.pgx
\t\$(PERL) -Ilib -MJSON::Transform::Grammar=compile

pure_all :: README.md

README.md : \$(VERSION_FROM)
\tpod2markdown \$< >\$\@

containerprereq :
\tdocker build -f Dockerfile.prereq -t $prereq .

containerprereqpush :
\tdocker push $prereq

container :
\tdocker build -t $container:\$(VERSION) .

containerpush :
\tdocker push $container:\$(VERSION)
EOF
}
