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
#!/bin/bash

function usage
{
	echo "MCXplore_CMDmdl usage:"
	echo "run [-o outfile |[-h]"
	echo "-o, --out			specify the output file name of the generated test. results/CMDmdl/Test.trc is the default"
	echo "-h, --help		prints out this usage message"          
}

while [ "$1" != "" ]; do
    		case $1 in

        	-o | --model )		shift
          	                ofile=$1
          	                ;;

	       	-h | --help )       usage
          	                  return    
          	                  ;;

        	* )                 usage
															return
          	                       
    esac
    shift
done

NuSMV/bin/NuSMV -bmc -bmc_length 100 Models/CMDmdl.smv &>CMDmdl.bmc
mkdir -p results/CMDmdl
perl CMDmdl_parser.pl $ofile
