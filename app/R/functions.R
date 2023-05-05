#' Generate a landing page main box
#' 
#' @param title_box The title to display in the box
#' @param image_name The `.png` image name stored in the `images/` folder to use as the icon (leaving off `.png`)
#' @param button_name A unique id to reference the button in other parts of the app
#' @param description The short text to introduce the component
lp_main_box <-
  function(title_box,
           image_name,
           button_name,
           description) {
    div(
      class = "landing-page-box",
      div(title_box, class = "landing-page-box-title"),
      div(description, class = "landing-page-box-description"),
      div(
        class = "landing-page-icon",
        style = paste0(
          "background-image: url(images/",
          gsub("^(.*)\\.png", "\\1", image_name),
          ".png);
          background-size: auto 100%; background-position: center; background-repeat: no-repeat; margin-bottom: 5px; "
        )
      ),
      actionButton(button_name, NULL, class = "landing-page-button")
    )
  }


#' Load UI, Server and Landing Page Box objects for a component
#' 
#' @param component The name of the component to load

load_component <- function(component) {
  objects <- source(paste0("components/", gsub("(.*)\\.R", "\\1", component), ".R"), local = TRUE)$value
  objects
}

#' Convert points to pixels
#' 
#' @param size Size in pixels

pts <- function(size) {
  return(size * 5 / 14)
}
