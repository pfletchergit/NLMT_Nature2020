
version 15

// this script takes the R output, 
// reformats the variables for display where necessary, 
// and creates forest plots to illustrate the output
 
// requires ResultsFromR_TidyupForForests.do	 in the same directory
// requires a subdirectory named Forests


// script to format variables from R to be used in the plots
do ResultsFromR_TidyupForForests.do		

* allows text to be added, currently empty
global inputtext ""




* module smoking
 
global module "Smoking"


use "SmokeSquamousForForests"  , clear

 
		preserve 
			keep if category=="PYC0"  
			local 0baseor = or_q025
			local 0median = or_q50_str
			local 0denom  = or_denom
		restore 
		preserve 
			keep if category=="PYC1"  
			local 1baseor = or_q025
			local 1median = or_q50_str
			local 1denom  = or_denom
		restore 
		preserve 
			keep if category=="PYC2"  
			local 2baseor = or_q025
			local 2median = or_q50_str
			local 2denom  = or_denom
		restore 
		preserve 
			keep if category=="PYC3"  
			local 3baseor = or_q025
			local 3median = or_q50_str
			local 3denom  = or_denom		
		restore 
	
	cap drop y 
	gen 	y = 4 if category=="PYC0"	 
	replace y = 3 if category=="PYC1"	 
	replace y = 2 if category=="PYC2"	 
	replace y = 1 if category=="PYC3"	 
		
	 
		 
 	twoway ///
		(dropline or_q975  y   if category=="PYC0"   ///
			, horizontal  base(`0baseor') ///    
			color(gold) lpattern(solid) lwidth(medthick)  msymbol(none)  ///  
			ytitle("") ylabel(none ,  nogrid angle(0) ) /// 
			xtitle("Bayesian estimate OR Rate (%)") xlabel(0(10)100) ///
			legend(off) ///  
			xline( 0(10)100 , lcolor(gs12) ) ///
			graphregion(color(white))   ///  
			)  	///		
		(dropline or_q975  y   if category=="PYC1" ///
			, horizontal  base(`1baseor') ///    
			color(orange) lpattern(solid)  msymbol(none)  ///  
			ytitle("") ylabel( none ,  nogrid angle(0) ) /// 
			graphregion(color(white))   ///  
			) ///
		(dropline or_q975  y   if category=="PYC2" ///
			, horizontal  base(`2baseor') ///    
			color(gs8) lpattern(solid)  msymbol(none)  ///  
			ytitle("") ylabel( none ,  nogrid angle(0) ) /// 
			graphregion(color(white))   ///  
			) ///
		(dropline or_q975  y   if category=="PYC3"  ///
			, horizontal  base(`3baseor') ///   
			color(gs1) lpattern(solid) msymbol(none)  ///  
			ytitle("") ylabel(none ,  nogrid angle(0) ) /// 
			graphregion(color(white))   /// 
			) ///
		(scatter y or_q50 if category=="PYC0" ///
			, msize() mcolor(gold) msymbol(square)  ) ///
		(scatter y  or_q50  if category=="PYC1" ///
			, msize() mcolor(orange) msymbol(square)  ) ///
		(scatter y  or_q50  if category=="PYC2" ///
			, msize() mcolor(gs8) msymbol(square)  ) ///
		(scatter y  or_q50  if category=="PYC3" ///
			, msize() mcolor(gs1) msymbol(square)   ///
			aspect(0.15) )
		
		graph export "Forests\\${module}_ForestOR.png" , replace		
		graph export "Forests\\${module}_ForestOR.pdf" , replace	
 			
 
 
 
* module histology
 
global module "Histology"


use "SmokeSquamousForForests"  , clear

cap drop y 
gen 	y = 2 if category=="NonSquamous"	 
replace y = 1 if category=="Squamous"	 

 		
		preserve 
			keep if category=="Squamous"
			local 0baseor = or_q025
			local 0median = or_q50_str
			local 0denom  = or_denom		
		restore 
		preserve 
			keep if category=="NonSquamous"
			local 1baseor = or_q025
			local 1median = or_q50_str
			local 1denom  = or_denom			
		restore 
		 
	 
		 
 	twoway ///
		(dropline or_q975  y   if category=="Squamous"   ///
			, horizontal  base(`0baseor') ///    
			color(blue) lpattern(solid)  msymbol(none)  ///  
			ytitle("") ylabel(none ,  nogrid angle(0) ) /// 
			xtitle("Bayesian estimate OR Rate (%)") xlabel(0(10)100) ///
			legend(off) ///  
			xline( 0(10)100 , lcolor(gs12) ) ///
			graphregion(color(white))   ///  
			)  	///		
		(dropline or_q975  y   if category=="NonSquamous" ///
			, horizontal  base(`1baseor') ///    
			color(red) lpattern(solid)  msymbol(none)  ///  
			ytitle("") ylabel( none ,  nogrid angle(0) ) /// 
			graphregion(color(white))   ///  
			) ///
		(scatter y or_q50 if category=="Squamous" ///
			, msize() mcolor(blue) msymbol(square) ) ///
		(scatter y  or_q50  if category=="NonSquamous" ///
			, msize() mcolor(red) msymbol(square)    ///
			aspect(0.1) )
		
		graph export "Forests\\${module}_ForestOR.png" , replace		
		graph export "Forests\\${module}_ForestOR.pdf" , replace	
			
	


		
		

use "ResultsForForests.dta"  , clear

global module "C1234"		

 gen y = .
 local counter = 4
 foreach cohort in ///
			"C1" ///
			"C2" ///
			"C3" ///
			"C4" ///
			{ 
	
			
	replace y = `counter' if cohortname=="`cohort'"		
	
	 		
	preserve 
		keep if cohortname=="`cohort'"	  
		local `cohort'baseor 		= or_q025_str
		local `cohort'basedcb 		= dcb_q025_str
		local `cohort'basepfs 		= pfs_q025_str
		local `cohort'				= 1
		local `cohort'_or_post 		= or_post_str // prop > target
		local `cohort'_or 			= or_q50_str   // estimate of the stat
		local `cohort'_or_ppos 		= or_ppos_str  // PPoS
		local `cohort'_dcb_post		= dcb_post_str // prop > target
		local `cohort'_dcb 			= dcb_q50_str     // estimate of the stat
		local `cohort'_dcb_ppos 	= dcb_ppos_str  // PPoS
		local `cohort'_pfs_post		= pfs_post_str // prop > target 
		local `cohort'_pfs_ppos 	= pfs_ppos_str // PPoS
	restore 
		
	display "`cohort'"	" y="  `counter'
	local counter	= `counter'-1	
			
}
*

 sort y
 order y
 
 *change cohort name to molecular values
 gen molcohort = ""
 replace molcohort="CDKN2A-SCC" if cohortname=="C1"
 replace molcohort="CDKN2A-ADC" if cohortname=="C2"
 replace molcohort="CDK4" if cohortname=="C3"
 replace molcohort="CCND1" if cohortname=="C4"
 

 labmask y , values(molcohort)
 
 preserve

			 		 
 	twoway ///
		(dropline or_q975  y   if cohortname=="C1"  ///
			, horizontal  base(`C1baseor') ///   
			color(black) lpattern(dash)  msymbol(none)  ///  
			ytitle("") ylabel(none) ytick(none) /// 
			xlabel(0(10)100 , labsize(large) ) /// 
			legend(off) ///
			xline( 0(10)100 , lcolor(gs12) ) ///	
			graphregion(color(white))   ///  
			)  	///		
		(dropline or_q975  y   if cohortname=="C2"  ///
			, horizontal  base(`C2baseor') ///    
			color(black) lpattern(solid) msymbol(none)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline or_q975  y   if cohortname=="C3"  ///
			, horizontal  base(`C3baseor') ///  
			color(black) lpattern(dash) msymbol(none)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline or_q975  y   if cohortname=="C4"  ///
			, horizontal  base(`C4baseor') ///    
			color(black) lpattern(dash) msymbol(none)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(scatter y  or_q50  if cohortname=="C1" ///
			, msize(*`C1') mcolor(black) msymbol(square)   ) ///
		(scatter y  or_q50  if cohortname=="C2" ///
			, msize(*`C2') mcolor(black) msymbol(square)   ) ///
		(scatter y  or_q50  if cohortname=="C3" ///
			, msize(*`C3') mcolor(black) msymbol(square)   ) ///
		(scatter y  or_q50  if cohortname=="C4" ///
			, msize(*`C4') mcolor(black) msymbol(square)  aspect(0.3)  ) 
		
			
		graph export "Forests\\C1234_ForestOR.png" , replace		
		graph export "Forests\\C1234_ForestOR.pdf" , replace		
		
		
			 		 
 	twoway ///
		(dropline dcb_q975  y   if cohortname=="C1"  ///
			, horizontal  base(`C1basedcb') ///  
			color(black) lpattern(dash)  msymbol(none)  ///  
			ytitle("") ylabel(none) ytick(none) /// 
			xlabel(0(10)100 , labsize(large) ) /// 
			/// legend(off) ///
			 legend(subtitle("95% credible interval")  order(  1 "Cohort open" 2 "Cohort closed" )   ) ///
			xline( 0(10)100 , lcolor(gs12) ) ///	
			graphregion(color(white))   ///  
			)  	///		
		(dropline dcb_q975  y   if cohortname=="C2"  ///
			, horizontal  base(`C2basedcb') ///    
			color(black) lpattern(solid) msymbol(none)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline dcb_q975  y   if cohortname=="C3"  ///
			, horizontal  base(`C3basedcb') ///    
			color(black) lpattern(dash) msymbol(none)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline dcb_q975  y   if cohortname=="C4"  ///
			, horizontal  base(`C4basedcb') ///  
			color(black) lpattern(dash) msymbol(none)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(scatter y  dcb_q50  if cohortname=="C1" ///
			, msize(*`C1') mcolor(black) msymbol(square)   ) ///
		(scatter y  dcb_q50  if cohortname=="C2" ///
			, msize(*`C2') mcolor(black) msymbol(square)   ) ///
		(scatter y  dcb_q50  if cohortname=="C3" ///
			, msize(*`C3') mcolor(black) msymbol(square)   ) ///
		(scatter y  dcb_q50  if cohortname=="C4" ///
			, msize(*`C4') mcolor(black) msymbol(square)  aspect(0.3)  ) 
		
		
		graph export "Forests\\C1234_ForestDCB.png" , replace		
		graph export "Forests\\C1234_ForestDCB.pdf" , replace		
		
		
		
 	twoway ///
		(dropline pfs_q975  y   if cohortname=="C1"  ///
			, horizontal  base(`C1basepfs') ///   barwidth(0.08) /// 
			color(purple) lpattern(dash)  msymbol(none)  lwidth(medthick)  ///  
			ytitle("") ylabel(none) ytick(none) ///
			xlabel(0(3)12 , labsize(large) ) /// 
			legend(off) ///
			xline(0, lcolor(gs12)) ///				
			xline(3, lcolor(purple)) ///
			xline(6, lcolor(gs12)) ///		
			xline(9, lcolor(gs12)) ///			
			xline(12, lcolor(gs12)) ///	
			graphregion(color(white))   ///  
			)  	///		
		(dropline pfs_q975  y   if cohortname=="C2"  ///
			, horizontal  base(`C2basepfs') ///   
			color(purple) lpattern(solid) msymbol(none)  lwidth(medthick) ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline pfs_q975  y   if cohortname=="C3"  ///
			, horizontal  base(`C3basepfs') ///   
			color(purple) lpattern(dash) msymbol(none)  lwidth(medthick)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline pfs_q975  y   if cohortname=="C4"  ///
			, horizontal  base(`C4basepfs') ///   
			color(purple) lpattern(dash) msymbol(none)  lwidth(medthick)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(scatter y  pfs_q50  if cohortname=="C1" ///
			, msize(*`C1') mcolor(purple) msymbol(square)   ) ///
		(scatter y  pfs_q50  if cohortname=="C2" ///
			, msize(*`C2') mcolor(purple) msymbol(square)   ) ///
		(scatter y  pfs_q50  if cohortname=="C3" ///
			, msize(*`C3') mcolor(purple) msymbol(square)   ) ///
		(scatter y  pfs_q50  if cohortname=="C4" ///
			, msize(*`C4') mcolor(purple) msymbol(square)  aspect(0.3) ) 
		
		   	
		graph export "Forests\\C1234_ForestPFS.png" , replace		
		graph export "Forests\\C1234_ForestPFS.pdf" , replace		
		
 
		
restore			
					
			
			
use "ResultsForForests.dta"  , clear

global module "ADG"		

 gen y = .
 local counter = 5
 foreach cohort in ///
			"A1" ///
			"D1" ///
			"D2" ///
			"D3" ///
			"G1" ///
			{ 
	
			
	replace y = `counter' if cohortname=="`cohort'"		
	
	 		
	preserve 
		keep if cohortname=="`cohort'"	  
		local `cohort'baseor 		= or_q025_str
		local `cohort'basedcb 		= dcb_q025_str
		local `cohort'basepfs 		= pfs_q025_str
		local `cohort'				= 1
		local `cohort'_or_post 		= or_post_str // prop > target
		local `cohort'_or 			= or_q50_str   // estimate of the stat
		local `cohort'_or_ppos 		= or_ppos_str  // PPoS
		local `cohort'_dcb_post		= dcb_post_str // prop > target
		local `cohort'_dcb 			= dcb_q50_str     // estimate of the stat
		local `cohort'_dcb_ppos 	= dcb_ppos_str  // PPoS
		local `cohort'_pfs_post		= pfs_post_str // prop > target 
		local `cohort'_pfs_ppos 	= pfs_ppos_str // PPoS
	restore 
		
	display "`cohort'"	" y="  `counter'
	local counter	= `counter'-1	
			
}
*


 sort y
 order y
 
 *change cohort name to molecular values
 gen molcohort = ""
 replace molcohort="FGFR" if cohortname=="A1"
 replace molcohort="MET-amp" if cohortname=="D1"
 replace molcohort="ROS" if cohortname=="D2"
 replace molcohort="MET-exon14" if cohortname=="D3"
 replace molcohort="EGFR" if cohortname=="G1"
 

 labmask y , values(molcohort)
 
 
 preserve

			 		 
 	twoway ///
		(dropline or_q975  y   if cohortname=="A1"  ///
			, horizontal  base(`A1baseor') ///   
			color(blue) lpattern(solid)  msymbol(none)  lwidth(medthick)  ///  
			ytitle("") ylabel(none) ytick(none) /// 
			xlabel(0(10)100 , labsize(large) ) /// 
			legend(off) ///
			xline(0, lcolor(gs12)) ///			
			xline(10, lcolor(gs12)) ///			
			xline(20, lcolor(gs12)) ///			
			xline(30, lcolor(blue)) ///
			xline(40, lcolor(gs12)) ///
			xline(50, lcolor(gs12)) ///
			xline(60, lcolor(gs12)) ///
			xline(70, lcolor(gs12)) ///			
			xline(80, lcolor(gs12)) ///			
			xline(90, lcolor(gs12)) ///			
			xline(100, lcolor(gs12)) ///	
			graphregion(color(white))   ///  
			)  	///		
		(dropline or_q975  y   if cohortname=="D1"  ///
			, horizontal  base(`D1baseor') ///  
			color(blue) lpattern(dash) msymbol(none)  lwidth(medthick)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline or_q975  y   if cohortname=="D2"  ///
			, horizontal  base(`D2baseor') ///  
			color(blue) lpattern(solid) msymbol(none)  lwidth(medthick)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline or_q975  y   if cohortname=="D3"  ///
			, horizontal  base(`D3baseor') ///  
			color(blue) lpattern(dash) msymbol(none)  lwidth(medthick)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline or_q975  y   if cohortname=="G1"  ///
			, horizontal  base(`G1baseor') ///  
			color(blue) lpattern(solid) msymbol(none)  lwidth(medthick)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(scatter y  or_q50  if cohortname=="A1" ///
			, msize(*`A1') mcolor(blue) msymbol(square)   ) ///
		(scatter y  or_q50  if cohortname=="D1" ///
			, msize(*`D1') mcolor(blue) msymbol(square)   ) ///
		(scatter y  or_q50  if cohortname=="D2" ///
			, msize(*`D2') mcolor(blue) msymbol(square)   ) ///
		(scatter y  or_q50  if cohortname=="D3" ///
			, msize(*`D3') mcolor(blue) msymbol(square)   ) ///
		(scatter y  or_q50  if cohortname=="G1" ///
			, msize(*`G1') mcolor(blue) msymbol(square)  aspect(0.3) ) 
		
			
		graph export "Forests\\ADG_ForestOR.png" , replace		
		graph export "Forests\\ADG_ForestOR.pdf" , replace		
		
	 ** need to fix upper bound for D2 pfs as it is "off the scale"
	replace pfs_q975 = 50 if pfs_q975 > 50	
			 		 
 	twoway ///
		(dropline dcb_q975  y   if cohortname=="A1"  ///
			, horizontal  base(`A1basedcb') ///   
			color(blue) lpattern(solid)  msymbol(none)  lwidth(medthick)  ///  
			ytitle("") ylabel(none) ytick(none) ///   
			xlabel(0(10)100 , labsize(large) ) ///   
			legend(subtitle("95% credible interval") order(  2 "Cohort open" 1 "Cohort closed" )   ) ///
			xline(0, lcolor(gs12)) ///			
			xline(10, lcolor(gs12)) ///			
			xline(20, lcolor(gs12)) ///			
			xline(30, lcolor(blue)) ///
			xline(40, lcolor(gs12)) ///
			xline(50, lcolor(gs12)) ///
			xline(60, lcolor(gs12)) ///
			xline(70, lcolor(gs12)) ///			
			xline(80, lcolor(gs12)) ///			
			xline(90, lcolor(gs12)) ///			
			xline(100, lcolor(gs12)) ///	
			graphregion(color(white))   ///  
			)  	///		
		(dropline dcb_q975  y   if cohortname=="D1"  ///
			, horizontal  base(`D1basedcb') ///   
			color(blue) lpattern(dash) msymbol(none)  lwidth(medthick)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline dcb_q975  y   if cohortname=="D2"  ///
			, horizontal  base(`D2basedcb') ///   
			color(blue) lpattern(solid) msymbol(none)  lwidth(medthick)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline dcb_q975  y   if cohortname=="D3"  ///
			, horizontal  base(`D3basedcb') ///   
			color(blue) lpattern(dash) msymbol(none)  lwidth(medthick)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline dcb_q975  y   if cohortname=="G1"  ///
			, horizontal  base(`G1basedcb') ///   
			color(blue) lpattern(solid) msymbol(none)  lwidth(medthick)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(scatter y  dcb_q50  if cohortname=="A1" ///
			, msize(*`A1') mcolor(blue) msymbol(square)   ) ///
		(scatter y  dcb_q50  if cohortname=="D1" ///
			, msize(*`D1') mcolor(blue) msymbol(square)   ) ///
		(scatter y  dcb_q50  if cohortname=="D2" ///
			, msize(*`D2') mcolor(blue) msymbol(square)   ) ///
		(scatter y  dcb_q50  if cohortname=="D3" ///
			, msize(*`D3') mcolor(blue) msymbol(square)   ) ///
		(scatter y  dcb_q50  if cohortname=="G1" ///
			, msize(*`G1') mcolor(blue) msymbol(square)  aspect(0.3) ) 
		
			
		graph export "Forests\\ADG_ForestDCB.png" , replace		
		graph export "Forests\\ADG_ForestDCB.pdf" , replace		
		
		
		
 	twoway ///
		(dropline pfs_q975  y   if cohortname=="A1"  ///
			, horizontal  base(`A1basepfs') ///   
			color(black) lpattern(solid)  msymbol(none)  ///  
			ytitle("") ylabel(none) ytick(none) /// 
			xlabel(0(6)48  , labsize(large) ) /// 
			legend(off) /// 
			xline(0, lcolor(gs12)) ///			
			xline(3, lcolor(gs12)) ///
			xline(6, lcolor(gs12)) ///
			xline(12, lcolor(gs12)) ///	
			xline(24, lcolor(gs12)) ///	
			xline(36, lcolor(gs12)) ///	
			xline(48, lcolor(gs12)) ///	
			text( 3  51 ">>" , color(black) size(small) ) ///
			graphregion(color(white))   ///  
			)  	///		
		(dropline pfs_q975  y   if cohortname=="D1"  ///
			, horizontal  base(`D1basepfs') ///    
			color(black) lpattern(dash) msymbol(none)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline pfs_q975  y   if cohortname=="D2"  ///
			, horizontal  base(`D2basepfs') ///   
			color(black) lpattern(solid) msymbol(none)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline pfs_q975  y   if cohortname=="D3"  ///
			, horizontal  base(`D3basepfs') ///     
			color(black) lpattern(dash) msymbol(none)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline pfs_q975  y   if cohortname=="G1"  ///
			, horizontal  base(`G1basepfs') ///    
			color(black) lpattern(solid) msymbol(none)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(scatter y  pfs_q50  if cohortname=="A1" ///
			, msize(*`A1') mcolor(black) msymbol(square)   ) ///
		(scatter y  pfs_q50  if cohortname=="D1" ///
			, msize(*`D1') mcolor(black) msymbol(square)   ) ///
		(scatter y  pfs_q50  if cohortname=="D2" ///
			, msize(*`D2') mcolor(black) msymbol(square)   ) ///
		(scatter y  pfs_q50  if cohortname=="D3" ///
			, msize(*`D3') mcolor(black) msymbol(square)   ) ///
		(scatter y  pfs_q50  if cohortname=="G1" ///
			, msize(*`G1') mcolor(black) msymbol(square)  aspect(0.3) ) 
		
			
		graph export "Forests\\ADG_ForestPFS.png" , replace		
		graph export "Forests\\ADG_ForestPFS.pdf" , replace		
	
			
 
restore			
					
					
			
use "ResultsForForests.dta"  , clear

global module "B1F"		 

 gen y = .
 local counter = 5
 foreach cohort in ///
			"B1" ///
			"F1" ///
			"F2" ///
			"F3" ///
			"F4" ///
			{ 
	
			
	replace y = `counter' if cohortname=="`cohort'"		
	
	 		
	preserve 
		keep if cohortname=="`cohort'"	  
		local `cohort'baseor 		= or_q025_str
		local `cohort'basedcb 		= dcb_q025_str
		local `cohort'basepfs 		= pfs_q025_str
		local `cohort'				= 1
		local `cohort'_or_post 		= or_post_str // prop > target
		local `cohort'_or 			= or_q50_str   // estimate of the stat
		local `cohort'_or_ppos 		= or_ppos_str  // PPoS
		local `cohort'_dcb_post		= dcb_post_str // prop > target
		local `cohort'_dcb 			= dcb_q50_str     // estimate of the stat
		local `cohort'_dcb_ppos 	= dcb_ppos_str  // PPoS
		local `cohort'_pfs_post		= pfs_post_str // prop > target 
		local `cohort'_pfs_ppos 	= pfs_ppos_str // PPoS
	restore 
		
	display "`cohort'"	" y="  `counter'
	local counter	= `counter'-1	
			
}
*


 sort y
 order y
 
 *change cohort name to molecular values
 gen molcohort = ""
 replace molcohort="TSC" if cohortname=="B1"
 replace molcohort="PIK3CAmutLUSC" if cohortname=="F1"
 replace molcohort="PIK3CAampLUSC" if cohortname=="F2"
 replace molcohort="AKT" if cohortname=="F3"
 replace molcohort="PTEN-LUSC" if cohortname=="F4"
 

 labmask y , values(molcohort)
 
 
 preserve

 	 		 
 	twoway ///
		(dropline or_q975  y   if cohortname=="B1"  ///
			, horizontal  base(`B1baseor') ///    
			color(blue) lpattern(solid)  msymbol(none)  lwidth(medthick)  ///  
			ytitle("") ylabel(none) ytick(none) ///  
			xlabel(0(10)100 , labsize(large) ) ///  
			legend(off) ///
			xline(0, lcolor(gs12)) ///			
			xline(10, lcolor(gs12)) ///			
			xline(20, lcolor(gs12)) ///			
			xline(30, lcolor(blue)) ///
			xline(40, lcolor(gs12)) ///
			xline(50, lcolor(gs12)) ///
			xline(60, lcolor(gs12)) ///
			xline(70, lcolor(gs12)) ///			
			xline(80, lcolor(gs12)) ///			
			xline(90, lcolor(gs12)) ///			
			xline(100, lcolor(gs12)) ///	
			graphregion(color(white))   /// 
			)  	///		
		(dropline or_q975  y   if cohortname=="F1"  ///
			, horizontal  base(`F1baseor') ///   
			color(blue) lpattern(solid) msymbol(none)  lwidth(medthick)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline or_q975  y   if cohortname=="F2"  ///
			, horizontal  base(`F2baseor') ///   
			color(blue) lpattern(solid) msymbol(none)  lwidth(medthick)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline or_q975  y   if cohortname=="F3"  ///
			, horizontal  base(`F3baseor') ///  
			color(blue) lpattern(solid) msymbol(none)  lwidth(medthick)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline or_q975  y   if cohortname=="F4"  ///
			, horizontal  base(`F4baseor') ///   
			color(blue) lpattern(solid) msymbol(none)  lwidth(medthick)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(scatter y  or_q50  if cohortname=="B1" ///
			, msize(*`B1') mcolor(blue) msymbol(square)   ) ///
		(scatter y  or_q50  if cohortname=="F1" ///
			, msize(*`F1') mcolor(blue) msymbol(square)   ) ///
		(scatter y  or_q50  if cohortname=="F2" ///
			, msize(*`F2') mcolor(blue) msymbol(square)   ) ///
		(scatter y  or_q50  if cohortname=="F3" ///
			, msize(*`F3') mcolor(blue) msymbol(square)   ) ///
		(scatter y  or_q50  if cohortname=="F4" ///
			, msize(*`F4') mcolor(blue) msymbol(square)  aspect(0.3) ) 
		
			
		graph export "Forests\\B1F_ForestOR.png" , replace		
		graph export "Forests\\B1F_ForestOR.pdf" , replace		
		
 
			 		 
 	twoway ///
		(dropline dcb_q975  y   if cohortname=="B1"  ///
			, horizontal  base(`B1basedcb') ///    
			color(blue) lpattern(solid)  msymbol(none)  lwidth(medthick)  ///  
			ytitle("") ylabel(none) ytick(none) ///  
			xlabel(0(10)100 , labsize(large) ) ///  
			legend(subtitle("95% credible interval") order(  1 "Cohort open" 2 "Cohort closed" )   ) ///
			xline(0, lcolor(gs12)) ///			
			xline(10, lcolor(gs12)) ///			
			xline(20, lcolor(gs12)) ///			
			xline(30, lcolor(blue)) ///
			xline(40, lcolor(gs12)) ///
			xline(50, lcolor(gs12)) ///
			xline(60, lcolor(gs12)) ///
			xline(70, lcolor(gs12)) ///			
			xline(80, lcolor(gs12)) ///			
			xline(90, lcolor(gs12)) ///			
			xline(100, lcolor(gs12)) ///	
			graphregion(color(white))   ///  
			)  	///		
		(dropline dcb_q975  y   if cohortname=="F1"  ///
			, horizontal  base(`F1basedcb') ///  
			color(blue) lpattern(solid) msymbol(none)  lwidth(medthick)   ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline dcb_q975  y   if cohortname=="F2"  ///
			, horizontal  base(`F2basedcb') ///   
			color(blue) lpattern(solid) msymbol(none)  lwidth(medthick)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline dcb_q975  y   if cohortname=="F3"  ///
			, horizontal  base(`F3basedcb') ///   
			color(blue) lpattern(solid) msymbol(none) lwidth(medthick)   ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline dcb_q975  y   if cohortname=="F4"  ///
			, horizontal  base(`F4basedcb') ///   
			color(blue) lpattern(solid) msymbol(none) lwidth(medthick)   ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(scatter y  dcb_q50  if cohortname=="B1" ///
			, msize(*`B1') mcolor(blue) msymbol(square)   ) ///
		(scatter y  dcb_q50  if cohortname=="F1" ///
			, msize(*`F1') mcolor(blue) msymbol(square)   ) ///
		(scatter y  dcb_q50  if cohortname=="F2" ///
			, msize(*`F2') mcolor(blue) msymbol(square)   ) ///
		(scatter y  dcb_q50  if cohortname=="F3" ///
			, msize(*`F3') mcolor(blue) msymbol(square)   ) ///
		(scatter y  dcb_q50  if cohortname=="F4" ///
			, msize(*`F4') mcolor(blue) msymbol(square)  aspect(0.3)  ) 
		
			
		graph export "Forests\\B1F_ForestDCB.png" , replace		
		graph export "Forests\\B1F_ForestDCB.pdf" , replace		
		
  	
	 ** need to fix upper bound for F4 pfs as it is too large for chart
	replace pfs_q975 = 10 if pfs_q975 > 10			
		
 	twoway ///
		(dropline pfs_q975  y   if cohortname=="B1"  ///
			, horizontal  base(`B1basepfs') ///   
			color(black) lpattern(solid)  msymbol(none)  ///  
			ytitle("") ylabel(none) ytick(none) ///   
			xlabel(0(3)12 , labsize(large) ) ///  
			legend(off) ///
			///  
			xline(0, lcolor(gs12)) ///			
			xline(3, lcolor(gs12)) ///
			xline(6, lcolor(gs12)) ///
			xline(9, lcolor(gs12)) ///
			xline(12, lcolor(gs12)) ///	
			text( 1  10.3 ">>" , color(black) size(small) ) ///
			graphregion(color(white))   ///  
			)  	///		
			(dropline pfs_q975  y   if cohortname=="F1"  ///
			, horizontal  base(`F1basepfs') ///    
			color(black) lpattern(solid) msymbol(none)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline pfs_q975  y   if cohortname=="F2"  ///
			, horizontal  base(`F2basepfs') ///   
			color(black) lpattern(solid) msymbol(none)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline pfs_q975  y   if cohortname=="F3"  ///
			, horizontal  base(`F3basepfs') ///    
			color(black) lpattern(solid) msymbol(none)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline pfs_q975  y   if cohortname=="F4"  ///
			, horizontal  base(`F4basepfs') ///   
			color(black) lpattern(solid) msymbol(none)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(scatter y  pfs_q50  if cohortname=="B1" ///
			, msize(*`B1') mcolor(black) msymbol(square)   ) ///
		(scatter y  pfs_q50  if cohortname=="F1" ///
			, msize(*`F1') mcolor(black) msymbol(square)   ) ///
		(scatter y  pfs_q50  if cohortname=="F2" ///
			, msize(*`F2') mcolor(black) msymbol(square)   ) ///
		(scatter y  pfs_q50  if cohortname=="F3" ///
			, msize(*`F3') mcolor(black) msymbol(square)   ) ///
		(scatter y  pfs_q50  if cohortname=="F4" ///
			, msize(*`F4') mcolor(black) msymbol(square)  aspect(0.3) ) 
		
			
		graph export "Forests\\B1F_ForestPFS.png" , replace		
		graph export "Forests\\B1F_ForestPFS.pdf" , replace		
			
		
	
restore			
							

							
							
							
							
										
use "ResultsForForests.dta"  , clear

global module "C56B2E2"		

 gen y = .
 local counter = 5
 foreach cohort in ///
			"C5" ///
			"C6" ///
			"B2D" ///
			"B2S" ///
			"E2" ///
			{ 
	
			
	replace y = `counter' if cohortname=="`cohort'"		
	
	 		
	preserve 
		keep if cohortname=="`cohort'"	  
		local `cohort'baseor 		= or_q025_str
		local `cohort'basedcb 		= dcb_q025_str
		local `cohort'basepfs 		= pfs_q025_str
		local `cohort'				= 1
		local `cohort'_or_post 		= or_post_str // prop > target
		local `cohort'_or 			= or_q50_str   // estimate of the stat
		local `cohort'_or_ppos 		= or_ppos_str  // PPoS
		local `cohort'_dcb_post		= dcb_post_str // prop > target
		local `cohort'_dcb 			= dcb_q50_str     // estimate of the stat
		local `cohort'_dcb_ppos 	= dcb_ppos_str  // PPoS
		local `cohort'_pfs_post		= pfs_post_str // prop > target 
		local `cohort'_pfs_ppos 	= pfs_ppos_str // PPoS
	restore 
		
	display "`cohort'"	" y="  `counter'
	local counter	= `counter'-1	
			
}
*

 sort y
 order y
 
 *change cohort name to molecular values
 gen molcohort = ""
 replace molcohort="KRAS-STK11" if cohortname=="C5"
 replace molcohort="KRAS" if cohortname=="C6"
 replace molcohort="STK11-KRAS" if cohortname=="B2D"
 replace molcohort="STK11" if cohortname=="B2S"
 replace molcohort="NF1" if cohortname=="E2"
 

 labmask y , values(molcohort)
 
 preserve

			 		 
 	twoway ///
		(dropline or_q975  y   if cohortname=="C5"  ///
			, horizontal  base(`C5baseor') ///    
			color(black) lpattern(dash)  msymbol(none)  ///  
			ytitle("") ylabel(none)  ytick(none)   ///   
			xlabel(0(10)100 , labsize(large) ) ///  
			legend(off) ///  
			xline( 0(10)100 , lcolor(gs12) ) ///	
			graphregion(color(white))   /// 
			)  	///		
		(dropline or_q975  y   if cohortname=="C6"  ///
			, horizontal  base(`C6baseor') ///  
			color(black) lpattern(solid) msymbol(none)  ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline or_q975  y   if cohortname=="B2D"  ///
			, horizontal  base(`B2Dbaseor') ///    
			color(blue) lpattern(dash) msymbol(none)  lwidth(medthick) ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline or_q975  y   if cohortname=="B2S"  ///
			, horizontal  base(`B2Sbaseor') ///   
			color(blue) lpattern(solid) msymbol(none)  lwidth(medthick) ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline or_q975  y   if cohortname=="E2"  ///
			, horizontal  base(`E2baseor') ///    
			color(green) lpattern(dash) msymbol(none)  lwidth(medthick) ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(scatter y  or_q50  if cohortname=="C5" ///
			, msize(*`C5') mcolor(black) msymbol(square)   ) ///
		(scatter y  or_q50  if cohortname=="C6" ///
			, msize(*`C6') mcolor(black) msymbol(square)  ) ///
		(scatter y  or_q50  if cohortname=="B2D" ///
			, msize(*`B2D') mcolor(blue) msymbol(square)  ) ///
		(scatter y  or_q50  if cohortname=="B2S" ///
			, msize(*`B2S') mcolor(blue) msymbol(square)   ) ///
		(scatter y  or_q50  if cohortname=="E2" ///
			, msize(*`E2') mcolor(green) msymbol(square)  aspect(0.3) ) ///
		(function y=30 , range( 1.5 3.5 ) lcol(blue) lwidth(medthick) horizontal ) ///
		(function y=40 , range( 0.5 1.5 ) lcol(green) lwidth(medthick) horizontal )		
			
		graph export "Forests\\C56B2E2_ForestOR.png" , replace		
		graph export "Forests\\C56B2E2_ForestOR.pdf" , replace		
		
 
	 	twoway ///
		(dropline dcb_q975  y   if cohortname=="C5"  ///
			, horizontal  base(`C5basedcb') ///    
			color(black) lpattern(dash)  msymbol(none)   ///  
			ytitle("") ylabel(none) ytick(none) /// 
			xlabel(0(10)100 , labsize(large) ) /// 
			legend(subtitle("95% credible interval") order(  1 "Cohort open" 2 "Cohort closed" )   ) ///
			xline( 0(10)100 , lcolor(gs12) ) ///	
			graphregion(color(white))   /// 
			)  	///		
		(dropline dcb_q975  y   if cohortname=="C6"  ///
			, horizontal  base(`C6basedcb') ///  
			color(black) lpattern(solid) msymbol(none)   ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline dcb_q975  y   if cohortname=="B2D"  ///
			, horizontal  base(`B2Dbasedcb') ///    
			color(blue) lpattern(dash) msymbol(none)  lwidth(medthick) ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline dcb_q975  y   if cohortname=="B2S"  ///
			, horizontal  base(`B2Sbasedcb') ///   
			color(blue) lpattern(solid) msymbol(none)  lwidth(medthick) ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline dcb_q975  y   if cohortname=="E2"  ///
			, horizontal  base(`E2basedcb') ///    
			color(green) lpattern(dash) msymbol(none)  lwidth(medthick) ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(scatter y  dcb_q50  if cohortname=="C5" ///
			, msize(*`C5') mcolor(black) msymbol(square)   ) ///
		(scatter y  dcb_q50  if cohortname=="C6" ///
			, msize(*`C6') mcolor(black) msymbol(square)   ) ///
		(scatter y  dcb_q50  if cohortname=="B2D" ///
			, msize(*`B2D') mcolor(blue) msymbol(square)   ) ///
		(scatter y  dcb_q50  if cohortname=="B2S" ///
			, msize(*`B2S') mcolor(blue) msymbol(square)   ) ///
		(scatter y  dcb_q50  if cohortname=="E2" ///
			, msize(*`E2') mcolor(green) msymbol(square)  aspect(0.3) ) ///
		(function y=30 , range( 1.5 3.5 ) lcol(blue) lwidth(medthick) horizontal ) ///
		(function y=40 , range( 0.5 1.5 ) lcol(green) lwidth(medthick) horizontal )
 	
		graph export "Forests\\C56B2E2_ForestDCB.png" , replace		
		graph export "Forests\\C56B2E2_ForestDCB.pdf" , replace		
		
		
		
 	twoway ///
		(dropline pfs_q975  y   if cohortname=="C5"  ///
			, horizontal  base(`C5basepfs') ///   
			color(purple) lpattern(dash)  msymbol(none) lwidth(medthick)  ///  
			ytitle("") ylabel(none) ytick(none) /// 
			xlabel(0(3)12 , labsize(large) ) /// 
			legend(off) ///
			xline(0, lcolor(gs12)) ///			
			xline(3, lcolor(gs12)) ///
			xline(6, lcolor(gs12)) ///
			xline(9, lcolor(gs12)) ///
			xline(12, lcolor(gs12)) ///	
			graphregion(color(white))   ///  
			)  	///		
		(dropline pfs_q975  y   if cohortname=="C6"  ///
			, horizontal  base(`C6basepfs') ///  
			color(purple) lpattern(solid) msymbol(none)  lwidth(medthick) ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline pfs_q975  y   if cohortname=="B2D"  ///
			, horizontal  base(`B2Dbasepfs') ///    
			color(black) lpattern(dash) msymbol(none)    ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline pfs_q975  y   if cohortname=="B2S"  ///
			, horizontal  base(`B2Sbasepfs') ///   
			color(black) lpattern(solid) msymbol(none)    ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(dropline pfs_q975  y   if cohortname=="E2"  ///
			, horizontal  base(`E2basepfs') ///    
			color(black) lpattern(dash) msymbol(none)    ///  
			ytitle("") ylabel( , valuelabel nogrid angle(0) ) ///
			graphregion(color(white))   ///  
			) 	///
		(scatter y  pfs_q50  if cohortname=="C5" ///
			, msize(*`C5') mcolor(purple) msymbol(square)   ) ///
		(scatter y  pfs_q50  if cohortname=="C6" ///
			, msize(*`C6') mcolor(purple) msymbol(square)   ) ///
		(scatter y  pfs_q50  if cohortname=="B2D" ///
			, msize(*`B2D') mcolor(black) msymbol(square)   ) ///
		(scatter y  pfs_q50  if cohortname=="B2S" ///
			, msize(*`B2S') mcolor(black) msymbol(square)   ) ///
		(scatter y  pfs_q50  if cohortname=="E2" ///
			, msize(*`E2') mcolor(black) msymbol(square)  aspect(0.3) ) ///
		(function y=3 , range( 3.5 5.5 ) lcol(purple) lwidth(medthick) horizontal ) ///
		(function y=3 , range( 0.5 1.5 ) lcol(gs12)  horizontal ) // to keep the same positioning of the first item
 	
		graph export "Forests\\C56B2E2_ForestPFS.png" , replace		
		graph export "Forests\\C56B2E2_ForestPFS.pdf" , replace		
	
			
restore		

	
			