%let pgm=utl-calculating-quantiles-percentiles-in-sas-and-r-default-methods-differ;

Calculating quantiles in sas and r default methods differ

Default methods differ between software: SAS uses Type 2 quantiles by default, while R uses Type 7.

R default type 7 quantiles does not seem to be available in proc univariate, but R can use the sas type 2 algorithm.
R supports 9 types of quantiles. SAS supports 5.
Rare for SAS not to support R default algorithms?
I think R has more fellows of the American Statistical Society than SAS or Python?
R tend to be more academic?

github
https://tinyurl.com/53398ky5
https://github.com/rogerjdeangelis/utl-calculating-quantiles-percentiles-in-sas-and-r-default-methods-differ

stackoverflow R
https://tinyurl.com/cvnzfk2r
https://stackoverflow.com/questions/79171107/calculate-statistics-from-a-list-of-dataframes-in-r-by-group-or-row

 SOLUTIONS
   1 sas univariate type=2

   2 r quantile type=2

   3 r sql ntiles method
     (not applicable for small samples)
     When there are fewer rows than buckets:
     NTILE() will assign each row to a unique bucket,
     starting from 1, up to the number of rows2.
     The remaining bucket numbers will not be used.
     Does not do interpolation?

   4 python sql ntile method


/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

/**************************************************************************************************************************/
/*                        |                                                 |                                             */
/*      INPUT             |          PROCESS                                |                                             */
/*                        |                                                 |                                             */
/*  Thee Datasets         | SAS Solution                                    | SAS UNIVARIATE                              */
/*                        |                                                 |                                             */
/*                        |                                                 |                                             */
/*  SD1.DF1 total obs=3   | Append with a view                              | WORK.STATS total obs=3                      */
/*                        |                                                 |                                             */
/*   CNN      CS          | data sd1.havVue;                                | CNN      avg         p_2_5      p_97_5      */
/*                        |   set                                           |                                             */
/*    90     0.01         |     sd1.df1                                     |  90    0.02000     -0.0100      0.0600      */
/*    90    -0.01         |     sd1.df2                                     |  91    0.26667     -0.2000      0.8000      */
/*    90     0.06         |     sd1.df3                                     |  92    0.28333     -0.1000      0.8500      */
/*                        |   ;                                             |                                             */
/*  SD1.DF2 total obs=3   | run;quit;                                       |                                             */
/*                        |                                                 |                                             */
/*   CNN     CS           |                                                 |                                             */
/*                        | ods output quantiles=sd1.quants;                |                                             */
/*    91     0.2          | proc univariate data=sd1.havvue pctldef=2;      |                                             */
/*    91    -0.2          |   by cnn;                                       |                                             */
/*    91     0.8          |   var cs;                                       |                                             */
/*                        |   output out=stats mean=avg pctlpts=2.5 97.5    |                                             */
/*  SD1.DF3 total obs=3   |    pctlpre=p_;                                  |                                             */
/*                        | run;quit;                                       |                                             */
/*   CNN      CS          |                                                 |                                             */
/*                        | proc print data=stats;                          |                                             */
/*    92     0.10         |  format P_2_5 P_97_5 8.4;                       |                                             */
/*    92    -0.10         | run;quit;                                       |                                             */
/*    92     0.85         |                                                 |                                             */
/*                        |-------------------------------------------------|---------------------------------------------*/
/*                        |                                                 |                                             */
/*                        |  R                                              | R                                           */
/*                        |                                                 |                                             */
/*                        |  %utl_rbeginx;                                  | CNN value_mean lower_bound upper_bound      */
/*                        |  parmcards4;                                    |                                             */
/*                        |  library(haven)                                 |  90      0.02        -0.01        0.06      */
/*                        |  library(tidyverse)                             |  91      0.267       -0.2         0.8       */
/*                        |  source("c:/oto/fn_tosas9x.R")                  |  92      0.283       -0.1         0.85      */
/*                        |  df1 <-read_sas("d:/sd1/df1.sas7bdat")          |                                             */
/*                        |  df2 <-read_sas("d:/sd1/df2.sas7bdat")          |  SAS DATASET                                */
/*                        |  df3 <-read_sas("d:/sd1/df3.sas7bdat")          |          value_    lower_    upper_         */
/*                        |  mylist <- list(df1,df2,df3)                    |  CNN      mean      bound     bound         */
/*                        |                                                 |                                             */
/*                        |  want<-bind_rows(mylist) %>%                    |   90    0.02000     -0.01     0.06          */
/*                        |    reframe(value_mean = mean(CS, na.rm = TRUE), |   91    0.26667     -0.20     0.80          */
/*                        |     lower_bound = quantile(CS, c(.025),type=2), |   92    0.28333     -0.10     0.85          */
/*                        |     upper_bound = quantile(CS, .975,type=2)     |                                             */
/*                        |    ,.by = CNN)                                  |                                             */
/*                        |  want                                           |                                             */
/*                        |  fn_tosas9x(                                    |                                             */
/*                        |        inp    = want                            |                                             */
/*                        |       ,outlib ="d:/sd1/"                        |                                             */
/*                        |       ,outdsn ="want"                           |                                             */
/*                        |       )                                         |                                             */
/*                        |  ;;;;                                           |                                             */
/*                        |  %utl_rendx;                                    |                                             */
/*                        |                                                 |                                             */
/*                        |  proc print data=sd1.want;                      |                                             */
/*                        |  run;quit;                                      |                                             */
/*                        |                                                 |                                             */
/* -------------------------------------------------------------------------|---------------------------------------------*/
/*                        |                                                 |                                             */
/*     INPUT              | R AND PYTHON SQL NTILES                         |   R                                         */
/*     =====              | =======================                         |   =                                         */
/*                        |                                                 |                                             */
/* %let rows=1000;        | select                                          |   rownum   percentile    Value              */
/*                        |     rownum                                      |                                             */
/* data sd1.have;         |    ,case (ntile(0.025*&rows) over (order by x)) |       25    lower  2.5   0.02525            */
/* call streaminit(12345);|       when 1 then 'lower  2.5'                  |      975    upper 97.5   0.97521            */
/*   do z=1 to &rows;     |       when 2 then 'upper 97.5'                  |                                             */
/*     x= (z + .4 *       |       else ''                                   |   SAS UNIVARIATE                            */
/*  rand('uniform'))/1000;|     end as percentile                           |   ==============                            */
/*     output;            |    ,x                                           |    avg         p_2_5      p_97_5            */
/*   end;                 | from                                            |                                             */
/* run;quit;              |     (select                                     |   0.50070      0.0252      0.9752           */
/*                        |        x                                        |                                             */
/* Obs        x           |       ,row_number()                             |                                             */
/*                        |     over                                        |                                             */
/*   1    0.00123         |        (order by x) as rownum                   |                                             */
/*   2    0.00239         |     from have                                   |                                             */
/*   3    0.00323         |     )                                           |                                             */
/* ...                    | where                                           |                                             */
/* 998    0.99816         |       rownum = cast((0.025*&rows) as integer)   |                                             */
/* 999    0.99938         |    or rownum = cast((0.975*&rows) as integer)   |                                             */
/*1000    1.00031         |                                                 |                                             */
/*                        |                                                 |                                             */
/*                        |                                                 |                                             */
/*                        |                                                 |                                             */
/*                        |                                                 |                                             */
/*                        |                                                 |                                             */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/


