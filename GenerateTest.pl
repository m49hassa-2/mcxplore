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
use Variables;
require "$FindBin::Bin/AnalyseMapping.pl";

##################################################################################
sub generate_request
{
#1. generate address
generate_address();

#2. generate_type
generate_type();


#3. generate the request and print it to the test file based on chosen syntax by user	

print_request();

}
##################################################################################
sub print_request
{
#print "called\n";
#$type=$TARGET_TYPE;
	if ($Syntax == 11){
			print  $OUT0 "$address	$TX_SIZE	$type\n"; 
	}
	elsif ($Syntax == 12){
			print  $OUT0 "$address	$type\n"; 
	}
	elsif ($Syntax == 21){
			print  $OUT0 "$address $TX_SIZE $type\n"; 
	}
	elsif ($Syntax == 22){
			print  $OUT0 "$addres $type\n"; 
	}
	else{
			print "ERROR: Unknown request syntax: $Syntax\n";
			exit;
	}


}
##################################################################################
sub generate_address
{
#1.1. generate segments based on whether each segment is the same as prev or diff
	if ($ROW_STAT eq "same"){
		$ROW=$prev_ROW;

	}
	elsif ($ROW_STAT eq "diff"){

		$ROW=($prev_ROW+1) % $num_rows;

	}
	else{
			print "ERROR: Unknown row stat: $ROW_STAT\n";
			exit;
	}

	if ($COLUMN_STAT eq "same"){
		$COLUMN=$prev_COLUMN;
	}
	elsif ($COLUMN_STAT eq "diff"){

		$COLUMN=($prev_COLUMN+1) % $num_columns;
	}
	else{
			print "ERROR: Unknown column stat: $COLUMN_STAT\n";
			exit;
	}

	if ($BANK_STAT eq "same"){
		$BANK=$prev_BANK;
	}
	elsif ($BANK_STAT eq "diff"){
		$BANK=($prev_BANK+1) % $num_banks;

	}
	else{
			print "ERROR: Unknown bank stat: $BANK_STAT\n";
			exit;
	}

	if ($RANK_STAT eq "same"){
		$RANK=$prev_RANK;
	}
	elsif ($RANK_STAT eq "diff"){

		$RANK=($prev_RANK+1) % $num_ranks;
	}
	else{
			print "ERROR: Unknown rank stat: $RANK_STAT\n";
			exit;
	}

	if ($CHANNEL_STAT eq "same"){
		$CHANNEL=$prev_CHANNEL;
	}
	elsif ($CHANNEL_STAT eq "diff"){

		$CHANNEL=($prev_CHANNEL+1) % $num_channels;
	}
	else{
			print "ERROR: Unknown channel stat: $CHANNEL_STAT\n";
			exit;
	}

#===========================================================================================
#1.2. generate the address from generated segments

$ROW_sh = $ROW << $LSB_ROW;
$BANK_sh = $BANK << $LSB_BANK;
$RANK_sh = $RANK << $LSB_RANK;
$CHANNEL_sh=$CHANNEL << $LSB_CHANNEL;
$COLUMN_sh= $COLUMN << $LSB_COLUMN;

 $GetAddress_dec=$ROW_sh+$COLUMN_sh+$BANK_sh+$RANK_sh+$CHANNEL_sh;
	if ($ADDR_LEN == 32) {
		$address=sprintf("0x%08x", $GetAddress_dec);
	}
	elsif ($ADDR_LEN == 64){
		$address=sprintf("0x%016x", $GetAddress_dec); 
	}
		else{
			print "ERROR: Unknown address length: $ADDR_LEN\n";
		}

}
 ##################################################################################
sub generate_type
{
	if ($TYPE_SYNTAX == 31){
		if ($TARGET_TYPE eq "read"){
			$type="READ";
		} 
		elsif ($TARGET_TYPE eq "write"){
			$type="WRITE";
		}
		elsif (($TARGET_TYPE eq "READ") or ($TARGET_TYPE eq "WRITE")){
		;}

		else{
			print "ERROR: Unknown request type: $TARGET_TYPE\n";
		}
	}
	elsif ($TYPE_SYNTAX == 32){
		if ($TARGET_TYPE eq "read"){
			$type="R";
		} 
		elsif ($TARGET_TYPE eq "write"){
			$type="W";
		}
		elsif (($TARGET_TYPE eq "R") or ($TARGET_TYPE eq "W")){
		;}

		else{
			print "ERROR: Unknown request type: $TARGET_TYPE\n";
		}

	}
	elsif ($TYPE_SYNTAX == 33){
		if ($TARGET_TYPE eq "read"){
			$type="Read";
		} 
		elsif ($TARGET_TYPE eq "write"){
			$type="Write";
		}
		elsif (($TARGET_TYPE eq "Read") or ($TARGET_TYPE eq "Write")){
		;}
		else{
			print "ERROR: Unknown request type: $TARGET_TYPE\n";
		}

	}
	else{
			print "ERROR: Unknown type syntax: $TYPE_SYNTAX\n";
		}
	
}
1;
