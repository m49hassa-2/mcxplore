--SPEC
-- AG(row = same & bank = same & rank = same & channel = same & column = diff)

LTLSPEC G !(total_hit=2 & total_bank_interleave=4 & total_requests=10) -- locality=20% interleave=40%
--LTLSPEC G !(total_hit=30 & total_bank_interleave=0 & total_requests=32 & consecutive_hit=15 & ((consecutive_hit=15 -> X consecutive_hit=0) ->F consecutive_hit=15)) -- locality=20% interleave=40%
--LTLSPEC G (consecutive_hit=16  -> ! F (total_bank_interleave=0 & total_requests=34 & consecutive_hit=16 & total_hit=32)) -- FRFCFS threshold=16
--LTLSPEC G (((total_requests=6 & total_hit=0 & total_bank_interleave=0)-> ! F (total_requests=10 & total_hit=4 & total_bank_interleave=4)))
 -- & (total_requests=10 & total_hit=6 & total_bank_interleave=4))
