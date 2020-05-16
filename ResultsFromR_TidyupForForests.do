
version 15

import delimited "ResultsFromR.csv" , clear

* deal with NAs

/*
* doesn't like it if there aren't any NAs so watch out for that
replace or_ppos = "." if or_ppos=="NA"
replace or_q50 = "." if or_q50=="NA"
replace or_q975 = "." if or_q975=="NA"
replace or_q025 = "." if or_q025=="NA"

replace dcb_ppos = "." if dcb_ppos=="NA"
replace dcb_q50 = "." if dcb_q50=="NA"
replace dcb_q975 = "." if dcb_q975=="NA"
replace dcb_q025 = "." if dcb_q025=="NA"



replace pfs_ppos = "." if pfs_ppos=="NA"
replace pfs_q50 = "." if pfs_q50=="NA"
replace pfs_q975 = "." if pfs_q975=="NA"
replace pfs_q025 = "." if pfs_q025=="NA"
replace pfs_q010 = "." if pfs_q010=="NA"
replace pfs_q900 = "." if pfs_q900=="NA"
replace pfs_post = "." if pfs_post=="NA"
 
replace ttp_q50 = "." if ttp_q50=="NA"
replace ttp_q975 = "." if ttp_q975=="NA"
replace ttp_q025 = "." if ttp_q025=="NA"
replace ttp_q010 = "." if ttp_q010=="NA"
replace ttp_q900 = "." if ttp_q900=="NA"
  
replace os_q50 = "."  if os_q50=="NA"
replace os_q975 = "." if os_q975=="NA"
replace os_q025 = "." if os_q025=="NA"
replace os_q010 = "." if os_q010=="NA"
replace os_q900 = "." if os_q900=="NA"
  
*/

drop v1



// now counter-intuitively need to make these numeric again, before creating string versions
destring or_q50 or_q975 or_q025 or_post or_ppos , replace
destring dcb_q50 dcb_q975 dcb_q025 dcb_post dcb_ppos , replace
destring pfs_q50 pfs_q975 pfs_q025 pfs_q010 pfs_q900 pfs_post pfs_ppos , replace
 
* swith the polarity of posterior vars for PFS
* currently they show P(x<target) but for DCB and OR it's P(x>target) which I think makes more sense
replace pfs_post = 1-pfs_post


*change median for OR and DCB to percentage
replace or_q50 = or_q50*100
replace or_q975 = or_q975*100
replace or_q025 = or_q025*100

replace dcb_q50 = dcb_q50*100
replace dcb_q975 = dcb_q975*100
replace dcb_q025 = dcb_q025*100

* now add the strings for display	
 tostring or_q50,  	gen(or_q50_str)   format("%8.0f") force // percentage
 tostring or_q975,  gen(or_q975_str)  format("%8.0f") force
 tostring or_q025,  gen(or_q025_str)  format("%8.0f") force
 tostring or_post,  gen(or_post_str)  format("%8.2f") force
 tostring or_ppos,  gen(or_ppos_str)  format("%8.2f") force
 
 
 tostring dcb_q50,   gen(dcb_q50_str)   format("%8.0f") force // percentage
 tostring dcb_q975,  gen(dcb_q975_str)  format("%8.0f") force
 tostring dcb_q025,  gen(dcb_q025_str)  format("%8.0f") force
 tostring dcb_post,  gen(dcb_post_str)  format("%8.2f") force
 tostring dcb_ppos,  gen(dcb_ppos_str)  format("%8.2f") force
 
 tostring pfs_q50,   gen(pfs_q50_str)   format("%8.1f") force
 tostring pfs_q975,  gen(pfs_q975_str)  format("%8.1f") force
 tostring pfs_q025,  gen(pfs_q025_str)  format("%8.1f") force
 tostring pfs_post,  gen(pfs_post_str)  format("%8.2f") force
 tostring pfs_ppos,  gen(pfs_ppos_str)  format("%8.2f") force
  
 replace or_ppos_str = ">0.99" if or_ppos > 0.99 & or_ppos < 2
 replace dcb_ppos_str = ">0.99" if dcb_ppos > 0.99 & dcb_ppos < 2
 replace pfs_ppos_str = ">0.99" if pfs_ppos > 0.99 & pfs_ppos < 2
 
 replace or_ppos_str =  "<0.01" if or_ppos < 0.01
 replace dcb_ppos_str = "<0.01" if dcb_ppos < 0.01
 replace pfs_ppos_str = "<0.01" if pfs_ppos < 0.01
 
 
 replace or_post_str = ">0.99" if or_post > 0.99 & or_ppos < 2
 replace dcb_post_str = ">0.99" if dcb_post > 0.99 & dcb_ppos < 2
 replace pfs_post_str = ">0.99" if pfs_post > 0.99 & pfs_ppos < 2
 

 replace or_post_str =  "<0.01" if or_post < 0.01
 replace dcb_post_str = "<0.01" if dcb_post < 0.01
 replace pfs_post_str = "<0.01" if pfs_post < 0.01
 
* bit hypothetical
 replace or_q50_str =  "< 1" if or_q50  < 1
 replace dcb_q50_str = "< 1" if dcb_q50  < 1
 replace or_q50_str =  "> 99" if or_q50  >99 & or_q50 < 101 
 replace dcb_q50_str = "> 99" if dcb_q50  >99 & dcb_q50 < 101
 
save "ResultsForForests.dta" , replace
 




import delimited  "SmokeSquamousFromR.csv"  , clear

drop v1
*change median for OR and DCB to percentage
replace or_q50 = or_q50*100
replace or_q975 = or_q975*100
replace or_q025 = or_q025*100

 

* now add the strings for display	
 tostring or_q50,  	gen(or_q50_str)   format("%8.0f") force // percentage
 tostring or_q975,  gen(or_q975_str)  format("%8.0f") force
 tostring or_q025,  gen(or_q025_str)  format("%8.0f") force
 
 
 save "SmokeSquamousForForests.dta" , replace
 
 
