#' Read a single tsv file
#'
#' Helper function for the \code{matrix_from_dir} function.
#'
#' @param x String indicating full path to a tsv file.
#'
#' @return tibble
#' @importFrom readr read_tsv
#' @importFrom dplyr bind_cols
#' @importFrom dplyr select_if
#' @export
#'
#' @examples
#'  
#' 
read_file <- function(x) {
    
    column_names <- c("Feature", basename(gsub(".tsv$", "", x)))
    df <- readr::read_tsv(x, col_names = FALSE, comment = "#")
    df <- dplyr::bind_cols(df[1], dplyr::select_if(df, is.double))
    names(df) <- column_names
    return(df)
    
}

#' Read files from a directory and merge them into a matrix
#' 
#' 
#' \code{matrix_from_dir} reads all tsv files from a  directory and merge them into a numeric matrix. The first column of the tsv files must contain the names of the features. A single column of type numeric containing the values for each feature is expected.
#'
#' @param dir_path String indicating the full path to a directory.
#'
#' @return matrix
#' @importFrom purrr map
#' @importFrom purrr reduce
#' @importFrom dplyr full_join
#' @export
#'
#' @examples
matrix_from_dir <- function(dir_path) {
    
    filenames_path <- list.files(dir_path, full.names = TRUE)
    list_of_tsvs <- purrr::map(filenames_path, ~read_file(.x)) # ?read_file
    df <- purrr::reduce(list_of_tsvs, dplyr::full_join)
    mat <- as.matrix(df[,-1])
    rownames(mat) <- df[[1]]
    mat[is.na(mat)] <- 0
    # mat <- as(mat, "dgTMatrix")
    return(mat)
    
}



















# matrix_from_dir <- function(dir_path) {
#     
#     list_of_files <- list.files(dir_path)
#     names_no_tsv <- gsub(".tsv$", "", list_of_files)
#     list_of_tsvs <- lapply(list_of_files, function(x) readr::read_tsv(paste0(dir_path, "/", x)))
#     names(list_of_tsvs) <- names_no_tsv
#     df <- purrr::reduce(list_of_tsvs, dplyr::full_join)
#     mat <- as.matrix(df[,-1])
#     row_names <- df[[1]]
#     rownames(mat) <- row_names
#     colnames(mat) <- names_no_tsv
#     mat[is.na(mat)] <- 0
#     return(mat)
#     
# }