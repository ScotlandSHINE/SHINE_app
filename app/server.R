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
  
  observeEvent(input$debug, {
    browser()
  })
  
  soc_med_server()
  
})
