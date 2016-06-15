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

Tfile="DDrTimings/DDR3_1600.tim"
Sfile="LTLspec/CMDmdl.spec"
model="CMDmdl"

function usage
{
	echo "GenrateModel usage:"
	echo "./GenrateModel [-DDrT file |[-h]"
	echo "-t, --DDrTiming	specify the input timing file with DDR constraints. DDrTimings/DDR3_1600.tim is the default"
	echo "-m, --model		specify which model to use: \"CMDmdl\" for Model Checking Command model, or \"REqmdl\" for Model Checking request model. \"CMDmdl\" is the default"
	echo "-s, --Spec  	specify the input LTL specification file that models the test plan. CMDmdl.spec is the default"
	echo "-h, --help		prints out this usage message"          
}

while [ "$1" != "" ]; do
    		case $1 in

        	-t | --DDrTiming )		shift
          	                Tfile=$1
          	                ;;

        	-m	  | --Model )		shift
          	                model=$1
          	                ;;

        	-s	  | --Spec )		shift
          	                Sfile=$1
          	                ;;



	       	-h | --help )       usage
          	                  return    
          	                  ;;

        	* )                 usage
															return
          	                       
    esac
    shift
done

perl ReadDDrTimings.pl $Tfile
touch  Models/$model.smv

if [[ "$model" == "CMDmdl" ]]; then

	cat  Models/$model.timing  Models/$model.base LTLspec/$model.spec >  Models/$model.smv

elif [[ "$model" == "REQmdl" ]]; then

		cat  Models/$model.base LTLspec/$model.spec >  Models/$model.smv

fi

rm -rf  Models/$model.timing
