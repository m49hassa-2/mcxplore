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
use FindBin;  
use Variables;


read_DDrTimings();


sub read_DDrTimings
{

my $DDR   = $ARGV[0];



open($DDr2, '<:encoding(UTF-8)', $DDR)
  or die "Could not open file '$DDR' $!";

open($inCMD, '<:encoding(UTF-8)', "Models/CMDmdl.base")
  or die "Could not open file 'Models/CMDmdl.base' $!";




open ($OutCMD,'>','Models/CMDmdl.timing') or die "cannot open 'Models/CMDmdl.timing'\n";



while (my $line = <$DDr2>) {

 	 if ($line =~/^tRP (.*?)\n/){
			$tRP=$1; 
		}
		elsif ($line =~ /^tCCD (.*?)\n/){
			$tCCD=$1; 
		}
		elsif ($line =~ /^tRAS (.*?)\n/){
			$tRAS=$1; 
		}
		elsif ($line =~ /^tRC (.*?)\n/){
			$tRC=$1; 
		}

		elsif ($line =~ /^tRCD (.*?)\n/){
			$tRCD=$1; 
		}

		elsif ($line =~ /^tRRD (.*?)\n/){
			$tRRD=$1; 
		}
		elsif ($line =~ /^tFAW (.*?)\n/){
			$tFAW=$1; 
		}
		elsif ($line =~ /^tRL (.*?)\n/){
			$tRL=$1; 
		}
		elsif ($line =~ /^tWL (.*?)\n/){
			$tWL=$1; 
		}
		elsif ($line =~ /^tRTP (.*?)\n/){
			$tRTP=$1; 
		}

		elsif ($line =~ /^tWR (.*?)\n/){
			$tWR=$1; 
		}

		elsif ($line =~ /^tWTR (.*?)\n/){
			$tWTR=$1; 
		}

		elsif ($line =~ /^tRTRS (.*?)\n/){
			$tRTRS=$1; 
		}

		elsif ($line =~ /^tBUS (.*?)\n/){
			$tBUS=$1; 
		}
		elsif ($line =~ /^READ_TO_WRITE_DELAY (.*?)\n/){
			$READ_TO_WRITE_DELAY=$1; 
		}
		elsif ($line =~ /^RANK_TO_RANK_DELAY (.*?)\n/){
			$RANK_TO_RANK_DELAY=$1; 
		}
		elsif ($line =~ /^READ_TO_PRE_DELAY (.*?)\n/){
			$READ_TO_PRE_DELAY=$1; 
		}

		elsif ($line =~ /^WRITE_TO_READ_DELAY_B (.*?)\n/){
			$WRITE_TO_READ_DELAY_B=$1; 

		}
		elsif ($line =~ /^WRITE_TO_READ_DELAY_R (.*?)\n/){
			$WRITE_TO_READ_DELAY_R=$1; 
		}

		elsif ($line =~ /^WRITE_TO_PRE_DELAY (.*?)\n/){
			$WRITE_TO_PRE_DELAY=$1; 
		}

		elsif (($line =~ /^#(.*)\n/) or ($line =~ /\n/)){
			#Just a comment or empty line => SKIP
		}
		else {
			print "ERROR: Unknown configuration: $line\n";
			exit;
		}


	}

print  $OutCMD "MODULE main\n"; 
print  $OutCMD "VAR\n"; 
print  $OutCMD "value_tRP:$tRP..$tRP;\n"; 
print  $OutCMD "value_tCCD:$tCCD..$tCCD;\n"; 
print  $OutCMD "value_tRAS:$tRAS..$tRAS;\n"; 
print  $OutCMD "value_tRC:$tRC..$tRC;\n"; 
print  $OutCMD "value_tRCD:$tRCD..$tRCD;\n"; 
print  $OutCMD "value_tRRD:$tRRD..$tRRD;\n"; 
print  $OutCMD "value_tFAW:$tFAW..$tFAW;\n"; 
print  $OutCMD "value_tRL:$tRL..$tRL;\n"; 
print  $OutCMD "value_tWL:$tWL..$tWL;\n"; 
print  $OutCMD "value_tRTP:$tRTP..$tRTP;\n"; 
print  $OutCMD "value_tWR:$tWR..$tWR;\n"; 
print  $OutCMD "value_tWTR:$tWTR..$tWTR;\n"; 
print  $OutCMD "value_tRTRS:$tRTRS..$tRTRS;\n"; 
print  $OutCMD "value_tBUS:$tBUS..$tBUS;\n"; 
print  $OutCMD "value_READ_TO_WRITE_DELAY:$READ_TO_WRITE_DELAY..$READ_TO_WRITE_DELAY;\n"; 
print  $OutCMD "value_RANK_TO_RANK_DELAY:$RANK_TO_RANK_DELAY..$RANK_TO_RANK_DELAY;\n"; 
print  $OutCMD "value_READ_TO_PRE_DELAY:$READ_TO_PRE_DELAY..$READ_TO_PRE_DELAY;\n"; 
print  $OutCMD "value_WRITE_TO_READ_DELAY_B:$WRITE_TO_READ_DELAY_B..$WRITE_TO_READ_DELAY_B;\n"; 
print  $OutCMD "value_WRITE_TO_READ_DELAY_R:$WRITE_TO_READ_DELAY_R..$WRITE_TO_READ_DELAY_R;\n"; 
print  $OutCMD "value_WRITE_TO_PRE_DELAY:$WRITE_TO_PRE_DELAY..$WRITE_TO_PRE_DELAY;\n"; 

#print  "WRITE_TO_PRE_DELAY:$WRITE_TO_PRE_DELAY..$WRITE_TO_PRE_DELAY;\n"; 


#--DEFINE
#--  READ_TO_WRITE_DELAY:={tRTRS_PLUS_tBUS_PLUS_tRL_MINUS_t_WL};
#--	READ_TO_PRE_DELAY:={tBUS_PLUS_tRTP_MINUS_tCCD};
#--  RANK_TO_RANK_DELAY:={tRTRS_PLUS_tBUS};
#--	WRITE_TO_READ_DELAY_R:={tRTRS_PLUS_tBUS_PLUS_tWL_MINUS_tRL};
#--	WRITE_TO_READ_DELAY_B:={tWL_PLUS_tBUS_tWTR};
#--	WRITE_TO_PRE_DELAY:={tWL_PLUS_tBUS_PLUS_tWR};





}
1;
