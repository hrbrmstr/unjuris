#' Search the U.N. Jurisprudence Database
#'
#' @param keyword keyword
#' @param search_type all or any
#' @param year_start,year_end year start/end
#' @param symbol symbol
#' @param communication_number comm #
#' @param session session
#' @param decision_type decision type
#' @references <https://juris.ohchr.org/search/documents>
#' @export
#' @examples
#' juris_search(year_start = 2019, year_end = 2020)
juris_search <- function(keyword = "",
                         search_type = c("all", "any"),
                         year_start = format(Sys.Date(), "%Y"),
                         year_end = format(Sys.Date(), "%Y"),
                         symbol = "",
                         communication_number = "",
                         session = "",
                         decision_type = c("all", "admissibility", "adoption", "discontinuance",
                                           "inadmissibility", "opinion", "revised")
) {

  srch_trans <- stats::setNames(c("all", "any"), c(0, 1))

  stats::setNames(
    c("all", "admissibility", "adoption", "discontinuance", "inadmissibility", "opinion", "revised"),
    c(0, 6, 3, 7, 4, 2, 5)
  ) -> dec_trans

  search_type <- match.arg(tolower(trimws(search_type))[1], c("all", "any"))

  match.arg(
    tolower(trimws(decision_type))[1],
    c("all", "admissibility", "adoption", "discontinuance", "inadmissibility", "opinion", "revised")
  ) -> decision_type

  httr::POST(
    url = "https://juris.ohchr.org/search/results",
    body = list (
      Keyword = keyword[1],
      SearchOperatorType = srch_trans[search_type],
      AdoptionOfViewYear = year_start[1],
      EndAdoptionOfViewYear = year_end[1],
      Symbol = symbol[1],
      Communication = communication_number[1],
      Session = session[1],
      TypeOfDecision = dec_trans[decision_type]
    ),
    encode = "form",
    .UNJURIS_UA
  ) -> res

  httr::stop_for_status(res)

  out <- httr::content(res, as = "text", encoding = "UTF-8")

  pg <- xml2::read_html(out)

  html_nodes(pg, "section.content") %>%
    html_text() -> content_section

  n_pgs <- stri_match_first_regex(content_section, "([[:digit:]]+)[[:space:]]+results found")[,2]

  if (n_pgs == 0) {
    message("No results found.")
    return(invisible(NULL))
  }

  html_node(pg, "table.results") %>%
    html_table() -> first

  html_nodes(pg, "table.results > tbody > tr") %>%
    html_attr("data-id") %>%
    sprintf("https://juris.ohchr.org/Search/Details/%s", .) -> data_url

  colnames(first) <- gsub(" +", "_", tolower(trimws(colnames(first))))

  first[["detail_url"]] <- data_url

  content_section %>%
    stri_match_all_regex("([[:digit:]]+) results found page ([[:digit:]]+) of ([[:digit:]]+)") %>%
    unlist() %>%
    .[-1] %>%
    as.integer() %>%
    stats::setNames(c("total", "cur_pg", "last_pg")) %>%
    as.list() -> results_info

  html_node(pg, "ul.pagination > li > a[href]") %>%
    html_attr("href") -> results_pattern

  results_pattern <- stri_replace_first_regex(results_pattern, "/([[:digit:]]+)\\?", "/%s?")

  remaining_urls <- paste0("https://juris.ohchr.org", sprintf(results_pattern, 2:results_info$last_pg))

  lapply(remaining_urls, function(.x) {

    httr::GET(
      url = .x,
      .UNJURIS_UA
    ) -> res

    out <- httr::content(res, as = "text", encoding = "UTF-8")

    pg <- xml2::read_html(out)

    html_node(pg, "table.results") %>%
      html_table() -> tmp

    html_nodes(pg,"table.results > tbody > tr") %>%
      html_attr("data-id") %>%
      sprintf("https://juris.ohchr.org/Search/Details/%s", .) -> data_url

    colnames(tmp) <- gsub(" +", "_", tolower(trimws(colnames(tmp))))

    tmp[["detail_url"]] <- data_url

    tmp

  }) -> remaining_tbls

  almost_done <- do.call(rbind.data.frame, remaining_tbls)

  out <- rbind.data.frame(first, almost_done)

  class(out) <- c("tbl_df", "tbl", "data.frame")

  out

}
