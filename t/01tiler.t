#
#	GD::Tiler test script
#
use vars qw($tests $loaded);
BEGIN {
	push @INC, './t';
	$tests = 32;

	print STDERR "
 *** Note: test result images can be viewed via the
 *** opening the generated results.html file in a web browser.
 ";
	$^W= 1;
	$| = 1;
	print "1..$tests\n";
}

END {print "not ok 1\n" unless $loaded;}

#
#	tests:
#	1. load OK
#	2. Tile single image, computed coords, not centered, default background, no margins
#	3. Tile single image, computed coords, centered, default background, edge margin
#	4. Tile single image, computed coords, centered, named background, vert edge only
#	5. Tile single image, computed coords, centered, hex background, horiz edge only
#	6. Tile single image, computed coords, centered, hex background, tile margin
#	7. Tile single image, computed coords, centered, named background, vert tile only
#	8. Tile single image, computed coords, centered, hex background, horiz tile only
#	9. Tile single image, computed coords, centered, named background, edge and tile margin
#	10. Tile single image, explicit coords, proper width/height
#	11. Tile single image, explicit coords, bad width/height
#	12. Tile single image as filename, explicit coords, bad width/height

#	12. Tile 2 identical images, computed coords, not centered, hex background, edge and tile margin
#	13. Tile 3 identical images, computed coords, not centered, hex background, edge and tile margin
#	14. Tile 4 identical images, computed coords, not centered, hex background, edge and tile margin
#	15. Tile 5 identical images, computed coords, not centered, hex background, edge and tile margin
#	16. Tile 6 identical images, computed coords, not centered, hex background, edge and tile margin
#	17. Tile 7 identical images, computed coords, not centered, hex background, edge and tile margin
#	18. Tile 8 identical images, computed coords, not centered, hex background, edge and tile margin
#	19. Tile 9 identical images, computed coords, not centered, hex background, edge and tile margin
#	20. Tile 10 identical images, computed coords, not centered, hex background, edge and tile margin

#	21. Tile 2 different images, computed coords, not centered, hex background, edge and tile margin
#	22. Tile 3 different images, computed coords, not centered, hex background, edge and tile margin
#	23. Tile 4 different images, computed coords, not centered, hex background, edge and tile margin
#	24. Tile 5 different images, computed coords, centered, hex background, edge and tile margin
#	25. Tile 6 different images, computed coords, centered, hex background, edge and tile margin
#	26. Tile 7 different images, computed coords, centered, hex background, edge and tile margin
#	27. Tile 8 different images, computed coords, centered, hex background, edge and tile margin
#	28. Tile 9 different images, computed coords, centered, hex background, edge and tile margin
#	29. Tile 10 different images, computed coords, centered, hex background, edge and tile margin

#	30. Tile  2 identical images, explicit coords
#	31. Tile 10 different images, explicit coords
#

use strict;
use warnings;

use GD::Tiler;

my $testno = 1;

my @imgfiles = ('t/imgs/smallimg.png', 't/imgs/mediumimg.png', 't/imgs/bigimg.png');
#
#	if standalone, add any path prefix
@imgfiles = map "$ARGV[0]/$_", @imgfiles
	if $ARGV[0];

my @images = ();
push @images, GD::Image->newFromPng($_)
	foreach (@imgfiles);

srand(time());

sub report_result {
	my ($result, $testmsg, $okmsg, $notokmsg) = @_;

	if ($result) {

		$okmsg = '' unless $okmsg;
		print STDOUT (($result eq 'skip') ?
			"ok $testno # skip $testmsg\n" :
			"ok $testno # $testmsg $okmsg\n");
	}
	else {
		$notokmsg = '' unless $notokmsg;
		print STDOUT
			"not ok $testno # $testmsg $notokmsg\n";
	}
	$testno++;
}

#
#	prelims: use shared test count for eventual
#	threaded tests
#
$loaded = 1;
report_result(1, 'load');
#	2. Tile single image, computed coords, not centered, default background, no margins

my $img = GD::Tiler->tile(Images => [ $images[0] ]);
saveimg($testno, $img);
report_result(defined $img, 'Tile single image, computed coords, not centered, default background, no margins');

