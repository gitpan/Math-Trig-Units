package Math::Trig::Units;

require Exporter;
use Carp;

use vars qw( @ISA @EXPORT_OK $VERSION $UNITS $ZERO $pi $inf );
$VERSION = '0.02';
@ISA=qw(Exporter);
@EXPORT_OK=qw(
    dsin    asin
    dcos    acos
    tan     atan
    sec     asec
    csc     acsc
    cot     acot
    sinh    asinh
    cosh    acosh
    tanh    atanh
    sech    asech
    csch    acsch
    coth    acoth
    deg_to_rad  rad_to_deg
    grad_to_rad rad_to_grad
    deg_to_grad grad_to_deg
    units
    zero
    approx
    );

BEGIN { $pi = 3.1415926535897932384626433832795028841971693993751058209;
        $inf = exp(1000000);
        $UNITS = 'degrees';
        $ZERO  = 1e12;
      }

sub deg_to_rad  { my $x=$_[0]; ($x/180) * $pi }
sub rad_to_deg  { my $x=$_[0]; ($x/$pi) * 180 }
sub grad_to_rad { my $x=$_[0]; ($x/200) * $pi }
sub rad_to_grad { my $x=$_[0]; ($x/$pi) * 200 }
sub deg_to_grad { my $x=$_[0]; $x/0.9 }
sub grad_to_deg { my $x=$_[0]; $x*0.9 }

sub units_to_rad {
  return $UNITS =~ /gradian/i  ? grad_to_rad($_[0]) :
         $UNITS =~ /radian/i ? $_[0] :
         deg_to_rad($_[0]);
}

sub rad_to_units {
  return $UNITS =~ /gradian/i  ? rad_to_grad($_[0]) :
         $UNITS =~ /radian/i   ? $_[0] :
         rad_to_deg($_[0]);
}

sub units {
   $UNITS = $_[0] if $_[0];
    confess( "Don't know how to do $_[0] units!") unless $UNITS =~ m/degree|gradian|radian/i;
  return $UNITS;
}

sub zero {
   $ZERO = $_[0] if $_[0];
   confess( "You need a bigger number like 10e10" ) unless $ZERO > 1e10;
  return $ZERO;
}

sub approx {
    my ( $num, $dp ) = @_;
    $dp ||= 6;
    if ( $num =~ m/\d*\.(\d*?)(9{$dp,})\d*/ ) {
        my $exp = 10** (length $1 + length $2);
      return int(($num * $exp) +1 )/$exp;

    }
    elsif ( $num =~ m/\d*\.(\d*?)(0{$dp,})\d*/ ) {
        my $exp = 10** (length $1 + length $2);
      return int($num * $exp)/$exp;
    }
    else {
        return $num;
    }
}

sub dsin { my $x=$_[0];  $x=units_to_rad($x); return  sin($x) }

sub dcos { my $x=$_[0];  $x=units_to_rad($x); return cos($x) }

sub tan { my $x=$_[0]; $x=units_to_rad($x); return int(cos($x)*$ZERO)==0 ? $inf : sin($x)/cos($x) }

sub sec { my $x=$_[0]; $x=units_to_rad($x); return int(cos($x)*$ZERO)==0 ? $inf : 1/cos($x) }

sub csc { my $x=$_[0]; $x=units_to_rad($x); return int(sin($x)*$ZERO)==0 ? $inf : 1/sin($x) }

sub cot { my $x=$_[0]; $x=units_to_rad($x); return int(sin($x)*$ZERO)==0 ? $inf : cos($x)/sin($x) }

sub asin { my $x=$_[0]; return ($x<-1 or $x>1) ? undef : rad_to_units( atan2($x,sqrt(1-$x*$x)) ); }

sub acos { my $x=$_[0]; return ($x<-1 or $x>1) ? undef : rad_to_units( atan2(sqrt(1-$x*$x),$x) ); }

sub atan {
  return ($_[0]==0) ? 0 :
         ($_[0]>0)  ? rad_to_units( atan2(sqrt(1+$_[0]*$_[0]),sqrt(1+1/($_[0]*$_[0]))) ) :
         rad_to_units($pi) - rad_to_units( atan2(sqrt(1+$_[0]*$_[0]),sqrt(1+1/($_[0]*$_[0]))) );
}

sub asec { return ( $_[0]==0 or ($_[0]>-1 and $_[0]<1) ) ? undef : acos(1/$_[0]); }

