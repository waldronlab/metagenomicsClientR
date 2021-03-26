#' Cache for metagenomicsClientR
#'
#' @return A BiocFileCache class object
#' @importFrom rappdirs user_cache_dir
#' @importFrom BiocFileCache BiocFileCache
#' @export
#'
#' @examples
metagenomics_cache <- function() {
    cache <- rappdirs::user_cache_dir(appname="metagenomicsClientR")
    metagenomics_cache <- BiocFileCache::BiocFileCache(cache)
    return(metagenomics_cache)
}

#' Add files to metagenomicsClientR
#'
#' This function wraps bcadd from BiocFileCache
#'
#' @param rname A character vector indicating the resource name (file).
#' @param url A character vector indicating the url of the resource
#' @param verbose logical
#'
#' @return Character vector of legnth 1, indicating resource name and path
#' @importFrom BiocFileCache bfcadd
#' @importFrom rappdirs user_cache_dir
#' @importFrom BiocFileCache bfcquery
#' @importFrom BiocFileCache bfcdownload
#' @importFrom BiocFileCache bfcneedsupdate
#' @export
#'
#' @examples
#' 
#' 
#' 
download_file <- function(rname, url, verbose = FALSE) {
    
    cache_path <-  rappdirs::user_cache_dir(appname="metagenomicsClientR")
    if (!isTRUE(dir.exists(cache_path))) {
        stop("No cache exists for metagenomicsClientR. Create a cache with the metagenomicsClientR::metagenomics_cache() function.")
    }
    
    cache <- metagenomics_cache()
    rid <- BiocFileCache::bfcquery(cache, query = rname,
                                   field = "rname", exact = TRUE)$rid
    if (!length(rid)) {
        if (verbose) message(paste("Downloading", rname))
        added_resource <- BiocFileCache::bfcadd(x = cache, 
                                                rname = rname,
                                                fpath = url)
        # rid <- names(added_resource)
        return(added_resource)
    } 
    
    if (!isFALSE(BiocFileCache::bfcneedsupdate(cache, rid))) {
        if ( verbose ) message( paste("File", rname, "present, but needs update."))
        updated_resource <- bfcdownload(cache, rid)
        return(updated_resource)
    }
    
    message(
        paste("A resource named as", rname, 
              "is already present and up to date in metagenomicsClientR's cache with rid", rid)
    )
    
    existing_resource <- cache[[rid]]
    return(existing_resource)
}
