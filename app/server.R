shinyServer(function(input, output, session) {
  observeEvent(input$prob_soc_med, {
    soc_med_data()
    updateTabsetPanel(session = session,
                      "main_page",
                      selected = "Social media use")
  })
  
  
  soc_med_server()
  
})
