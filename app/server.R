shinyServer(function(input, output, session) {

    observeEvent(input$prob_soc_med, {updateTabsetPanel(session = session,
                                                        "main_page",
                                                        selected = "Social media use")})
    
    soc_med_serv("soc_med")

})
