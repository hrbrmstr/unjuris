#' Search the U.N. Jurisprudence Database
#'
#' The jurisprudence database is intended to be a single source of the human rights recommendations
#' and findings issued by all above committees in their work on individual cases. It enables the general
#' public, governments, civil society organizations, United Nations partners and international regional
#' mechanisms to research the vast body of legal interpretation of international human rights law as
#' it has evolved over the past years. Tools are provided to search and retrieve search results from
#' the datbase.
#'
#' @md
#' @name unjuris
#' @keywords internal
#' @author Bob Rudis (bob@@rud.is)
#' @import httr stringi
#' @importFrom xml2 read_html
#' @importFrom rvest html_node html_nodes html_text html_attr html_table
#' @importFrom jsonlite fromJSON
#' @importFrom stats setNames
"_PACKAGE"
