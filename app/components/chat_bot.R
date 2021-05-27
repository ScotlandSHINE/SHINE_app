chat_bot_ui <- function(id = "chat_bot") {
  ns <- NS("chat_bot")
  
  fluidPage(
    
    tags$div(class = "chat_space",
             tags$div(class = "chat_content",
                     uiOutput(ns("chatbox")),
             tags$div(class = "bot_footer",
                      tags$span(class = "bot_name",
                                paste0("@tipzbot", paste0(sample(0:9, 4), collapse = ""))),
                      tags$span(class = "bot_avatar",
    HTML(read_file("app/components/robot.svg"))
                               )),
                      )
    ))
  
}

chat_bot_server <- function(id = "chat_bot") {
  moduleServer(id, function(input, output, session) {
    tips <- read_lines("app/components/chat_bot_data/vars_by_age_tips.txt") %>% sample(., length(.))
    
    first_tip <- reactiveTimer(5000, session)
    
    n_display <- reactiveVal(0)
    
    
    display_tips <- eventReactive(first_tip(), {
      n_display(n_display() + 1)
      tips[1:min(n_display(), length(tips))]
    })
    
    output$chatbox <- renderUI({
      div(class = "chat-bubbles",
          
            map(1:length(display_tips()),
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
      sass::sass_file("app/styles/shine_app.scss")
    )),
    tags$style(
      "
                .chat_space {
                  width: 300px;
                  font-family: consolas, roboto sans, serif;
                  position: fixed;
                  bottom: 10px;
                  right: 10px;
          background-color: #ffefe4;
      border-radius: 5px;
      border: 2px solid grey;
                }
    chat_content {
      position: relative;
    }
                .chat_bubbles {
                  position: relative;
                }
                .talk-bubble {
                	margin: 15px;
                  display: inline-block;
                  position: relative;
                	width: 90%;
                	height: auto;
                	background-color: lightblue;
                  border-radius: 30px;
                	-webkit-border-radius: 30px;
                	-moz-border-radius: 30px;
                }
                .talktext{
                  padding: 1em;
                	text-align: left;
                  line-height: 1.5em;
                }
                .talktext p{
                  /* remove webkit p margins */
                  -webkit-margin-before: 0em;
                  -webkit-margin-after: 0em;
                }
                .talk-bubble:after{
                  content: ' ';
                  position: absolute;
                  width: 0;
                  height: 0;
                  left: auto;
                  right: 38px;
                  bottom: -20px;
                  border: 12px solid;
                  border-color: lightblue lightblue transparent transparent;
                }
                .visible-box {
                  height: auto;
                  visibility: visible;
                }
      .bot_footer {
        margin-top: 10px;
        height: 50px;
      }
      .bot_avatar {
        float: right;
        margin-right: 20px;
      }
      .bot_name {
        font-family: Times, Times New Roman, serif;
        font-style: italic;
        font-size: 1.5em;
        margin-left: 20px;
        line-height: 50px;
      }
  "
    ),
    chat_bot_ui()
  )
  
  server <- function(input, output, session) {
    chat_bot_server()
  }
  shinyApp(ui, server)
}


chat_bot_app()

