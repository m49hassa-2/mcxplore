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
use constant { true => 1, false => 0 };
require "$FindBin::Bin/GenerateTest.pl";
require "$FindBin::Bin/ReadConfiguration.pl";
$templ = 'CMDmdl.bmc';
$conf = 'configuration.data';

my $ofile   = $ARGV[0];
print "$ofile\n";

open ($OUT0,'>',$ofile) or die "Could not open file '$ofile' $!";
open($fh, '<:encoding(UTF-8)', $templ)
  or die "Could not open file '$templ' $!";

open($fh2, '<:encoding(UTF-8)', $conf)
  or die "Could not open file '$conf' $!";

$Req_num=0; 
$ROW_STAT="same";
$COLUMN_STAT="diff";
$BANK_STAT="same";
$RANK_STAT="same";
$CHANNEL_STAT="same";
$TX_SIZE=32;
$TARGET_TYPE="read";
$COMMAND="UNKNOWN";
$prev_COMMAND="UNKNOWN";
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

 	 if ($line =~/^-> State: 1.(.*?) <-\n/){

			$STATE=$1;
			if ($STATE >1){
				print "commandHERE=$COMMAND\n";
			  print "prev_command=$prev_COMMAND\n";
				analyse_command();
			}
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

		}
		elsif ($line =~ /^  command = (.*?)\n/){
			print "$line\n";
			$prev_COMMAND=$COMMAND;

			$COMMAND=$1;

			
		}
		elsif ($line =~ /^  num_requests = (.*?)\n/){
			$Req_num=$1;
			print "num_requests=$Req_num\n";

		}



		elsif ($line =~ /^#(.*)\n/){
			#Just a comment line => SKIP
		}
		else {


		}
 
}
##################################################################################
sub analyse_command
{
# command: {As_s,Ad_s,Ax_d,Rs_s,Rd_s,Rx_d,Ws_s,Wd_s,Wx_d,P,Ds,De,UNKOWN};
	if(isCAS($COMMAND)){

		if (($COMMAND eq "Rs_s") or ($COMMAND eq "Rd_s") or ($COMMAND eq "Rx_d") ){
			$TARGET_TYPE="read";
		}
		else{
			$TARGET_COMMAND="write";
		}


		if (($COMMAND eq "Rs_s") or ($COMMAND eq "Ws_s")){
			$BANK_STAT="same";
			$RANK_STAT="same";

		}  		
		elsif (($COMMAND eq "Rd_s") or ($COMMAND eq "Wd_s")){
			$BANK_STAT="diff";
			$RANK_STAT="same";

		}  			
		elsif (($COMMAND eq "Rx_d") or ($COMMAND eq "Wx_d")){
			$BANK_STAT="diff";
			$RANK_STAT="diff";

		} 
		

		if(isACT($prev_COMMAND)){		
			$ROW_STAT="diff";
			print "ACT:$prev_COMMAND\n"
		}
		else{
			$ROW_STAT="same";

		}

	}



}

###################################################################################
sub isCAS
{
	if (($_[0] eq "Rs_s") or ($_[0] eq "Rd_s") or ($_[0] eq "Rx_d") or ($_[0] eq "Ws_s") or ($_[0] eq "Wd_s") or ($_[0] eq "Wx_s")){
		
		return true;
	}
	else{
		return false;
	}

}
###################################################################################
sub isACT
{
	if (($_[0] eq "As_s") or ($_[0] eq "Ad_s") or ($_[0] eq "Ax_d")){
		
		return true;
	}
	else{
		return false;
	}

}