sub acsc { return ( $_[0]==0 or ($_[0]>-1 and $_[0]<1) ) ? undef : asin(1/$_[0]); }

sub acot { return ($_[0]==0) ? rad_to_units($pi/2) : atan(1/$_[0]) }

sub sinh { my $x=$_[0]; $x=units_to_rad($x); return (exp($x)-exp(-$x))/2; }

sub cosh { my $x=$_[0]; $x=units_to_rad($x); return (exp($x)+exp(-$x))/2; }

sub tanh {
    my($ep,$em) = (exp(units_to_rad($_[0])),exp(-units_to_rad($_[0])));
  return ($ep==$inf) ? 1  :
         ($em==$inf) ? -1 : ($ep-$em)/($ep+$em);
}

sub sech { my $x=$_[0]; $x=units_to_rad($x); return 2/(exp($x)+exp(-$x)); }

sub csch { my $x=$_[0]; $x=units_to_rad($x); return ($x==0) ? $inf : 2/(exp($x)-exp(-$x)); }

sub coth {
    my $x=units_to_rad($_[0]);
    my($ep,$em) = (exp($x),exp(-$x));
  return ($x==0) ? $inf :
         ($ep == $inf) ? 1 :
         ($em == $inf) ? -1 : (exp($x)+exp(-$x))/(exp($x)-exp(-$x));
}

sub asinh { return rad_to_units(log($_[0]+sqrt(1+$_[0]*$_[0]))); }

sub acosh { return ($_[0]<1) ? $inf : asinh(sqrt($_[0]*$_[0]-1)); }  # Returns positive value only!

sub atanh { return ( $_[0]<=-1 or $_[0]>=1) ? $inf : asinh($_[0]/sqrt(1-$_[0]*$_[0])); }

sub asech { return ( $_[0]<=0 or $_[0]>1 ) ? $inf : asinh(sqrt(1-$_[0]*$_[0])/$_[0]); }  # Returns positive value only!

sub acsch { return ( $_[0]==0 ) ? $inf : asinh(1/$_[0]); }

sub acoth {
  return ($_[0]>=-1 and $_[0]<=1) ? $inf :
         ($_[0]<-1) ? -asinh(1/sqrt($_[0]*$_[0]-1)) :
         asinh(1/sqrt($_[0]*$_[0]-1));
}

1;

__END__

=head1 NAME

    Math::Trig::Units - Inverse and hyperbolic trigonemetric Functions
                         in degrees, radians or gradians.

=head1 SYNOPSIS

    use Math::Trig::Units qw(dsin  dcos  tan   sec   csc   cot
                             asin  acos  atan  asec  acsc  acot
                             sinh  cosh  tanh  sech  csch  coth
                             asinh acosh atanh asech acsch acoth
                             deg_to_rad  rad_to_deg
                             grad_to_rad rad_to_grad
                             deg_to_grad grad_to_deg
                             units       zero        approx);
    $v = dsin($x);
    $v = dcos($x);
    $v = tan($x);
    $v = sec($x);
    $v = csc($x);
    $v = cot($x);
    $v = asin($x);
    $v = acos($x);
    $v = atan($x);
    $v = asec($x);
    $v = acsc($x);
    $v = acot($x);
    $v = sinh($x);
    $v = cosh($x);
    $v = tanh($x);
    $v = sech($x);
    $v = csch($x);
    $v = coth($x);
    $v = asinh($x);
    $v = acosh($x);
    $v = atanh($x);
    $v = asech($x);
    $v = acsch($x);
    $v = acoth($x);
    $degrees  = rad_to_deg($radians);
    $radians  = deg_to_rad($degrees);
    $degrees  = grad_to_deg($gradians);
    $gradians = deg_to_grad($degrees);
    $radians  = grad_to_rad($gradians);
    $gradians = rad_to_grad($radians);

    # set radians instead of degrees (default)
    Math::Trig::Units::units('radians');
    # set gradians as units
    Math::Trig::Units::units('gradians');
    # set degrees as units
    Math::Trig::Units::units('degrees');
    # return current unit setting
    $units = Math::Trig::Units::units();

    # set the factor that allows a function that is almost zero to be zero
    # if int(func($x)*factor) == 0 then the function will be assumed to
    # return zero rather than 0.00000000000001
    Math::Trig::Units::zero(10e10);

    # to make functions in degrees or radians return the expected value
    # we can use the approx() function
    approx(dsin(30)) == 0.5  # without approx it would be 0.49999999999999945

