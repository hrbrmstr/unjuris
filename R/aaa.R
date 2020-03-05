httr::user_agent(sprintf(
  "unjuris R package %s; (<https://gitlab.com/hrbrmstr/unjuris>)",
  utils::packageVersion("unjuris")
)) -> .UNJURIS_UA