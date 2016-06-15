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
#package AddressGeneration;
use Variables;


#use Exporter 'import';
#our $VERSION = '1.00';
#our @EXPORT  = qw(generate_linear_address generate_random_address generate_AllHit_sameBank_address generate_AllConflict_sameBank_address);
######################################################################################3

###############################################################################
sub generate_linear_address
{
	if ($_[0] == 32) {
		$GetAddress=sprintf("0x%08x", $_[1]*$_[2]);
	}
	elsif ($_[0] == 64){
		$GetAddress=sprintf("0x%016x", $_[1]*$_[2]);

	}
}
###############################################################################
sub generate_random_address
{
	if ($_[0] == 32) {
		$GetAddress=sprintf("0x%08x", int(rand(4294967297)));
	}
	elsif ($_[0] == 64){
		$GetAddress=sprintf("0x%016x", int(rand(1.8446744e+19))); 

	}
}

###############################################################################
sub generate_row
{
	if ($ROW_PATTERN eq "hit"){

		if ($TARGET_ROW < $num_rows){

			$ROW=$TARGET_ROW;
		}

		else{

			print "ERROR: inserted row number:$TARGET_ROW > number of rows:$num_rows\n";
		}
	}

	elsif ($ROW_PATTERN eq "random"){
			$ROW=generate_random_bits($ADDR_LEN,$RowMask);
	}

	elsif ($ROW_PATTERN eq "conflict"){

				$ROW=generate_successive_bits($ADDR_LEN,$RowMask,$i % $num_rows);
	}

	elsif ($ROW_PATTERN eq "custom_hits"){

			{ use integer;
				$myRow=$i/($num_hits);
	  	}


			$ROW=generate_successive_bits($ADDR_LEN,$RowMask,$myRow % $num_rows);
	
	}

	elsif ($ROW_PATTERN eq "linear"){

		{ use integer;
			$myRow=$i/(8*8);
		}
	}

	elsif ($ROW_PATTERN eq "xor"){

			if ($i<$NUM_REQ*(1-($BankInterleave/100))){
				
				$ROW=generate_successive_bits($ADDR_LEN,$RowMask,$i % $num_rows);
		}

#			elsif ($i==$NUM_REQ*(1-($BankInterleave/100))){
				
#				$ROW=0;
#		}


		else{
				{ use integer;
			   $myRow=$i/($num_banks);
				$ROW=generate_successive_bits($ADDR_LEN,$RowMask,$myRow % 8);
		}
		}

	}


	elsif ($ROW_PATTERN eq "locality%"){

		if ($i<=$NUM_REQ*(1-($locality/100))){
				$ROW=generate_successive_bits($ADDR_LEN,$RowMask,$i % $num_rows); #conflicts
				$TARGET_ROW=$ROW; #to maintain the last accessed row for use in the hits part
		}
		else{
				$ROW=$TARGET_ROW;
		}


				
	}

	else{
		print "ERROR: Unknown row pattern: $ROW_PATTERN\n";
	}

	return $ROW;

}
###############################################################################
sub generate_rank
{
	if ($RANK_PATTERN eq "same"){

		if ($TARGET_RANK < $num_ranks){

			$RANK=$TARGET_RANK;
		}

		else{

			print "ERROR: inserted rank number:$TARGET_RANK > number of ranks:$num_ranks\n";
		}
	}

	elsif ($RANK_PATTERN eq "random"){
			$RANK=generate_random_bits($ADDR_LEN,$RankMask);
	}

	elsif ($RANK_PATTERN eq "interleave"){
			use integer;
      		$myRank=$i/(2);

			$RANK=generate_successive_bits($ADDR_LEN,$RankMask,$myRank % $num_ranks);
	}


	elsif ($RANK_PATTERN eq "linear"){
		{ use integer;
      #		$myRank=$i/($num_banks*$num_columns);
			$myRank=$i/($num_banks);
		}
				

			$RANK=generate_successive_bits($ADDR_LEN,$RankMask,$myRank % $num_ranks);
	}



	elsif ($RANK_PATTERN eq "interleave%"){
	if ($i<=$NUM_REQ*(1-($RankInterleave/100))){
				$RANK=$TARGET_RANK;#generate_successive_bits($ADDR_LEN,$RowMask,$i % $num_rows); #conflicts
				#$TARGET_ROW=$ROW; #to maintain the last accessed row for use in the hits part
		}
		else{
				$RANK=generate_successive_bits($ADDR_LEN,$RankMask,$i%($num_ranks));
		}

				
	}

	else{
		print "ERROR: Unknown rank pattern: $RANK_PATTERN\n";
	}
	return $RANK;
}
###############################################################################
sub generate_bank
{
	if ($BANK_PATTERN eq "same"){

		if ($TARGET_BANK < $num_banks){

			$BANK=$TARGET_BANK;
		}

		else{

			print "ERROR: inserted bank number:$TARGET_BANK> number of banks:$num_banks\n";
		}
	}

	elsif ($BANK_PATTERN eq "random"){
			$BANK=generate_random_bits($ADDR_LEN,$BankMask);
	}

	elsif ($BANK_PATTERN eq "interleave"){

			$BANK=generate_successive_bits($ADDR_LEN,$BankMask,$i%($num_banks));
	}

	elsif ($BANK_PATTERN eq "linear"){

		{ use integer;
			$myBank=$i/16;
		#	$myBank=$i/($num_ranks*$num_channels);
		}

			$BANK=generate_successive_bits($ADDR_LEN,$BankMask,$myBank % $num_banks);
	}


	elsif ($BANK_PATTERN eq "interleave%"){

		if ($i<=$NUM_REQ*(1-($BankInterleave/100))){
				$BANK=$TARGET_BANK;#generate_successive_bits($ADDR_LEN,$RowMask,$i % $num_rows); #conflicts
				#$TARGET_ROW=$ROW; #to maintain the last accessed row for use in the hits part
		}
		else{
				$BANK=generate_successive_bits($ADDR_LEN,$BankMask,$i%($num_banks));
		}


				
	}

	else{
		print "ERROR: Unknown bank pattern: $BANK_PATTERN\n";
	}

	return $BANK;
}
###############################################################################
sub generate_channel
{
	if ($CHANNEL_PATTERN eq "same"){

		if ($TARGET_CHANNEL < $num_channels){

			$CHANNEL=$TARGET_CHANNEL;
		}

		else{

			print "ERROR: inserted channel number:$TARGET_CHANNEL > number of channels:$num_channels\n";
		}
	}

	elsif ($CHANNEL_PATTERN eq "random"){
			$CHANNEL=generate_random_bits($ADDR_LEN,$ChannelMask);
	}

	elsif ($CHANNEL_PATTERN eq "interleave"){

			$CHANNEL=generate_successive_bits($ADDR_LEN,$ChannelMask,$i%($num_channels));
	}

	elsif ($CHANNEL_PATTERN eq "linear"){

		{ use integer;
			$myChannel=$i/($num_banks*$num_ranks);
		}


			$CHANNEL=generate_successive_bits($ADDR_LEN,$ChannelMask,($myChannel % $num_channels));
	}



	elsif ($CHANNEL_PATTERN eq "interleave%"){

		if ($i<=$NUM_REQ*(1-($ChannelInterleave/100))){
				$CHANNEL=$TARGET_CHANNEL;#generate_successive_bits($ADDR_LEN,$RowMask,$i % $num_rows); #conflicts
				#$TARGET_ROW=$ROW; #to maintain the last accessed row for use in the hits part
		}
		else{
				$CHANNEL=generate_successive_bits($ADDR_LEN,$ChannelMask,$i%($num_channels));
		}

	}

	else{
		print "ERROR: Unknown channel pattern: $CHANNEL_PATTERN\n";
	}


	return $CHANNEL;
}
###############################################################################
sub generate_column
{
	if ($COLUMN_PATTERN eq "same"){

		if ($TARGET_COLUMN < $num_columns){

			$COLUMN=$TARGET_COLUMN;
		}

		else{

			print "ERROR: inserted column number:$TARGET_COLUMN > number of columns:$num_columns\n";
		}
	}

	elsif ($COLUMN_PATTERN eq "random"){
			$COLUMN=generate_random_bits($ADDR_LEN,$ColumnMask);
	}

	elsif ($COLUMN_PATTERN eq "interleave"){

			$COLUMN=generate_successive_bits($ADDR_LEN,$ColumnMask,$i%($num_columns));
	}


	elsif ($COLUMN_PATTERN eq "linear"){
		{ use integer;
			$myColumn=$i/8;
		}


			$COLUMN=generate_successive_bits($ADDR_LEN,$ColumnMask,$myColumn%($num_columns));
	}


	elsif ($COLUMN_PATTERN eq "interleave%"){

				
	}

	else{
		print "ERROR: Unknown column pattern: $COLUMN_PATTERN\n";
	}


	return $COLUMN;
}
###############################################################################
sub generate_random_bits
{
	if ($_[0] == 32) {
		$bin=sprintf ("%032b",$_[1]);
	}
	elsif ($_[0] == 64){
		$bin=sprintf ("%064b",$_[1]);

	}

	$str="$bin";
	my $bit_vector = pack "b*", $str;

	$GetRandom=0;
	for (0..$_[0]-1) {
		$flip=$_[0]-$_-1;

  	if (vec $bit_vector, $_, 1){

			$rand_bit=int(rand(2)); #0 or 1
			$GetRandom=$GetRandom+$rand_bit*(2**$flip); 
						
		}
	}
	return $GetRandom;
}
###############################################################################
sub generate_successive_bits ##assume consecutive
{

$flip;
	if ($_[0] == 32) {
		$bin=sprintf ("%032b",$_[1]);
	}
	elsif ($_[0] == 64){
		$bin=sprintf ("%064b",$_[1]);

	}

	$str="$bin";
	my $bit_vector = pack "b*", $str;


	for (0..$_[0]-1) {
		

  	if (vec $bit_vector, $_, 1){
			$flip=$_[0]-$_-1; #get the LS one
					
		}
  }
	
	$GetSuccessive=($_[2] << $flip); 
	 
	return $GetSuccessive;

}



1;

