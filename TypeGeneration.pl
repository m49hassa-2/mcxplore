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

sub generate_SW_type
{
	@Type;
	$Type[0]="R";
	$Type[1]="W";
	if ($sw==0){
		$sw=1;
	}
	else{
		$sw=0;
	}
	$GetType=$Type[$sw];

}

################################################################################
sub generate_RD_type
{
	$GetType="R";
	
}
################################################################################
sub generate_WR_type
{
	$GetType="W";
}

################################################################################

sub generate_Random_type
{
	@Type;
	$Type[0]="R";
	$Type[1]="W";
	$sw = int(rand(2));
	$GetType=$Type[$sw];
	
}
#################################################################################

1;
