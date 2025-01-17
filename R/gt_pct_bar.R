#' Add a percent stacked barchart in place of existing data.
#' @description
#' The `gt_plt_bar_stack` function takes an existing `gt_tbl` object and
#' converts the existing values into a percent stacked barchart. The bar chart
#' will represent either 2 or 3 user-specified values per row, and requires
#' a list column ahead of time. The palette and labels need to be equal length.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column wherein the percent stacked barchart should replace existing data. Note that the data *must* be represented as a list of numeric values ahead of time.
#' @param palette A color palette of length 2 or 3, represented either by hex colors (`"#ff4343"`) or named colors (`"red"`).
#' @param labels A vector of strings of length 2 or 3, representing the labels for the bar chart, will be colored according to the palette as well.
#' @param width An integer representing the width of the bar chart in pixels.
#' @return An object of class `gt_tbl`.
#' @importFrom gt %>%
#' @export
#' @import gt rlang ggplot2
#' @importFrom glue glue
#' @family Plotting
#' @section Function ID:
#' 1-5
#' @examples
#' library(gt)
#' library(dplyr)
#'
#' ex_df <- dplyr::tibble(
#'   x = c("Example 1","Example 1",
#'         "Example 1","Example 2","Example 2","Example 2",
#'         "Example 3","Example 3","Example 3","Example 4","Example 4",
#'         "Example 4"),
#'   measure = c("Measure 1","Measure 2",
#'               "Measure 3","Measure 1","Measure 2","Measure 3",
#'               "Measure 1","Measure 2","Measure 3","Measure 1","Measure 2",
#'               "Measure 3"),
#'   data = c(30, 20, 50, 30, 30, 40, 30, 40, 30, 30, 50, 20)
#' )
#'
#'
#' tab_df <- ex_df %>%
#'   group_by(x) %>%
#'   summarise(list_data = list(data))
#'
#' tab_df
#'
#' ex_tab <- tab_df %>%
#'   gt() %>%
#'   gt_plt_bar_stack(column = list_data)
#'
#' @section Figures:
#' \if{html}{\figure{plt-bar-stack.png}{options: width=70\%}}

gt_plt_bar_stack <- function(
  gt_object,
  column = NULL,
  palette = c("#ff4343", "#bfbfbf", "#0a1c2b"),
  labels = c("Group 1", "Group 2", "Group 3"),
  width = 70
) {
  stopifnot("There must be 2 or 3 labels" = (length(labels) %in% c(2:3)))
  stopifnot("There must be 2 or 3 colors in the palette" = (length(palette) %in% c(2:3)))

  tab_out <- text_transform(
    gt_object,
    locations = cells_body({{ column }}),
    fn = function(x) {
      bar_fx <- function(x_val) {
        col_pal <- palette

        vals <- strsplit(x_val, split = ", ") %>%
          unlist() %>%
          as.double()

        n_val <- length(vals)

        stopifnot("There must be 2 or 3 values" = (n_val %in% c(2, 3)))

        col_fill <- if (n_val == 2) {
          c(1, 3)
        } else {
          c(1:3)
        }

        df_in <- dplyr::tibble(
          x = vals,
          y = rep(1, n_val),
          fill = col_pal[col_fill]
        )

        plot_out <- df_in %>%
          ggplot(aes(x = x, y = factor(y), fill = I(fill), group = y)) +
          geom_col(position = "fill", color = "white", size = 1) +
          geom_text(
            aes(label = x),
            hjust = 0.5,
            size = 3,
            family = "mono",
            position = position_fill(vjust = .5),
            color = "white"
          ) +
          scale_x_continuous(expand = c(0, 0)) +
          scale_y_discrete(expand = c(0, 0)) +
          theme_void() +
          theme(legend.position = "none", plot.margin = unit(rep(0, 4), "pt"))

        out_name <- file.path(tempfile(
          pattern = "file",
          tmpdir = tempdir(),
          fileext = ".svg"
        ))

        ggsave(
          out_name,
          plot = plot_out,
          dpi = 30,
          height = 6,
          width = width,
          units = "px"
        )

        img_plot <- readLines(out_name) %>%
          paste0(collapse = "") %>%
          gt::html()

        on.exit(file.remove(out_name))

        img_plot
      }

      tab_built <- lapply(X = x, FUN = bar_fx)
    }
  )

  label_built <- if (length(labels) == 2) {
    lab_pal1 <- palette[1]
    lab_pal2 <- palette[2]

    lab1 <- labels[1]
    lab2 <- labels[2]

    glue::glue(
      "<span style='color:{lab_pal1}'><b>{lab1}</b></span>",
      "||",
      "<span style='color:{lab_pal2}'><b>{lab2}</b></span>"
    ) %>% gt::html()
  } else {
    lab_pal1 <- palette[1]
    lab_pal2 <- palette[2]
    lab_pal3 <- palette[3]

    lab1 <- labels[1]
    lab2 <- labels[2]
    lab3 <- labels[3]

    glue::glue(
      "<span style='color:{lab_pal1}'><b>{lab1}</b></span>",
      "||",
      "<span style='color:{lab_pal2}'><b>{lab2}</b></span>",
      "||",
      "<span style='color:{lab_pal3}'><b>{lab3}</b></span>"
    ) %>% gt::html()
  }

  var_sym <- rlang::enquo(column)
  var_bare <- rlang::as_label(var_sym)

  # Get the columns supplied in `columns` as a character vector
  tab_out <-
    gt:::dt_boxhead_edit_column_label(
      data = tab_out,
      var = var_bare,
      column_label = label_built
    )
  tab_out
}
