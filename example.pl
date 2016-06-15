#The MIT License (MIT)

#Copyright (c) [2016] [Mohamed Hassan and Hiren Patel]

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
#####################################################################################################
#! usr/bin/perl
#!/usr/bin/perl -w



$dec= 3855;
$size=16;
$bin=sprintf ("%016b",$dec);
print "$bin\n";
$str="$bin";
my $bit_vector = pack "b*", $str;

$is_set = vec $bit_vector, $offset, 1;
$dec_out=0;
for (0..$size-1) {
$flip=$size-$_-1;
  if (vec $bit_vector, $_, 1){
		print "$flip\n";
		$rand_bit=int(rand(2)); #0 or 1
		$dec_out=$dec_out+$rand_bit*(2**$flip); 
	}
}
print "$dec_out\n";

sub dec2bin {
    my $str = unpack("B32", pack("N", shift));
    $str =~ s/^0+(?=\d)//;   # otherwise you'll get leading zeros
    return $str;
}

sub bin2dec {
    return unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
}