options validvarname=v7;
           libname sd1 "d:/sd1";
data sd1.df1 sd1.df2 sd1.df3;
 input  CNN CS;
 select (mod(_n_,3));
   when (1) output sd1.df1;
   when (2) output sd1.df2;
   when (0) output sd1.df3;
 end;
cards4;
90 0.01
91 0.20
92 0.10
90 -0.01
91 -0.20
92 -0.10
90 0.06
91 0.80
92 0.85
;;;;
run;quit;

/**************************************************************************************************************************/
/*                      |                      |                                                                          */
/*      INPUT           |                      |                                                                          */
/*                      |                      |                                                                          */
/*  Thee Datasets       |                      |                                                                          */
/*                      |                      |                                                                          */
/*                      |                      |                                                                          */
/*  SD1.DF1 total obs=3 |  SD1.DF2 total obs=3 |  SD1.DF3 total obs=3                                                     */
/*                      |                      |                                                                          */
/*   CNN      CS        |   CNN     CS         |   CNN      CS                                                            */
/*                      |                      |                                                                          */
/*    90     0.01       |    91     0.2        |    92     0.10                                                           */
/*    90    -0.01       |    91    -0.2        |    92    -0.10                                                           */
/*    90     0.06       |    91     0.8        |    92     0.85                                                           */
/*                      |                      |                                                                          */
/***********************|**********************|*****************************************************************************/

