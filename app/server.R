shinyServer(function(input, output, session) {
  
  observeEvent(input$home_logo, {
    updateTabsetPanel(session = session,
                      "main_page",
                      selected = "Home")
  })
  
  observeEvent(input$prob_soc_med, {
    soc_med_data()
    updateTabsetPanel(session = session,
                      "main_page",
                      selected = "Social media use")
  })
  
  observeEvent(input$vars_by_age, {
    vars_by_age_data()
    chat_bot_server("vars_by_age_bot")
    updateTabsetPanel(session = session,
                      "main_page",
                      selected = "Young people's health")
  })
  
  # observeEvent(input$debug, {
  #   browser()
  # })
  
  soc_med_server()
  
  vars_by_age_server()
})
