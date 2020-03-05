
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Signed
by](https://img.shields.io/badge/Keybase-Verified-brightgreen.svg)](https://keybase.io/hrbrmstr)
![Signed commit
%](https://img.shields.io/badge/Signed_Commits-100%25-lightgrey.svg)
[![Linux build
Status](https://travis-ci.org/hrbrmstr/unjuris.svg?branch=master)](https://travis-ci.org/hrbrmstr/unjuris)  
![Minimal R
Version](https://img.shields.io/badge/R%3E%3D-3.2.0-blue.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

# unjuris

Search the U.N. Jurisprudence Database

## Description

The jurisprudence database is intended to be a single source of the
human rights recommendations and findings issued by all above committees
in their work on individual cases. It enables the general public,
governments, civil society organizations, United Nations partners and
international regional mechanisms to research the vast body of legal
interpretation of international human rights law as it has evolved over
the past years. Tools are provided to search and retrieve search results
from the datbase.

## What’s Inside The Tin

The following functions are implemented:

  - `get_details`: Retrieve details (document links) from a
    jurisprudence record entry
  - `juris_search`: Search the U.N. Jurisprudence Database

## Installation

``` r
remotes::install_git("https://git.rud.is/hrbrmstr/unjuris.git")
# or
remotes::install_git("https://git.sr.ht/~hrbrmstr/unjuris")
# or
remotes::install_gitlab("hrbrmstr/unjuris")
# or
remotes::install_bitbucket("hrbrmstr/unjuris")
```

NOTE: To use the ‘remotes’ install options you will need to have the
[{remotes} package](https://github.com/r-lib/remotes) installed.

## Usage

``` r
library(unjuris)

# current version
packageVersion("unjuris")
## [1] '0.1.0'
```

``` r
library(tibble) # for pretty printing

(xdf <- juris_search(year_start = 2019, year_end = 2020))
## # A tibble: 61 x 10
##    display_name  treaties countries  symbols date_of_adoptio… issues articles communications type_of_decisio… detail_url
##    <chr>         <chr>    <chr>      <chr>   <chr>            <chr>  <chr>    <chr>          <chr>            <chr>     
##  1 A.B.          CRC      Spain      CRC/C/… 07 Feb 2020      "admi… CRC-12C… 024/2017       Adoption of vie… https://j…
##  2 N.R.          CRC      Paraguay   CRC/C/… 03 Feb 2020      "admi… CRC-10-… 030/2017       Adoption of vie… https://j…
##  3 Natalia Ciob… CEDAW    Republic … CEDAW/… 04 Nov 2019      "disc… 11(1)(E… 104/2016       Adoption of vie… https://j…
##  4 El Hasnaoui … CESCR    Spain      E/C.12… 22 Oct 2019      "hous… CESCR-1… 060/2018       Discontinuance … https://j…
##  5 López Albán … CESCR    Spain      E/C.12… 11 Oct 2019      "admi… CESCR-1… 037/2018       Adoption of vie… https://j…
##  6 S. S. R.      CESCR    Spain      E/C.12… 11 Oct 2019      "admi… CESCR-1… 051/2018       Inadmissibility… https://j…
##  7 M. L. B.      CESCR    Luxembourg E/C.12… 11 Oct 2019      "admi… CESCR-8… 020/2017       Inadmissibility… https://j…
##  8 M. T. et al   CESCR    Spain      E/C.12… 11 Oct 2019      ""     CESCR-1… 110/2019       Discontinuance … https://j…
##  9 M. P. y otros CESCR    Spain      E/C.12… 11 Oct 2019      "hous… CESCR-1… 096/2019       Discontinuance … https://j…
## 10 Z. P. y otros CESCR    Spain      E/C.12… 11 Oct 2019      "hous… CESCR-1… 043/2018       Discontinuance … https://j…
## # … with 51 more rows

get_details(xdf$detail_url[10])
## # A tibble: 6 x 5
##   language doc                         docx                        pdf                        html                      
##   <chr>    <chr>                       <chr>                       <chr>                      <chr>                     
## 1 English  http://docstore.ohchr.org/… http://docstore.ohchr.org/… http://docstore.ohchr.org… http://docstore.ohchr.org…
## 2 Français http://docstore.ohchr.org/… http://docstore.ohchr.org/… http://docstore.ohchr.org… http://docstore.ohchr.org…
## 3 Español  http://docstore.ohchr.org/… http://docstore.ohchr.org/… http://docstore.ohchr.org… http://docstore.ohchr.org…
## 4 العربية  http://docstore.ohchr.org/… http://docstore.ohchr.org/… http://docstore.ohchr.org… http://docstore.ohchr.org…
## 5 中文     http://docstore.ohchr.org/… http://docstore.ohchr.org/… http://docstore.ohchr.org… http://docstore.ohchr.org…
## 6 русский  http://docstore.ohchr.org/… http://docstore.ohchr.org/… http://docstore.ohchr.org… http://docstore.ohchr.org…

get_details(2606)
## # A tibble: 3 x 5
##   language doc                         docx                        pdf                        html                      
##   <chr>    <chr>                       <chr>                       <chr>                      <chr>                     
## 1 English  http://docstore.ohchr.org/… http://docstore.ohchr.org/… http://docstore.ohchr.org… http://docstore.ohchr.org…
## 2 Español  http://docstore.ohchr.org/… http://docstore.ohchr.org/… http://docstore.ohchr.org… http://docstore.ohchr.org…
## 3 中文     http://docstore.ohchr.org/… http://docstore.ohchr.org/… http://docstore.ohchr.org… http://docstore.ohchr.org…
```

## unjuris Metrics

| Lang | \# Files |  (%) | LoC |  (%) | Blank lines |  (%) | \# Lines |  (%) |
| :--- | -------: | ---: | --: | ---: | ----------: | ---: | -------: | ---: |
| R    |        6 | 0.86 | 134 | 0.92 |          56 | 0.75 |       51 | 0.63 |
| Rmd  |        1 | 0.14 |  12 | 0.08 |          19 | 0.25 |       30 | 0.37 |

## Code of Conduct

Please note that this project is released with a Contributor Code of
Conduct. By participating in this project you agree to abide by its
terms.
