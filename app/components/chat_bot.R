chat_bot_ui <- function(id = "chat_bot") {
  ns <- NS("chat_bot")

  fluidPage(tags$div(
    class = "chat_space",
    tags$div(
      class = "chat_content",
      uiOutput(ns("chatbox")),
      tags$div(
        class = "bot_footer",
        tags$span(class = "bot_name",
                  paste0(
                    "@tipzbot", paste0(sample(0:9, 4), collapse = "")
                  )),
        tags$span(class = "bot_avatar",
                  HTML(
                    read_file("components/robot.svg")
                  ))
      ),
    )
  ))

}

chat_bot_server <- function(id = "chat_bot") {
  moduleServer(id, function(input, output, session) {
    tips <-
      read_lines("components/chat_bot_data/vars_by_age_tips.txt") %>% sample()

    first_tip <- reactiveTimer(30000, session)

    n_display <- reactiveVal(0)


    display_tips <- eventReactive(first_tip(), {
      if (n_display() == 0) {
      n_display(n_display() + 1)
        return("Hi, im @tipzbot. I'll try to give you ideas as you explore the data!")
      }
      tips_out <- tips[seq_len(min(n_display(), length(tips)))]
      n_display(n_display() + 1)
      tips_out
    })
    
    output$chatbox <- renderUI({
      div(class = "chat-bubbles",
          
          map(
            seq_along(display_tips()),
            ~
              tags$div(
                class = "talk-bubble",
                id = paste0("ttext", .x),
                tags$div(class = "talktext",
                         display_tips()[.x])
              )
          ))
      
      
      
    })
    
  })
}

chat_bot_app <- function() {
  ui <- tagList(
    tags$style(sass::sass(
      sass::sass_file("styles/shine_app.scss")
    )),
  chat_bot_ui()
  )
  
  server <- function(input, output, session) {
    chat_bot_server()
  }
  shinyApp(ui, server)
}


chat_bot_app()

list(chat_bot_ui, chat_bot_server)
