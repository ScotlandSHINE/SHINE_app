#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    observeEvent(input$prob_soc_med, {updateTabsetPanel(session = session,
                                                        "main_page",
                                                        selected = "Social media use")})
    
    soc_med_func(input, output, session)

})
