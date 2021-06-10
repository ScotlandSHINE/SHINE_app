shinyServer(function(input, output, session) {
  
  observeEvent(input$home_logo, {
    updateTabsetPanel(session = session,
                      "main_page",
                      selected = "Home")
  })
  # 
  # observeEvent(input$prob_soc_med, {
  #   soc_med_data()
  #   updateTabsetPanel(session = session,
  #                     "main_page",
  #                     selected = "Social media use")
  # })
  
  observeEvent(input$vars_by_age, {
    load_vars_by_age_data()
    updateTabsetPanel(session = session,
                      "main_page",
                      selected = "Young people's health")
  })
  
  observeEvent(input$influences, {
    load_influences_data()
    updateTabsetPanel(session = session,
                      "main_page",
                      selected = "Influences on health")
  })
  
  # observeEvent(input$debug, {
  #   browser()
  # })
  
  
  vars_by_age_server()
  
  influences_server()
})
