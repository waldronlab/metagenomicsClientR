## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, message=FALSE, warning=FALSE--------------------------------------
library(metagenomicsClientR)
library(BiocFileCache)
library(dplyr)
library(magrittr)

## -----------------------------------------------------------------------------
cache <- metagenomics_cache()
cache

## -----------------------------------------------------------------------------
x <- get_file_changes(filename_regex = "AsnicarF")
x <- select(x, name, timeCreated, eventTime, event_id, download_url)
x
x$name
x$download_url

## -----------------------------------------------------------------------------
raw_url <- x[x$name == "AsnicarF_2017.tar.gz",]$download_url
url <- gsub("\\?.*$", "", raw_url) # Remove parameters from url

## -----------------------------------------------------------------------------
AsnicarF_2017 <- add_file(rname = "AsnicarF_2017.tar.gz", url)
AsnicarF_2017

