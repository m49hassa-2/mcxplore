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
#!/usr/bin/perl

use FindBin;                 # locate this script
require "$FindBin::Bin/AddressGeneration.pl"; #qw(generate_linear_address generate_random_address generate_AllHit_sameBank_address);
require "$FindBin::Bin/TypeGeneration.pl";
require "$FindBin::Bin/GenerateTest.pl";
require "$FindBin::Bin/AnalyseMapping.pl";
require "$FindBin::Bin/ReadConfiguration.pl";
require "$FindBin::Bin/ReadSyntax.pl";
#use warnings;
use Variables; 

$conf = 'configuration.data';
my $ofile   = $ARGV[0];

open ($OUT0,'>',$ofile) or die "cannot open $ofile\n";
open($fh2, '<:encoding(UTF-8)', $conf)
  or die "Could not open file '$conf' $!";
 
#############################################################################

read_configuration();
##############################################################################
##############################################################################
extract_segments();

#for the initial request:
$address=sprintf("0x%08x", $TARGET_ADDRESS);
generate_type();
print_request();

#for remaining requests:
for ($i=1; $i < $NUM_REQ; $i++) {
		generate_address_pattern();
		generate_type_pattern();

	#	print  $OUT0 "$address\t$TX_SIZE\t$type\n";	
		print_request();	
}

###############################################################################
sub generate_address_pattern
{

	if ($ADDR_PATTERN eq "linear"){
    $address=generate_linear_address($ADDR_LEN,$i,$TX_SIZE);
	}	
	elsif ($ADDR_PATTERN eq "random"){
    $address=generate_random_address($ADDR_LEN,$TX_SIZE);
	}	
	else{
		$ROW=generate_row();
		$RANK=generate_rank();
		$BANK=generate_bank();
		$CHANNEL=generate_channel();	
		$COLUMN=generate_column();	
	#	print "$ROW $BANK $RANK $CHANNEL $COLUMN\n";
		$GetAddress_dec=$ROW+$BANK+$RANK+$CHANNEL+$COLUMN;

		if ($ADDR_LEN == 32) {
			$address=sprintf("0x%08x", $GetAddress_dec);
		}
		elsif ($ADDR_LEN == 64){
			$address=sprintf("0x%016x", $GetAddress_dec); 

		}

	}	

}



###############################################################################
sub generate_type_pattern
{

	if ($TYPE_PATTERN eq "sw"){
		$type=generate_SW_type();

	}

	elsif ($TYPE_PATTERN eq "sw%"){

		if ($i<=$NUM_REQ*(1-($switch/100))){
			$type=generate_RD_type();
				
		}
		else{
			$type=generate_SW_type();

		}


	}


	elsif ($TYPE_PATTERN eq "rd"){
		$type=generate_RD_type();
	}
	elsif ($TYPE_PATTERN eq "wr"){
		$type=generate_WR_type();
	}
	elsif ($TYPE_PATTERN eq "random"){
		$type=generate_Random_type();
	}

	else{
		print "ERROR: Unknown Type pattern: $TYPE_PATTERN\n";
	}
}
###############################################################################

