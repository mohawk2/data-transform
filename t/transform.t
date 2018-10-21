use lib 't/lib';
use JTTest;
use JSON::Transform qw(parse_transform);

my @OPS = (
  [
    'array to hashes',
    '"" <@ { "/$K/id":$V-`id` }',
    [{id=>'a', k=>'va'}, {id=>'b', k=>'vb'}],
    { a => {k=>'va'}, b => {k=>'vb'} },
  ],
);

for (@OPS) {
  my ($desc, $transform, $in, $expect) = @$_;
  is_deeply parse_transform($transform)->($in), $expect, $desc;
}

if (0) {
is_deeply_snapshot parse(<<'EOF'), 'hashes to array';
  "" <% [ $V+`id`:$K ]
EOF

is_deeply_snapshot parse(<<'EOF'), 'array identity non-implicit';
  "" <- "" <@ [ $V ]
EOF

is_deeply_snapshot parse(<<'EOF'), 'array identity';
  "" <@ [ $V ]
EOF

is_deeply_snapshot parse(<<'EOF'), 'hash identity';
  "" <% { $K:$V }
EOF

is_deeply_snapshot parse(<<'EOF'), 'hash move';
  "/destination" << "/source"
EOF

is_deeply_snapshot parse(<<'EOF'), 'hash copy';
  "/destination" <- "/source"
EOF

is_deeply_snapshot parse(<<'EOF'), 'hash copy with transform';
  "/destination" <- "/source" <@ [ $V+`order`:$K ]
EOF

is_deeply_snapshot parse(<<'EOF'), 'variable bind then replace';
  $defs <- "/definitions"
  "" <- $defs
EOF

is_deeply_snapshot parse(<<'EOF'), 'array count';
  "" <@ $C
EOF

is_deeply_snapshot parse(<<'EOF'), 'hash count';
  "" <% $C
EOF

is_deeply_snapshot parse(<<'EOF'), 'hash keys';
  "" <% [ $K ]
EOF
}

done_testing;
