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

sub read_configuration
{
	while (my $line = <$fh2>) {

 	 if ($line =~/^number_of_requests(.*?)\n/){
			$NUM_REQ=$1; 
		}
		elsif ($line =~ /^transaction_size (.*?)\n/){
			$TX_SIZE=$1; 
		}
		elsif ($line =~ /^address_length (.*?)\n/){
			$ADDR_LEN=$1; 
		}
		elsif ($line =~ /^transaction_pattern (.*?)\n/){
			$TYPE_PATTERN=$1; 
		}

		elsif ($line =~ /^switch (.*?)\n/){
			$switch=$1; 
		}

		elsif ($line =~ /^address_pattern (.*?)\n/){
			$ADDR_PATTERN=$1; 
		}
		elsif ($line =~ /^channel_pattern (.*?)\n/){
			$CHANNEL_PATTERN=$1; 
		}
		elsif ($line =~ /^row_pattern (.*?)\n/){
			$ROW_PATTERN=$1; 
		}
		elsif ($line =~ /^num_hits (.*?)\n/){
			$num_hits=$1; 
		}
		elsif ($line =~ /^locality (.*?)\n/){
			$locality=$1; 
		}

		elsif ($line =~ /^BankInterleave (.*?)\n/){
			$BankInterleave=$1; 
		}
		elsif ($line =~ /^RankInterleave (.*?)\n/){
			$RankInterleave=$1; 
		}
		elsif ($line =~ /^ChannelInterleave (.*?)\n/){
			$ChannelInterleave=$1; 
		}



		elsif ($line =~ /^rank_pattern (.*?)\n/){
			$RANK_PATTERN=$1; 
		}
		elsif ($line =~ /^bank_pattern (.*?)\n/){
			$BANK_PATTERN=$1; 
		}
		elsif ($line =~ /^column_pattern (.*?)\n/){
			$COLUMN_PATTERN=$1; 
		}
 		elsif ($line =~ /^target_row (.*?)\n/){
			$TARGET_ROW=$1; 
		}
		elsif ($line =~ /^target_bank (.*?)\n/){
			$TARGET_BANK=$1; 
		}
		elsif ($line =~ /^target_rank (.*?)\n/){
			$TARGET_RANK=$1; 
		}
		elsif ($line =~ /^target_channel (.*?)\n/){
			$TARGET_CHANNEL=$1; 
		}
		elsif ($line =~ /^target_column (.*?)\n/){
			$TARGET_COLUMN=$1; 
		}
		elsif ($line =~/^syntax (.*?)\n/){
			$Syntax=$1; 

		}
	
		elsif ($line =~/^initial_address (.*?)\n/){
			$TARGET_ADDRESS= hex "$1"; 
		}

		elsif ($line =~/^initial_type (.*?)\n/){
			$TARGET_TYPE=$1; 
		}
		elsif ($line =~/^type_syntax (.*?)\n/){
			$TYPE_SYNTAX=$1; 
		}
		elsif ($line =~/^address_length (.*?)\n/){
			$ADDR_LEN=$1; 
		}



		elsif ($line =~ /^column_mask (.*?)\n/){
			$ColumnMask=hex "$1"; 
		}
		elsif ($line =~ /^row_mask (.*?)\n/){
			$RowMask=hex "$1"; 
		}
		elsif ($line =~ /^rank_mask (.*?)\n/){
			$RankMask=hex "$1"; 
		}
		elsif ($line =~ /^bank_mask (.*?)\n/){
			$BankMask=hex "$1"; 
		}
		elsif ($line =~ /^channel_mask (.*?)\n/){
			$ChannelMask=hex "$1";  
		}

		elsif (($line =~ /^#(.*)\n/) or ($line =~ /\n/)){
			#Just a comment or empty line => SKIP
		}
		else {
			print "ERROR: Unknown configuration: $line\n";
			exit;
		}
 
	}

}
##################################################################################
sub extract_segments
{ 
	analyse_Mapping();
	$TARGET_ROW=$RowMask & $TARGET_ADDRESS;
	$TARGET_COLUMN=$ColumnMask & $TARGET_ADDRESS;
	$TARGET_BANK=$BankMask & $TARGET_ADDRESS;
	$TARGET_RANK=$RankMask & $TARGET_ADDRESS;
	$TARGET_CHANNEL=$ChannelMask & $TARGET_ADDRESS;

	$TARGET_ROW=$TARGET_ROW>>$LSB_ROW;
	$TARGET_COLUMN=$TARGET_COLUMN>>$LSB_COLUMN;
	$TARGET_BANK=$TARGET_BANK>>$LSB_BANK;
	$TARGET_RANK=$TARGET_RANK>>$LSB_RANK;
	$TARGET_CHANNEL=$TARGET_CHANNEL>>$LSB_CHANNEL;
=for comment
#	print "ROW: $TARGET_ROW\n";
#	print "COLUMN: $TARGET_COLUMN\n";
#	print "BANK: $TARGET_BANK\n";
#	print "RANK: $TARGET_RANK\n";
#	print "CHANNEL: $TARGET_CHANNEL\n";
=cut

}
1;
