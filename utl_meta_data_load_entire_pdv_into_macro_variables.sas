Meta data application: loading the entire SAS PDV into macro variables with two statements


    Subsetting sashelp.class using macro variables
    with the same name and contents as the
    datastep program vector.

    Something to store in your synapses for a future use.

    WORKING CODE
    SAS (WPS does not support DOSUBL - and DOSUBL is not strategig?)


     COMPILE TIME DOSUBL (If _n_=0)

       %syscall set(dsid);
       %let rc=%sysfunc(fetchobs(dsid,1));

     MAINLINE

       set sashelp.class(where=(
          age=&age                      and
          &wgtLwr <= weight <= &wgtUpr  and
          &hgtLwr <= height <= &hgtUpr
         ));

HAVE
====

  WORK.META total obs=1

       Age of     Lower and upper     Lower and upper
       Interest   bounds for weight   bounds for Height
                  ===============     ================

  Obs    AGE      WGTLWR    WGTUPR    HGTLWR    HGTUPR

   1      15        80        120       60        70


  SASHELP.CLASS total obs=19

  Obs    NAME       SEX    AGE    HEIGHT    WEIGHT

    1    Alfred      M      14     69.0      112.5
    2    Alice       F      13     56.5       84.0
    3    Barbara     F      13     65.3       98.0
    4    Carol       F      14     62.8      102.5
    5    Henry       M      14     63.5      102.5
    6    James       M      12     57.3       83.0

WANT

  WORK.WANT total obs=3

  Obs    NAME       SEX    AGE    HEIGHT    WEIGHT

   1     Janet       F      15     62.5      112.5
   2     Mary        F      15     66.5      112.0
   3     William     M      15     66.5      112.0

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

data meta / label="Todays meta data for batch processing";

  age   =15;
  wgtLwr=80;
  wgtUpr=120;
  hgtLwr=60;
  hgtUpr=70;

run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

%symdel age WgtLwr WgtUpr HgtLow HgtWpr / nowarn; * just for repeated testing;

data want;
 If _n_=0 then do;
   %let rc=%sysfunc(dosubl('
     %let dsid=%sysfunc(open(meta,i));
     %syscall set(dsid);
     %let rc=%sysfunc(fetchobs(&dsid,1));
     %let rc=%sysfunc(close(&dsid));
   '));
 end;
 set sashelp.class(where=(
    age=&age                      and
    &wgtLwr <= weight <= &wgtUpr  and
    &hgtLwr <= height <= &hgtUpr
   ));
run;quit;


