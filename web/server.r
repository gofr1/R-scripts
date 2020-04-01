library(data.table)
library(ggplot2)

shinyServer(function(input, output, clientData, session) {
	
	output$option_price <- renderText({
		
		put_call = switch(input$put_call, `Call` = 1, `Put` = -1)
		
		time_to_maturity = as.numeric(as.Date(input$maturity_date) - Sys.Date()) / 365.25

		d1 = (log(input$spot_price / input$strike_price) + (input$risk_free_rate + input$price_volatility^2/2)*time_to_maturity) / (input$price_volatility * sqrt(time_to_maturity))
		d2 = d1 - input$price_volatility * sqrt(time_to_maturity)

		res = put_call * (input$spot_price * pnorm(put_call * d1) - input$strike_price * exp(-input$risk_free_rate * time_to_maturity) * pnorm(put_call * d2))
		
	})
	
	output$hist_prices <- renderDataTable({
	
		prices = data.table(
			`Date` = seq(from = as.Date("2015-01-21"), to = as.Date("2018-01-01"), by = 1L),
			`Open Price` = runif(1e3),
			`Close Price` = runif(1e3)
		)
	
	}, options = list(pageLength = 10))
	
	output$sim_prices <- renderPlot({
	
		prices = data.table(
			`Date` = seq(from = as.Date("2015-01-21"), length.out = 1000, by = 1L),
			`Open Price` = sin(runif(1e3)),
			`Close Price` = cos(runif(1e3))
		)
	
		ggplot(prices) + 
			layer(geom = "line", mapping = aes(x = `Date`, y = `Open Price`), position = "identity", stat = "identity", params = list(color = "red")) +
			layer(geom = "point", mapping = aes(x = `Date`, y = `Close Price`), position = "identity", stat = "identity", params = list(color = "green"))
	
	})

	session$onSessionEnded(function() {
		stopApp()
	})

})
