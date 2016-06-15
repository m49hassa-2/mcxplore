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

#use warnings;
use Variables; 
require "$FindBin::Bin/GenerateTest.pl";
require "$FindBin::Bin/ReadConfiguration.pl";
$templ = 'REQmdl.bmc';
$conf = 'configuration.data';

my $ofile   = $ARGV[0];

open ($OUT0,'>',$ofile) or die "Could not open file '$ofile' $!";
open($fh, '<:encoding(UTF-8)', $templ)
  or die "Could not open file '$templ' $!";

open($fh2, '<:encoding(UTF-8)', $conf)
  or die "Could not open file '$conf' $!";



$Req_num=0; 
$ROW_STAT="same";
$COLUMN_STAT="same";
$BANK_STAT="same";
$RANK_STAT="same";
$CHANNEL_STAT="same";
$TX_SIZE=32;
$TARGET_TYPE="read";
#############################################################################
read_configuration();
extract_segments();
##############################################################################

$prev_ROW=$TARGET_ROW;
$prev_COLUMN=$TARGET_COLUMN;
$prev_BANK=$TARGET_BANK;
$prev_RANK=$TARGET_RANK;
$prev_CHANNEL=$TARGET_CHANNEL;


while (my $line = <$fh>) {

 	 if ($line =~/^-> State: (.*?) <-\n/){
			print "Req_num=$Req_num\n";
			if ($Req_num ==1){
				$address=sprintf("0x%08x", $TARGET_ADDRESS);
				generate_type();
				print_request();
			  

			}
			if ($Req_num >1){
				#not first state ==> print previous request
				generate_request();
				$prev_ROW=$ROW;
				$prev_COLUMN=$COLUMN;
				$prev_BANK=$BANK;
				$prev_RANK=$RANK;
				$prev_CHANNEL=$CHANNEL;

			}
			$Req_num=$Req_num+1; 

		}
		elsif ($line =~ /^  row = (.*?)\n/){
			$ROW_STAT=$1;
			
			print "req=$Req_num	row=$ROW_STAT\n"; 
		}
		elsif ($line =~ /^  bank = (.*?)\n/){
			$BANK_STAT=$1; 
		}
		elsif ($line =~ /^  rank = (.*?)\n/){
			$RANK_STAT=$1; 
		}
		elsif ($line =~ /^  column = (.*?)\n/){
			$COLUMN_STAT=$1; 
		}
		elsif ($line =~ /^  channel = (.*?)\n/){
			$CHANNEL_STAT=$1; 
		}
		elsif ($line =~ /^  type = (.*?)\n/){
			$TARGET_TYPE=$1; 
		}


		elsif ($line =~ /^#(.*)\n/){
			#Just a comment line => SKIP
		}
		else {
			
		}

}
 	 generate_request(); # for the last state

