use Test;
#use strict;
#use warnings;

BEGIN { plan tests => 206 };

use Math::Trig::Units qw(dsin dcos tan sec csc cot asin acos atan asec acsc acot sinh cosh tanh sech csch coth asinh acosh atanh asech acsch acoth approx);

ok(1);

my $pi = 3.1415926535897932384626433832795028841971693993751058209;

# degrees
test_to_from( 0, 30, 45, 60, 90 );

# gradians
Math::Trig::Units::units('gradians');
test_to_from( 0, 25, 50, 75, 100 );

# radians
Math::Trig::Units::units('radians');
test_to_from( 0, $pi/8, $pi/6, $pi/4, $pi/2 );

# test approx function
Math::Trig::Units::units('degrees');
ok(approx(dsin(30)), 0.5);
ok(approx(dcos(60)), 0.5);
ok(approx(0.250000001), 0.25);
ok(approx(0.25000001), 0.25000001);
ok(approx(0.249999991), 0.25);
ok(approx(0.25999991), 0.25999991);
ok(approx(0.2500001, 4), 0.25);
ok(approx(0.250001, 4), 0.250001);
ok(approx(0.2499991, 4), 0.25);
ok(approx(0.259991, 4), 0.259991);


sub test_to_from {
    my @range = @_;
    for my $x ( @range ) {
        ok( r2dp(asin(dsin($x))), r2dp($x) );
        ok( r2dp(acos(dcos($x))), r2dp($x) );
        ok( r2dp(atan(tan($x))), r2dp($x) );
        ok( r2dp(asec(sec($x))), r2dp($x) );
        ok( r2dp(acsc(csc($x))), r2dp($x) );
        ok( r2dp(acot(cot($x))), r2dp($x) );
        ok( r2dp(asinh(sinh($x))), r2dp($x) );
        ok( r2dp(acosh(cosh($x))), r2dp($x) );
        ok( r2dp(atanh(tanh($x))), r2dp($x) );
        ok( r2dp(asech(sech($x))), r2dp($x) );
        ok( r2dp(acsch(csch($x))), r2dp($x) );
        ok( r2dp(acoth(coth($x))), r2dp($x) );
        ok( r2dp(Math::Trig::Units::rad_to_units(Math::Trig::Units::units_to_rad($x))), r2dp($x) );
    }
}

# remove last 2 decimal places to avoid abberant test failures due to
# the inherrent inaccuracy of floating point math on a computer.
sub r2dp {
    my $num = shift;
    chop $num;
    chop $num;
  return $num;
}

