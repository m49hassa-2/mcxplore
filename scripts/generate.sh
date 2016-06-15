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

declare -a row=("hit" "random" "conflict" "custom_hit" "linear" "locality%")
declare -a rank=("same" "interleave" "random" "interleave%" "linear")
declare -a bank=("same" "interleave" "random" "interleave%" "linear")
declare -a channel=("same" "interleave" "random" "interleave%" "linear")
declare -a type=("rd" "wr" "sw" "sw%" "random")

for rw in "${row[@]}"
do
	for rnk in "${rank[@]}"
	do
		for bnk in "${bank[@]}"
		do
			for ch in "${channel[@]}"
			do
				for ty in "${type[@]}"
				do
					if [[ "$rnk" == "interleave%" ]]; then
						rnk2="0.5interleave"
					else
						rnk2=$rnk
					fi
					if [[ "$bnk" == "interleave%" ]]; then
						bnk2="0.5interleave"
					else
						bnk2=$bnk
					fi
					if [[ "$ch" == "interleave%" ]]; then
						ch2="0.5interleave"
					else
						ch2=$ch
					fi
					if [[ "$rw" == "locality%" ]]; then
						rw2="0.5locality"
					else
						rw2=$rw
					fi
					if [[ "$rw" == "custom_hit" ]]; then
						rw2="1000hits"
					else
						rw2=$rw
					fi
					if [[ "$ty" == "sw%" ]]; then
						ty2="0.5sw"
					else
						ty2=$ty
					fi

					sed -i "s/transaction_pattern X/transaction_pattern $ty/g" configuration.data
					sed -i "s/row_pattern X/row_pattern $rw/g" configuration.data
					sed -i "s/rank_pattern X/rank_pattern $rnk/g" configuration.data
					sed -i "s/bank_pattern X/bank_pattern $bnk/g" configuration.data
					sed -i "s/channel_pattern X/channel_pattern $ch/g" configuration.data
					source mcxplore.sh -o ROW_"$rw2"_RNK_"$rnk2"_BNK_"$bnk2"_CH_"$ch2"_"$ty2".trc

					sed -i "s/transaction_pattern $ty/transaction_pattern /g" configuration.data
					sed -i "s/row_pattern $rw/row_pattern /g" configuration.data
					sed -i "s/rank_pattern $rnk/rank_pattern /g" configuration.data
					sed -i "s/bank_pattern $bnk/bank_pattern /g" configuration.data
					sed -i "s/channel_pattern $ch/channel_pattern /g" configuration.data

		
				done	

		
			done	

		
		done	

		
	done	
		
done	


