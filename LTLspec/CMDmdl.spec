--SPEC
--  AG(request -> AF state = busy)

LTLSPEC

-------------------------------Test_tCCD----------------------------------------
--G !(num_requests=10 & ((constraint=tCCD) S (constraint=tRCD)))
--G !(num_requests=10 & ((command=Rs_s) S (command=As_s)))

--G ! ((num_requests=10) & (num_tCCD=9) & ((num_tRL=1)|(num_tWL=1)) & (num_tBUS=1) & (num_Rx_d=0))
--------------------------------------------------------------------------------


-------------------------------Test_tRTRS----------------------------------------
--G !(num_requests=10 & ((constraint=RANK_TO_RANK_DELAY) S (constraint=tRCD)))

--G ! ((num_requests=10) & (num_RANK_TO_RANK_DELAY=9) & ((num_tRL=1)|(num_tWL=1)) & (num_tBUS=1))

--------------------------------------------------------------------------------

-------------------------------Test_tRL----------------------------------------
--G !((num_tRL=1) & (num_tBUS=1))

--------------------------------------------------------------------------------


-------------------------------Test_tRRD----------------------------------------

--G ! ((num_tRRD=3) & (num_Rd_s=3) & ((num_tRL=1)|(num_tWL=1)) & (num_tBUS=1))

--------------------------------------------------------------------------------


-------------------------------Test_tRTP----------------------------------------

G ! (((value_READ_TO_PRE_DELAY*num_READ_TO_PRE_DELAY+num_tCCD*value_tCCD+value_tRCD)>(value_tRAS)) & (num_READ_TO_PRE_DELAY>0) & (num_Rx_d=0) & (num_Rd_s=0))

--------------------------------------------------------------------------------