=head1 DESCRIPTION

This module exports the missing inverse and hyperbolic trigonometric
functions of real numbers.  The inverse functions return values
cooresponding to the principal values.  Specifying an argument outside
of the domain of the function where an illegal divion by zero would occur
will cause infinity to be returned. Infinity is Perl's version of this.

This module implements the functions in degrees by default. If you want
radians use Math::Trig or set the units via the units sub:

    # set radians instead of degrees (default)
    Math::Trig::Units::units('radians');
    # set gradians as units
    Math::Trig::Units::units('gradians');
    # set degrees as units
    Math::Trig::Units::units('degrees');
    # return current unit setting
    $units = Math::Trig::Units::units();

A value of Pi to 30 decimal places is used in the source. This
will be truncated by your version of Perl to the longest float supported.

To avoid redefining the internal sin() and cos() functions this module
calls the functions dsin() and dcos().

=head3 units

Set the units. Options are 'radians', 'degrees', 'gradians' and are case
insensitive. Alternatively you can call the subclasses

    Math::Trig::Degree
    Math::Trig::Radian
    Math::Trig::Gradian

=head3 zero

If a function returns a value like 0.0000000000001 the correct value is
in fact probably 0. When we have a 1/func() expression the return value
should thus be #INF rather than some arbitarily large integer. To round
very small numbers to zero for this purpose we use

    int( func() * factor )

By default a factor or 1e12 is used so 1e-12 is not zero but 1e-13 is.
You can set any factor you want although he default should work fine.

=head3 approx

Because of the limit on the accuracy of the vaule of Pi that is easily
supported via a float you will get values like dsin(30) = 0.49999999999999945
when using degrees (or gradians). This can be fixed using the approx()
function.

By default the approx sub will modify numbers so if we have a number like
0.499999945 with 6 9s or 0.50000012 with 6 0s the number will be rounded to
0.5. It also works on numbers like 5.250000001. This is useful when using
degrees or gradians. In degrees these functions will return 0.5 as expected

    approx(dsin(30))
    approx(dcos(30))

The approx sub takes a second optional argument that specifies how many
0s or 9s in a row will trigger rounding. The default is 6.

    approx($num, 7);  # will return 0.5 for 0.500000001 but 0.50000001 if
                      # that is passed as it only has 6 zeros.

Numbers that do not fulfill the requisite criteria are returned unchanged.
For example 0.5000001 will not be rounded to 0.5 as it only has 5 0s.

=head3 dsin

returns sin of real argument.

=head3 dcos

returns cos of real argument.

=head3 tan

returns tangent of real argument.

=head3 sec

returns secant of real argument.

=head3 csc

returns cosecant of real argument.

=head3 cot

returns cotangent of real argument.

=head3 asin

returns inverse sine of real argument.

=head3 acos

returns inverse cosine of real argument.

=head3 atan

returns inverse tangent of real argument.

=head3 asec

returns inverse secant of real argument.

=head3 acsc

returns inverse cosecant of real argument.

=head3 acot

returns inverse cotangent of real argument.

=head3 sinh

returns hyperbolic sine of real argument.

=head3 cosh

returns hyperbolic cosine of real argument.

=head3 tanh

returns hyperbolic tangent of real argument.

=head3 sech

returns hyperbolic secant of real argument.

=head3 csch

returns hyperbolic cosecant of real argument.

=head3 coth

returns hyperbolic cotangent of real argument.

=head3 asinh

returns inverse hyperbolic sine of real argument.

=head3 acosh

returns inverse hyperbolic cosine of real argument.

(positive value only)

=head3 atanh

returns inverse hyperbolic tangent of real argument.

=head3 asech

returns inverse hyperbolic secant of real argument.

(positive value only)

=head3 acsch

returns inverse hyperbolic cosecant of real argument.

=head3 acoth

returns inverse hyperbolic cotangent of real argument.

=head1 HISTORY

Modification of Math::Trig by request from stefan_k.

=head1 BUGS

Because of the limit on the accuracy of the vaule of Pi that is easily
supported via a float you will get values like dsin(30) = 0.49999999999999945
when using degrees. This can be fixed using the approx() function

Let me know about any others.

=head1 AUTHOR

Initial Version John A.R. Williams <J.A.R.Williams@aston.ac.uk>
Bug fixes and many additonal functions Jason Smith <smithj4@rpi.edu>
This version James Freeman <james.freeman@id3.org.uk>

=cut




