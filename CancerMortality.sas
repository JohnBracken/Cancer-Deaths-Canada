/*Read in csv file of stats Canada cancer mortality data.*/
PROC IMPORT datafile= '/folders/myfolders/SASData/1310014201_databaseLoadingData.csv'
out=WORK.CancerMortality
DBMS=CSV
;
RUN;

/*Select only the data from death due to "all" neoplasms*/
PROC SQL;
CREATE TABLE AllNeoplasms AS
SELECT * 
FROM 
WORK.CancerMortality
WHERE Cause_of_Death = "All Neoplasms";
;
QUIT;

/*Rename the year and total deaths columns to something that makes more sense. */
DATA WORK.ALLNEOPLASMS (RENAME = (REF_DATE = YEAR VALUE = TOTAL_DEATHS));
SET WORK.ALLNEOPLASMS;
RUN;


ODS GRAPHICS ON;

/*Basic plot of death due to all neoplasms in Canada by year.
Doesn't look very good.*/
PROC PLOT DATA=WORK.ALLNEOPLASMS;
   PLOT TOTAL_DEATHS*YEAR;
   TITLE 'Deaths due to all neoplasms in Canada by year'; 
RUN;


/*Redo scatter plot to look better.*/

PROC SGPLOT DATA=WORK.ALLNEOPLASMS;
 	TITLE 'Deaths due to all neoplasms in Canada by year';
	SERIES X = YEAR Y = TOTAL_DEATHS/
	MARKERS
    FILLEDOUTLINEDMARKERS
    MARKERFILLATTRS=(color=yellow) 
    MARKEROUTLINEATTRS=(color=red thickness=2)
    MARKERATTRS=(symbol=circlefilled size=25 )
    LINEATTRS = (THICKNESS = 2);
    YAXIS GRID VALUES=(0 to 82000 by 10000);
RUN;


/*The above results show that these data would look better
as a vertical bar graph.  Redo the visualization with a 
bar graph approach.*/
PROC SGPLOT DATA=WORK.ALLNEOPLASMS;
	TITLE 'Deaths due to all neoplasms in Canada by year';
	VBAR YEAR/Response=TOTAL_DEATHS;
	YAXIS LABEL= "Total Number of Deaths";
	RUN;

ODS GRAPHICS OFF;