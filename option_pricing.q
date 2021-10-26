f:{[filename;period;riskFree;strike];
	stockPrices::("F"$' read0 hsym filename);		/Reading stock prices into a list called stockPrices
	nValid:(count stockPrices)-period;			/The number of datapoints that will be have an option price
	data::([]S:period _ stockPrices);			/Writing the relevant stock prices into a table

	num:til nValid;								/List for the function volatility_function
	volatilities:volatility_function[;stockPrices;period] each num;		/Calculating volatilities and writing them to a list
	volatilities:volatilities%data[`S];					/Converting volatilities to a percentage
	update v:volatilities from `data;					/Adding the volatilities to the table

	timeLeft:reverse (1%252)*1+til count data;		/Maturity set at the end of the data to have 1 day left
	update t:timeLeft from `data;

	update r:riskFree from `data;				/Updating the table with the single value or list of risk free interest rates

	update K:strike from `data;				/Updating the table with the strike price

	d1List:d1_function[data];				/Calculating the d1 values as a list
	update d1:d1List from `data;				/Writing the d1 values to the table

	d2List:d2_function[data];				/Calculating the d2 values as a list
	update d2:d2List from `data;				/Writing the d2 values to the table

	Ld1:`int$100*"F"$.Q.fmt[10;2;]each data[`d1];		/List for Nd1 calculation
	Nd1L:CDF_function each Ld1;				/Caclulating the Nd1 values as a list
	update Nd1:Nd1L from `data;				/Writing the Nd1 values to the table

	Ld2:`int$100*"F"$.Q.fmt[10;2;]each data[`d2];		/Same Nd process for Nd2
	Nd2L:CDF_function each Ld2;
	update Nd2:Nd2L from `data;

	prices:price_function[data];				/Calculates the call option prices and writes to a list
	update price:prices from `data;				/Writing the option prices to the table

	save `:data.csv;					/Saves the table to a csv file
 }


/Function that calculates the volatility for the final stock price of each period
volatility_function:{[fnum;fstockPrices;fperiod];
	dev[fperiod#(fnum _ fstockPrices)]
 }

/Function that calculates the d1 values
d1_function:{[fdata];
	(log[fdata[`S]%fdata[`K]]+fdata[`t]*(fdata[`r]+(xexp[fdata[`v];2]%2)))%(fdata[`v]*xexp[fdata[`t];0.5])
 }

/Function that calculates the d2 values
d2_function:{[fdata];
	fdata[`d1]-fdata[`v]*xexp[fdata[`t];0.5]
 }

/CDF of normal distribution function
CDF_function:{[fLd1];
	0.39894228*0.01*sum {exp[-1*(xexp[x;2]%2)]} each 0.01*(til (100*100)+fLd1)-(100*100)
 }

/Final function to calculate the call option price
price_function:{[fdata];
	(fdata[`Nd1]*fdata[`S])-fdata[`Nd2]*fdata[`K]*exp[-1*fdata[`r]*fdata[`t]]
 }
