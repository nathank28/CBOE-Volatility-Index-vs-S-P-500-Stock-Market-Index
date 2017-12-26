CBOE Volatility Index (VIX) vs S&P500 Stock Market Index

Developers: Jonathan Avila, Nathan Guo, Noah Weiner

This model explores how we can determine a relationship between the VIX “fear gauge” and the S&P stock market index. In general, comparisons between different Probe and Adjust operations can be made by running simulations using the operation created by Steven O. Kimbrough and by using the modified operations which have been provided in this program. Information regarding the standard model of Probe and Adjust are provided by SOK in the coursework of OIDD 319.

Kimbrough, Steven O. (2007). Monopoly Probe and Adjust model.
http://opim-sky.wharton.upenn.edu/~sok/agebook/applications/nlogo/monopolyProbeAndAdjust. nlogo  University of Pennsylvania, Philadelphia, PA 19004, USA.

In this program, certain variables and functionality have been added, modified, or removed entirely due to relevance to the topic at hand.The VIX, also known as the CBOE Volatility Index, is the premier “fear gauge” of the stock market. In layman’s terms, the higher the tentative value of the VIX, the higher the unpredictability of the stock market. This means that the S&P, for example, could potentially crash or boom. The term “fear gauge” is often disputed because of the potential boom. In essence, the VIX is heavily correlated with the dynamism of the stock market.
The program is simplified in the context of what’s being pursued. In the SOK model, standard economic formulas are used to compute maximal revenue, which is determined by a dynamic monopoly price. The simulation must “chase” this price to receive maximum revenue. In our model, the simulation must chase the S&P value, and this is done without using any economic formulas, which means it’s a relatively straightforward process and the code used to construct this program is not difficult to follow.

Note that you will have to change the directory in the code so that the NetLogo program can find the file:
"[INSERT REST OF DIRECTORY HERE]/oiddvix/FINAL-RAW.csv"

If we have dynamic delta on, this means that the program will read each successive VIX value on the excel file provided entitled  FINAL-CSV.csv . The corresponding S&P values are picked up in the same manner.If  dynamic-delta  is off, then the VIX values picked up by the Netlogo CSV parser will be ignored. It’s merely just the difference between using the VIX values and not using them. We use the function  daRevenue  from SOK’s Probe and Adjust to calculate the absolute difference of the probe and the current S&P value. If the probe is above the  currentPrice , the difference goes into the up-data list. If the probe is below the c  urrentPrice , the difference goes into the down-data list.

Once the epoch is over we find which of the two lists has the smaller mean difference and add either + epsilon  or - epsilon  to the  currentPrice . We then update the average distance between the  currentPrice  and the current S&P value.
If dynamic epsilon is on (dynamic-delta MUST be on for this), then we keep track of the VIX values for each epoch, entitled  vixValues . Once the epoch is, we then update  epsilon  to be dynamic-epsilon-coefficient * mean vixValues.  We then update the  currentPrice  as we did before. If dynamic-delta is not on, then the epsilon used will simply be a static quantity, the chosen  delta * dynamic-epsilon-coefficient.

If repeated sampling is on, their our new probe will be whatever the currentPrice is, plus or minus delta; the probe will adjust towards the direction (either higher or lower) of the true value. If off, our new probe will range uniformly between currentPrice plus and minus delta, so the confidence interval is larger.

After each epoch we update the  avg-distance,  the average distance between  currentPrice  and the  sp  (the S&P price at the tic).

The data used has two columns: one for the current S&P value, and another for the respective VIX value at a given tic. The data used for our investigation has the opening, daily average and closing values for a given day for each index.

Extending the model:
This simple interface could be applied to other data, to investigate other market relationships like the commodities market. As well, one could alter the model to attempt to predict both ways: have the S&P index and the VIX index inform simultaneously predictions of the other index. The data used could be read in real time, rather than randomly generated or uploaded via CSV file. As well, other summary statistics such as correlation could be calculated and displayed via the interface, to provide another means of judging the model.

Credits and References
The original Probe and Adjust model was created and written by Steven O. Kimbrough: kimbrough@wharton.upenn.edu
Modifications were made by the team with permission of SOK

Supporting Data:
Supporting data can be found in Supporting_Data.xslx!
It is simply the average differences recorded for each tic for the 3 scenarios. The avg. avg. differences is the singular value found on all 3 tabs. We can see that dynamic epsilon + dynamic delta does the best!
