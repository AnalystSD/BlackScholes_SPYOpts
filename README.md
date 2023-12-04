# BlackScholes_SPYOpts

This project just showcases that I'm able to use R Programming on Rstudio/Jupyter/Colab but I also am able to apply it to mathematical/finance models such as Black Scholes, and much more if needed from my studies.
The data for this script can be found in the code .
The first chunk of code shows how I webscraped the data from Yahoo, cleaned it, put it into a dataframe and csv. The code also allows a choice of either scraping calls or puts.
The second chunk of code shows how I used another package that better gets the price of the stock, and then allows me to have all the data I need for the next chunk.
The third chunk of code, is where the actual variables used for the Formula section is placed. The black scholes formula calculates a fair market value of each option due in their time. (December 29 in the code, since today was the beggining of december, 2023). This also put each of those values into a vector, which turned it into a column in the table where we have stored the SPY Call option data.
From this we can see which stock optsions have been bringing in the most volume, and interest, and seeing which ones have a better market value.
Also, please read the notes in the R code itself too to know which chunk is which.
