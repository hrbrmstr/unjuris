#' Retrieve details (document links) from a jurisprudence record entry
#'
#' @param detail_id_or_url either a number (e.g. `2606`) or a full URL
#'        (i.e. the `detail_url` from a [juris_search()] query result)
#' @return data frame of document links
#' @export
#' @examples
#' xdf <- juris_search(year_start = 2019, year_end = 2020)
#' get_details(xdf$detail_url[1])
#' get_details(2606)
get_details <- function(detail_id_or_url) {

  detail_id_or_url <- detail_id_or_url[1]

  if (!grepl("^http", detail_id_or_url)) {
    detail_id_or_url <- sprintf("https://juris.ohchr.org/Search/Details/%s", detail_id_or_url)
  }

  httr::GET(
    url = detail_id_or_url,
    .UNJURIS_UA
  ) -> res

  httr::stop_for_status(res)

  out <- httr::content(res, as = "text", encoding = "UTF-8")

  pg <- read_html(out)

  table_exists <- html_node(pg, "section#download-listings > table")

  if (length(table_exists) == 0) {

    message(
      sprintf(
        "Please visit %s in your browser as there is no table of documents to return.",
        detail_id_or_url
      )
    )
    return(data.frame(stringsAsFactors=FALSE))

  }

  table_exists %>%
    html_table() %>%
    colnames() %>%
    tolower() %>%
    trimws() -> detail_cols

  html_nodes(pg, "section#download-listings > table > tbody > tr") %>%
    lapply(function(.x) {

      cols <- html_nodes(.x, "td")

      html_nodes(cols[-1], "a") %>%
        html_attr("href") -> links

      as.data.frame(
        as.list(stats::setNames(c(html_text(cols[1]), links), detail_cols)),
        stringsAsFactors = FALSE
      )

    }) -> detail_entries

  detail_entries <- do.call(rbind.data.frame, detail_entries)

  class(detail_entries) <- c("tbl_df", "tbl", "data.frame")

  detail_entries

}
