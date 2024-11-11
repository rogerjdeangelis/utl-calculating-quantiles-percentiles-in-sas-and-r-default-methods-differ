# utl-calculating-quantiles-percentiles-in-sas-and-r-default-methods-differ
Calculating quantiles in sas and r default methods differ 
    %let pgm=utl-calculating-quantiles-percentiles-in-sas-and-r-default-methods-differ;

    Calculating quantiles in sas and r default methods differ

    SQL is not well suited for this kind of problem.

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
    /*  Thee Datasets         | SAS Solution                                    |                                             */
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
    /*                        |                                                 |                                             */
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
    /*                                                                                                                        */
    /*      INPUT                                                                                                             */
    /*                                                                                                                        */
    /*  Thee Datasets                                                                                                         */
    /*                                                                                                                        */
    /*                                                                                                                        */
    /*  SD1.DF1 total obs=3   SD1.DF2 total obs=3   SD1.DF3 total obs=3                                                       */
    /*                                                                                                                        */
    /*   CNN      CS           CNN     CS            CNN      CS                                                              */
    /*                                                                                                                        */
    /*    90     0.01           91     0.2            92     0.10                                                             */
    /*    90    -0.01           91    -0.2            92    -0.10                                                             */
    /*    90     0.06           91     0.8            92     0.85                                                             */
    /*                                                                                                                        */
    /**************************************************************************************************************************/

    /*                              _                 _       _
    / | ___  __ _ ___   _   _ _ __ (_)_   ____ _ _ __(_) __ _| |_ ___
    | |/ __|/ _` / __| | | | | `_ \| \ \ / / _` | `__| |/ _` | __/ _ \
    | |\__ \ (_| \__ \ | |_| | | | | |\ V / (_| | |  | | (_| | ||  __/
    |_||___/\__,_|___/  \__,_|_| |_|_| \_/ \__,_|_|  |_|\__,_|\__\___|

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
    /*                                                                                                                        */
    /*  R                                              SAS                 value_    lower_    upper_                         */
    /*      CNN value_mean lower_bound upper_bound     rownames    CNN      mean      bound     bound                         */
    /*                                                                                                                        */
    /*  1    90      0.02        -0.01        0.06         1        90    0.02000     -0.01     0.06                          */
    /*  2    91      0.267       -0.2         0.8          2        91    0.26667     -0.20     0.80                          */
    /*  3    92      0.283       -0.1         0.85         3        92    0.28333     -0.10     0.85                          */
    /*                                                                                                                        */
    /**************************************************************************************************************************/

    /*              _
      ___ _ __   __| |
     / _ \ `_ \ / _` |
    |  __/ | | | (_| |
     \___|_| |_|\__,_|

    */
