% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/merge_and_stack.R
\name{gt_merge_stack}
\alias{gt_merge_stack}
\title{Merge and stack text from two columns in \code{gt}}
\usage{
gt_merge_stack(gt_object, col1, col2)
}
\arguments{
\item{gt_object}{An existing gt table object of class \code{gt_tbl}}

\item{col1}{The column to stack on top. Will be converted to all caps, with black and bold text.}

\item{col2}{The column to merge and place below. Will be smaller and dark grey.}
}
\value{
An object of class \code{gt_tbl}.
}
\description{
The \code{gt_merge_stack()} function takes an existing \code{gt} table and merges
column 1 and column 2, stacking column 1's text on top of column 2's.
Top text is in all caps with black bold text, while the lower text is smaller
and dark grey.
}
\section{Figures}{

\if{html}{\figure{merge-stack.png}{options: width=50\%}}
}

\section{Function ID}{

1-4
}

\examples{
library(gt)
team_df <- readRDS(url("https://github.com/nflverse/nflfastR-data/raw/master/teams_colors_logos.rds"))

stacked_tab <- team_df \%>\%
 dplyr::select(team_nick, team_abbr, team_conf, team_division, team_wordmark) \%>\%
 head(8) \%>\%
 gt(groupname_col = "team_conf") \%>\%
 gt_merge_stack(col1 = team_nick, col2 = team_division) \%>\%
 gt_img_rows(team_wordmark)

}
\seealso{
Other Utilities: 
\code{\link{add_text_img}()},
\code{\link{fa_icon_repeat}()},
\code{\link{fmt_pad_num}()},
\code{\link{fmt_symbol_first}()},
\code{\link{gt_add_divider}()},
\code{\link{gt_add_fa_icons}()},
\code{\link{gt_highlight_cols}()},
\code{\link{gt_highlight_rows}()},
\code{\link{gt_img_rows}()},
\code{\link{pad_fn}()},
\code{\link{tab_style_by_grp}()}
}
\concept{Utilities}
