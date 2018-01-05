##  Shiny Debugging Panel

inputPanel(textInput(inputId = "debugger","Print Console"),actionButton("run", "Execute"))

observeEvent(input$run,{
  output$debug <- renderPrint(eval(parse(text=input$debugger)))
})

htmlOutput("debug")
