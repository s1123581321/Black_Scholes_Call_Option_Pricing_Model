# Black_Scholes_Call_Option_Pricing_Model
A Black Scholes call equity option pricing model I coded in q.
Note the data file must be only daily stock price on each line of the file and nothing more.
I have included some example daily stock data for Hargreaves Lansdown (HL).
I have also included an example of the stock price and option price for the example data with a period of 180 days, a constant risk free interest rate of 2% and a strike price of £14.
The maturity is assumed to be the day after the end of the data provided.
The code will output a csv file with all the quantities calculated including the call option price for each data point.
To run the code from a command line in a q environment execute the following commands:
\l option_pricing.q
f `<filename>;<time period for variance>;<risk free interest rate>;<strike price>
