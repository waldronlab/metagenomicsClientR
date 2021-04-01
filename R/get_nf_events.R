utils::globalVariables(c("trace", "command_line", "script", "utc_time" ))

#' Check if value is NULL
#' 
#' Helper function for get_nf_events()
#'
#'
#' @param x an object to be tested
#'
#' @return logical
#' @export
#'
#' @examples
check_null <- function(x) {
    
    if (is.null(x)) {
        NA
    } else {
        x
    }
}

#' Get nextflow events
#'
#' 
#' @inheritParams get_files_changes
#'
#' @return tibble
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom tibble tibble
#' @importFrom tidyr unnest_wider
#' @importFrom purrr map_chr
#' @importFrom magrittr %>%
#' @importFrom readr parse_datetime
#' @export
#'
#' @examples
#' 
#'  # Get the first 100 file changes
#' x <- get_nf_events(limit = 100)
#' x
#' 
get_nf_events <- function(
    limit = 100,
    offset = 0
) {
    # Get response
    resp <- metagenomics_client$ListNextflowEventsNextflowEventsGet(
        limit = limit,
        offset = offset
    )
    resp_hits <- resp$toJSON()$hits
    
    # parsing
    x <- tibble::tibble(resp_hits) %>% 
        tidyr::unnest_wider(resp_hits)
    y <- x %>% 
        dplyr::mutate(
            command_line = purrr::map_chr(resp$hits, ~check_null(.x$metadata$workflow$commandLine)),
            metadata = purrr::map_chr(resp$hits, ~check_null(.x$metadata$parameters$metadata_tsv)),
            script = purrr::map_chr(resp$hits, ~check_null(.x$trace$script)),
            accessions = gsub(".*accessions: (.*\\]).*", "\\1", script),
            rowhash = gsub(".*rowhash: (.*)....sampleinfo.txt.*", "\\1", script),
            sample = gsub(".*sample: (.*).*\naccessions:.*$", "\\1" , script),
            utc_time = readr::parse_datetime(utc_time, "%Y-%m-%dT%H:%M:%S+%z")
        ) %>% 
        dplyr::select(-trace, -command_line, -script)
    return(y)
}
