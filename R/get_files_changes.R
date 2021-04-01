utils::globalVariables(c("kind", "bucket", "metageneration", "contentType",
                         "eventType"))
#' Get list of file changes as tibble
#'
#' TODO
#'
#' @param limit A numeric vector of length 1 indicating the number of rows that must be returned.
#' @param offset TODO
#' @param start_date TODO
#' @param end_date TODO
#' @param filename_regex TODO
#'
#' @return tibble
#' @importFrom dplyr bind_rows
#' @importFrom magrittr %>%
#' @importFrom tibble as_tibble
#' @importFrom purrr map_at
#' @importFrom readr parse_datetime
#' @export
#'
#' @examples
#' # Get the first 10 file changes
#' x <- get_files_changes(limit = 10)
#' x
#'
get_files_changes <- function(
    limit = 100,
    offset = 0,
    start_date = NULL,
    end_date = NULL,
    filename_regex = NULL
) {
    resp <- metagenomics_client$ListFileEventsFilesChangesGet(
        limit = limit,
        offset = offset,
        start.date = start_date,
        end.date = end_date,
        filename.regex = filename_regex
    )
    hit_list <- resp$toJSON()$hits
    df <- dplyr::bind_rows(hit_list) %>%
        dplyr::select(-kind, -bucket, -metageneration,
                      -contentType, -eventType)
    df <- purrr::map_at(df,
        c("timeCreated", "updated", "eventTime"),
        ~readr::parse_datetime(.x), "%Y-%m-%dT%H:%M:%S+%z") %>% 
        tibble::as_tibble()
    return(df)
}