#	3. Tile single image, computed coords, centered, default background, edge margin
$img = GD::Tiler->tile(Images => [ $images[0] ], Center => 1, EdgeMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile single image, computed coords, centered, default background, edge margin');

#	4. Tile single image, computed coords, centered, named background, vert edge only
$img = GD::Tiler->tile(Images => [ $images[0] ], Center => 1, Background => 'lorange', VEdgeMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile single image, computed coords, centered, named background, vert edge only');

#	5. Tile single image, computed coords, centered, hex background, horiz edge only
$img = GD::Tiler->tile(Images => [ $images[0] ], Center => 1, Background => '#FF00DEADBEEF', HEdgeMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile single image, computed coords, centered, hex background, horiz edge only');

#	6. Tile single image, computed coords, centered, hex background, tile margin
$img = GD::Tiler->tile(Images => [ $images[0] ], Center => 1, Background => '#FF00DEADBEEF', TileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile single image, computed coords, centered, hex background, tile margin');

#	7. Tile single image, computed coords, centered, named background, vert tile only
$img = GD::Tiler->tile(Images => [ $images[0] ], Center => 1, Background => 'white', VTileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile single image, computed coords, centered, named background, vert tile only');

#	8. Tile single image, computed coords, centered, hex background, horiz tile only
$img = GD::Tiler->tile(Images => [ $images[0] ], Center => 1, Background => '#0000FFFFFFFF', HTileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile single image, computed coords, centered, hex background, horiz tile only');

#	9. Tile single image, computed coords, centered, named background, edge and tile margin
$img = GD::Tiler->tile(Images => [ $images[0] ], Center => 1, Background => 'green', EdgeMargin => 7, TileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile single image, computed coords, centered, named background, edge and tile margin');

#	9. Tile single image, computed coords, bad width/height, centered, named background, edge and tile margin
eval {
$img = GD::Tiler->tile(
	Images => [ $images[0] ],
	Width => 12,
	Height => 5,
	Center => 1,
	Background => 'green',
	EdgeMargin => 7,
	TileMargin => 10);
};
report_result($@, 'Tile single image, computed coords, bad width/height, centered, named background, edge and tile margin');

#	10. Tile single image, explicit coords
$img = GD::Tiler->tile(Images => [ $images[0] ], Coordinates => [ 10, 10 ], Width => 50, Height => 75);
saveimg($testno, $img);
report_result(defined $img, 'Tile single image, explicit coords');

#	11. Tile single image as filename, explicit coords
$img = GD::Tiler->tile(Images => [ $imgfiles[0] ], Coordinates => [ 10, 10 ], Width => 50, Height => 75);
saveimg($testno, $img);
report_result(defined $img, 'Tile single image as filename, explicit coords');

#	12. Tile 2 identical images, computed coords, not centered, hex background, edge and tile margin
$img = GD::Tiler->tile(Images => [ $images[0], $images[0] ], Background => '#800080008000', EdgeMargin => 7, TileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile 2 identical images, computed coords, not centered, hex background, edge and tile margin');

#	13. Tile 3 identical images, computed coords, not centered, hex background, edge and tile margin
$img = GD::Tiler->tile(Images => [ $images[0], $images[0], $images[0] ], Background => '#800080008000', EdgeMargin => 7, TileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile 3 identical images, computed coords, not centered, hex background, edge and tile margin');

#	14. Tile 4 identical images, computed coords, not centered, hex background, edge and tile margin
$img = GD::Tiler->tile(Images => [ $images[0], $images[0], $images[0], $images[0] ],
	Background => '#800080008000', EdgeMargin => 7, TileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile 4 identical images, computed coords, not centered, hex background, edge and tile margin');

#	15. Tile 5 identical images, computed coords, not centered, hex background, edge and tile margin
$img = GD::Tiler->tile(Images => [ $images[0], $images[0], $images[0], $images[0], $images[0] ],
	Background => '#800080008000', EdgeMargin => 7, TileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile 5 identical images, computed coords, not centered, hex background, edge and tile margin');

#	16. Tile 6 identical images, computed coords, not centered, hex background, edge and tile margin
$img = GD::Tiler->tile(Images => [ $images[0], $images[0], $images[0], $images[0], $images[0], $images[0] ],
	Background => '#FFFFFFFFFFFF', EdgeMargin => 7, TileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile 6 identical images, computed coords, not centered, hex background, edge and tile margin');

#	17. Tile 7 identical images, computed coords, not centered, hex background, edge and tile margin
$img = GD::Tiler->tile(Images => [ $images[0], $images[0], $images[0], $images[0], $images[0], $images[0], $images[0] ],
	Background => '#FFFFFFFFFFFF', EdgeMargin => 7, TileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile 7 identical images, computed coords, not centered, hex background, edge and tile margin');

#	18. Tile 8 identical images, computed coords, not centered, hex background, edge and tile margin
$img = GD::Tiler->tile(Images => [ $images[0], $images[0], $images[0] , $images[0] , $images[0] , $images[0] , $images[0] , $images[0]  ],
	Background => '#FFFFFFFFFFFF', EdgeMargin => 7, TileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile 8 identical images, computed coords, not centered, hex background, edge and tile margin');

#	19. Tile 9 identical images, computed coords, not centered, hex background, edge and tile margin
$img = GD::Tiler->tile(Images => [ $images[0], $images[0], $images[0], $images[0], $images[0], $images[0], $images[0], $images[0], $images[0] ],
	Background => '#FFFFFFFFFFFF', EdgeMargin => 7, TileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile 9 identical images, computed coords, not centered, hex background, edge and tile margin');

#	20. Tile 10 identical images, computed coords, not centered, hex background, edge and tile margin
$img = GD::Tiler->tile(Images => [ $images[0], $images[0], $images[0], $images[0], $images[0], $images[0], $images[0], $images[0], $images[0], $images[0] ],
	Background => '#FFFFFFFFFFFF', EdgeMargin => 7, TileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile 10 identical images, computed coords, not centered, hex background, edge and tile margin');


#	21. Tile 2 different images, computed coords, not centered, hex background, edge and tile margin
$img = GD::Tiler->tile(Images => [ $images[0], $images[1] ], Background => '#FFFFFFFFFFFF', EdgeMargin => 7, TileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile 2 different images, computed coords, not centered, hex background, edge and tile margin');

#	22. Tile 3 different images, computed coords, not centered, hex background, edge and tile margin
$img = GD::Tiler->tile(Images => [ @images ], Background => '#FFFFFFFFFFFF', EdgeMargin => 7, TileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile 3 different images, computed coords, not centered, hex background, edge and tile margin');

#	23. Tile 4 different images, computed coords, not centered, hex background, edge and tile margin
$img = GD::Tiler->tile(Images => [ random_images(4) ], Background => '#800080008000', EdgeMargin => 7, TileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile 4 different images, computed coords, not centered, hex background, edge and tile margin');

#	24. Tile 5 different images, computed coords, centered, hex background, edge and tile margin
$img = GD::Tiler->tile(Images => [ random_images(5) ], Background => '#800080008000', EdgeMargin => 7, TileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile 5 different images, computed coords, not centered, hex background, edge and tile margin');

#	25. Tile 6 different images, computed coords, centered, hex background, edge and tile margin
$img = GD::Tiler->tile(Images => [ random_images(6) ], Background => '#800080008000', EdgeMargin => 7, TileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile 6 different images, computed coords, not centered, hex background, edge and tile margin');

#	26. Tile 7 different images, computed coords, centered, hex background, edge and tile margin
$img = GD::Tiler->tile(Images => [ random_images(7) ], Background => '#800080008000', EdgeMargin => 7, TileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile 7 different images, computed coords, not centered, hex background, edge and tile margin');

#	27. Tile 8 different images, computed coords, centered, hex background, edge and tile margin
$img = GD::Tiler->tile(Images => [ random_images(8) ], Background => '#800080008000', EdgeMargin => 7, TileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile 8 different images, computed coords, not centered, hex background, edge and tile margin');

#	28. Tile 9 different images, computed coords, centered, hex background, edge and tile margin
$img = GD::Tiler->tile(Images => [ random_images(9) ], Background => '#800080008000', EdgeMargin => 7, TileMargin => 10);
saveimg($testno, $img);
report_result(defined $img, 'Tile 9 different images, computed coords, not centered, hex background, edge and tile margin');

#	29. Tile 10 different images, array context, computed coords, centered, hex background, edge and tile margin
my @coords;
($img, @coords) = GD::Tiler->tile(Images => [ random_images(10) ], Background => '#800080008000', EdgeMargin => 7, TileMargin => 10);
saveimg($testno, $img);
report_result(defined $img && (scalar @coords == 20),
	'Tile 10 different images, array context, computed coords, not centered, hex background, edge and tile margin');

#	30. Tile  2 identical images, explicit coords
$img = GD::Tiler->tile(Images => [ $images[0], $images[0] ], Coordinates => [ 10, 10, 50, 50 ], Width => 100, Height => 100);
saveimg($testno, $img);
report_result(defined $img, 'Tile 2 identical images, explicit coords');

#	31. Tile 10 different images, explicit coords
$img = GD::Tiler->tile(Images => [ random_images(10) ],
	Coordinates => [
		10, 10, 10, 50, 10, 100,
		100, 10, 100, 50, 100, 100,
		350, 10, 350, 50, 350, 100,
		450, 50
	],
	Width => 400, Height => 700);
saveimg($testno, $img);
report_result(defined $img, 'Tile 10 different images, explicit coords');

open OUTF, '>results.html';
print OUTF <<'HTML';

<html>
<body>
<img src='result2.png'><p>
<img src='result3.png'><p>
<img src='result4.png'><p>
<img src='result5.png'><p>
<img src='result6.png'><p>
<img src='result7.png'><p>
<img src='result8.png'><p>
<img src='result9.png'><p>
<img src='result11.png'><p>
<img src='result12.png'><p>
<img src='result13.png'><p>
<img src='result14.png'><p>
<img src='result15.png'><p>
<img src='result16.png'><p>
<img src='result17.png'><p>
<img src='result18.png'><p>
<img src='result19.png'><p>
<img src='result20.png'><p>
<img src='result21.png'><p>
<img src='result22.png'><p>
<img src='result23.png'><p>
<img src='result24.png'><p>
<img src='result25.png'><p>
<img src='result26.png'><p>
<img src='result27.png'><p>
<img src='result28.png'><p>
<img src='result29.png'><p>
<img src='result30.png'><p>
<img src='result31.png'><p>
<img src='result32.png'><p>
</body>
</html>

HTML

close OUTF;

sub saveimg {
	open OUTF, ">result$_[0].png";
	binmode OUTF;
	print OUTF $_[1];
	close OUTF;
}

sub random_images {
	my $count = shift;
	my @rnd_images = ();

	push @rnd_images, $images[int(rand() * 3)]
		foreach (1..$count);
	return @rnd_images;
}

