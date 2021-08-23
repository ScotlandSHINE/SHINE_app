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
    # load_vars_by_age_data()
    # load_influences_data()
    # time_changes_data()
    # compare_countries_data()
  
  observeEvent(input$vars_by_age, {
    updateTabsetPanel(session = session,
                      "main_page",
                      selected = "Young people's health")
  })
  
  observeEvent(input$influences, {
    updateTabsetPanel(session = session,
                      "main_page",
                      selected = "Influences on health")
  })

  observeEvent(input$time_changes, {
    updateTabsetPanel(session = session,
                      "main_page",
                      selected = "Changes over time")
  })

    observeEvent(input$compare_countries, {
    updateTabsetPanel(session = session,
                      "main_page",
                      selected = "Comparing with other countries")
  })
  
  # observeEvent(input$debug, {
  #   browser()
  # })
  
  
  vars_by_age_server()
  
  influences_server()
  
  time_changes_server()
  
  compare_countries_server()
})
