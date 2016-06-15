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


model="noMChk"
ofile_noMChk="results/noMChk/Test.trc"
ofile_CMDmdl="results/CMDmdl/Test.trc"
ofile_REQmdl="results/REQmdl/Test.trc"
ofile_set=0;		
Tfile="DDrTimings/DDR3_1600.tim"
Sfile="LTLspec/CMDmdl.spec"

function usage
{
	echo "mcxplore usage:"
	echo "run [-m model -o output_file -t DRAM_timing_file -s LTL_specs_file |[-h]"
	echo "-m, --model		specify which model to use: \"CMDmdl\" for Model Checking Command model, \"REqmdl\" for Model Checking request model, or \"noMChk\" for the no model checking usage. noMChk is the default"
	echo "-o, --out		  specify the output file name of the generated test. results/[model]/Test.trc is the default"
	echo "-t, --DDrTiming	specify the input timing file with DDR constraints. DDrTimings/DDR3_1600.tim is the default"
	echo "-s, --Spec  	specify the input LTL specification file that models the test plan. CMDmdl.spec is the default"
	echo "-h, --help		prints out this usage message"          
}

while [ "$1" != "" ]; do
    		case $1 in
        	-m | --model )		shift
          	                model=$1
          	                ;;

        	-o | --out )		shift
          	                ofile=$1
														ofile_set=1;
          	                ;;

        	-t | --DDrTiming )		shift
          	                Tfile=$1
          	                ;;

        	-s | --Spec )		shift
          	                Sfile=$1
          	                ;;



	       	-h | --help )       usage
          	                  exit   
          	                  ;;

        	* )                 usage
															exit
          	                       
    esac
    shift
done


	
if [[ "$model" == "noMChk" ]]; then

	mkdir -p results/noMChk
	if [[ $ofile_set == 1 ]]; then
		ofile_noMChk=$ofile
	fi
	perl MCXplore_noMChk.pl	$ofile_noMChk

elif [[ "$model" == "CMDmdl" ]]; then

	source GenerateModel.sh -m $model -t $Tfile -s $Sfile
	if [[ $ofile_set == 1 ]]; then
		ofile_CMDmdl=$ofile
	fi
	source MCXplore_CMDmdl.sh	-o $ofile_CMDmdl

elif [[ "$model" == "REQmdl" ]]; then

	source GenerateModel.sh -m $model -t $Tfile -s $Sfile
	if [[ $ofile_set == 1 ]]; then	
		ofile_REQmdl=$ofile
	fi	
	source MCXplore_REQmdl.sh	-o $ofile_REQmdl

else
	usage
	return	
	

fi

