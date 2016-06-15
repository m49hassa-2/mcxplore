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


sub analyse_Mapping ##assume consecutive
{
$num_row_bits=get_ones($ADDR_LEN,$RowMask);
$num_bank_bits=get_ones($ADDR_LEN,$BankMask);
$num_rank_bits=get_ones($ADDR_LEN,$RankMask);
$num_column_bits=get_ones($ADDR_LEN,$ColumnMask);
$num_channel_bits=get_ones($ADDR_LEN,$ChannelMask);


$num_rows =2**$num_row_bits;
$num_banks =2**$num_bank_bits;
$num_ranks =2**$num_rank_bits;
$num_columns =2**$num_column_bits;
$num_channels =2**$num_channel_bits;

}
###########################################################
sub get_ones
{
$one;
$total_ones=0;
if ($_[1] == $RowMask){
	print "Row Bits: ";
}

elsif ($_[1] == $BankMask){
	print "Bank Bits: ";
}

elsif ($_[1] == $ColumnMask){
	print "Column Bits: ";
}

elsif ($_[1] == $RankMask){
	print "Rank Bits: ";
}

elsif ($_[1] == $ChannelMask){
	print "Channel Bits: ";
}
else {
	print"Unknown Mask\n";
}

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
			$one=$_[0]-$_-1; #get the LS one
			print "$one ";
			
			$total_ones=$total_ones+1;		
		}
  	}
	$LSB=$one;

	if ($_[1] == $RowMask){
		$LSB_ROW=$LSB;
	}

	elsif ($_[1] == $BankMask){
		$LSB_BANK=$LSB;
	}
	
	elsif ($_[1] == $ColumnMask){
		$LSB_COLUMN=$LSB;
	}
	
	elsif ($_[1] == $RankMask){
		$LSB_RANK=$LSB;
	}
	
	elsif ($_[1] == $ChannelMask){
		$LSB_CHANNEL=$LSB;
	}
	else {
		print"Unknown Mask\n";
	}


	print "\n";
	
	 
	 
	return $total_ones;
}
1;