/*                               _                 _       _
/ |  ___  __ _ ___   _   _ _ __ (_)_   ____ _ _ __(_) __ _| |_ ___
| | / __|/ _` / __| | | | | `_ \| \ \ / / _` | `__| |/ _` | __/ _ \
| | \__ \ (_| \__ \ | |_| | | | | |\ V / (_| | |  | | (_| | ||  __/
|_| |___/\__,_|___/  \__,_|_| |_|_| \_/ \__,_|_|  |_|\__,_|\__\___|

*/

data sd1.havVue;
  set
    sd1.df1
    sd1.df2
    sd1.df3
  ;
run;quit;

ods output quantiles=sd1.quants;
proc univariate data=sd1.havvue pctldef=2;
  by cnn;
  var cs;
  output out=stats mean=avg pctlpts=2.5 97.5
   pctlpre=p_;
run;quit;

proc print data=stats;

run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*   CNN      avg         p_2_5      p_97_5                                                                               */
/*                                                                                                                        */
/*    90    0.02000     -0.0100      0.0600                                                                               */
/*    91    0.26667     -0.2000      0.8000                                                                               */
/*    92    0.28333     -0.1000      0.8500                                                                               */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                                   _   _ _
|___ \   _ __    __ _ _   _  __ _ _ __ | |_(_) | ___  ___
  __) | | `__|  / _` | | | |/ _` | `_ \| __| | |/ _ \/ __|
 / __/  | |    | (_| | |_| | (_| | | | | |_| | |  __/\__ \
|_____| |_|     \__, |\__,_|\__,_|_| |_|\__|_|_|\___||___/
                   |_|
*/

%utl_rbeginx;
parmcards4;
library(haven)
library(tidyverse)
source("c:/oto/fn_tosas9x.R")
df1 <-read_sas("d:/sd1/df1.sas7bdat")
df2 <-read_sas("d:/sd1/df2.sas7bdat")
df3 <-read_sas("d:/sd1/df3.sas7bdat")
mylist <- list(df1,df2,df3)

want<-bind_rows(mylist) %>%
  reframe(value_mean = mean(CS, na.rm = TRUE),
   lower_bound = quantile(CS, c(.025),type=2),
   upper_bound = quantile(CS, .975,type=2)
  ,.by = CNN)
want
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                                              |                                                                         */
/*  R                                           |  SAS                 value_    lower_    upper_                         */
/*      CNN value_mean lower_bound upper_bound  |  rownames    CNN      mean      bound     bound                         */
/*                                              |                                                                         */
/*  1    90      0.02        -0.01        0.06  |      1        90    0.02000     -0.01     0.06                          */
/*  2    91      0.267       -0.2         0.8   |      2        91    0.26667     -0.20     0.80                          */
/*  3    92      0.283       -0.1         0.85  |      3        92    0.28333     -0.10     0.85                          */
/*                                              |                                                                         */
/**************************************************************************************************************************/

/*____                    _         _   _ _
|___ /   _ __   ___  __ _| |  _ __ | |_(_) | ___  ___
  |_ \  | `__| / __|/ _` | | | `_ \| __| | |/ _ \/ __|
 ___) | | |    \__ \ (_| | | | | | | |_| | |  __/\__ \
|____/  |_|    |___/\__, |_| |_| |_|\__|_|_|\___||___/
 _                   _ |_|
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

%let rows=1000;

options validvarname=v7;
libname sd1 "d:/sd1";
data sd1.have;
  call streaminit(12345);
  do z=1 to &rows;
    x= (z + .4 * rand('uniform'))/1000;
    output;
  end;
run;quit;

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

%utl_rbeginx;
parmcards4;
library(haven)
library(sqldf)
source("c:/oto/fn_tosas9x.R")
have<-read_sas("d:/sd1/have.sas7bdat")
want<-sqldf("
  select
      rownum
     ,case (ntile(0.025*&rows) over (order by x))
        when 1 then 'lower  2.5'
        when 2 then 'upper 97.5'
        else ''
      end as percentile
     ,x
  from
      (select
         x
        ,row_number()
      over
         (order by x) as rownum
      from have
      )
  where
        rownum = cast((0.025*&rows) as integer)
     or rownum = cast((0.975*&rows) as integer)
")
want
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="rsqlwant"
     )
;;;;
%utl_rendx;

proc print data=sd1.rsqlwant;
run;quit;


/*           _                 _       _              _               _
 _   _ _ __ (_)_   ____ _ _ __(_) __ _| |_ ___    ___| |__   ___  ___| | __
| | | | `_ \| \ \ / / _` | `__| |/ _` | __/ _ \  / __| `_ \ / _ \/ __| |/ /
| |_| | | | | |\ V / (_| | |  | | (_| | ||  __/ | (__| | | |  __/ (__|   <
 \__,_|_| |_|_| \_/ \__,_|_|  |_|\__,_|\__\___|  \___|_| |_|\___|\___|_|\_\

*/


ods output quantiles=sd1.quants;
proc univariate data=sd1.have pctldef=2;
  output out=stats mean=avg pctlpts=2.5 97.5
   pctlpre=p_;
run;quit;

proc print data=stats;
 format P_2_5 P_97_5 8.4;
run;quit;

/**************************************************************************************************************************/
/*                                 |                                                                                      */
/*  R BTILES                       |  SAS UNIVARIATE                                                                      */
/*                                 |                                                                                      */
/*  rownum    x       percentile   |   avg         p_2_5      p_97_5                                                      */
/*                                 |                                                                                      */
/*      25  0.02525    lower  2.5  |  0.50070      0.0252      0.9752                                                     */
/*     975  0.97521    upper 97.5  |                                                                                      */
/*                                 |                                                                                      */
/**************************************************************************************************************************/

/*  _                 _   _                             _        _   _ _
| || |    _ __  _   _| |_| |__   ___  _ __    ___  __ _| | _ __ | |_(_) | ___  ___
| || |_  | `_ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | || `_ \| __| | |/ _ \/ __|
|__   _| | |_) | |_| | |_| | | | (_) | | | | \__ \ (_| | || | | | |_| | |  __/\__ \
   |_|   | .__/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_||_| |_|\__|_|_|\___||___/
         |_|    |___/                                |_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete pywant;
run;quit;

%utl_pybeginx;
parmcards4;
exec(open('c:/oto/fn_python.py').read());
have,meta = ps.read_sas7bdat('d:/sd1/have.sas7bdat');
master,meta = ps.read_sas7bdat('d:/sd1/master.sas7bdat');
want=pdsql('''                                    \
  select                                          \
      case (ntile(0.025*&rows) over (order by x)) \
        when 1 then 'lower  2.5'                  \
        when 2 then 'upper 97.5'                  \
        else ''                                   \
      end as percentile                           \
     ,x                                           \
  from                                            \
      (select x, row_number() over (order by x) as rownum from have ) \
  where                                           \
        rownum = cast((0.025*&rows) as integer)   \
     or rownum = cast((0.975*&rows) as integer)   \
   ''');
print(want);
fn_tosas9x(want,outlib='d:/sd1/',outdsn='pywant',timeest=3);
;;;;
%utl_pyendx(resolve=Y);

proc print data=sd1.pywant;
run;quit;

/**************************************************************************************************************************/
/*                                    |                                                                                   */
/* PYTHON                             |  SAS UNIVARIATE                                                                   */
/*                                    |                                                                                   */
/*     rownum   percentile     x      |    avg         p_2_5      p_97_5                                                  */
/*                                    |                                                                                   */
/*  0      25   lower  2.5  0.025249  |  0.50070      0.0252      0.9752                                                  */
/*  1     975   upper 97.5  0.975212  |                                                                                   */
/*                                    |                                                                                   */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
