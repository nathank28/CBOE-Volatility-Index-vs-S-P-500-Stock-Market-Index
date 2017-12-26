extensions [csv]

globals [pstar current-price price-intercept m-price epochOver
         up-data down-data total-revenue probe-count ;episodeLength
         quantityIntercept
         up-prices down-prices ;monop-prices
         monop-quantities

         m-up-prices m-dn-prices m-up-revs m-dn-revs
         up-as down-as currentPrice m-quantity initial-m-quantity initial-m-price initial-price
         version ; CVS (or Subversion) version string
  csv data

  array
  sp
  vix
  con
  result
  trueDelta
  avg-difference
  take-difference
  numEpochs
  vixValues
]

to setup
  clear-all
set version "$Id: MonopolyProbeAndAdjust.nlogo 4082 2014-03-20 00:40:40Z sok $"
if (daRandomSeed != "system clock")
  [random-seed daRandomSeed]

set currentPrice initialPrice



  ;We do not need anything BELOW VVVVVV
;set price-intercept daPriceIntercept(quantityIntercept)(dSlope)
;set current-price (price-intercept - (dSlope * initialPrice))
;set initial-price current-price
;set m-quantity daMQuantity ; (price-intercept / ( 2 * slope)) ; set the monopoly quantity
;set initial-m-quantity m-quantity
;set initial-m-price (price-intercept - (dSlope * initial-m-quantity))
  ;We do not need anything ABOVE ^^^^^^




file-close-all
file-open "/Users/ncwphilly/Desktop/oidd project/FINAL-RAW.csv"
set epochOver false
set up-data []
set up-prices []
  set vixValues []



set down-data []

  set up-data lput 0 up-data
  set down-data lput 0 down-data
set down-prices []
set monop-quantities []
set m-up-prices []
set m-dn-prices []
set m-up-revs []
set m-dn-revs []
set up-as []
set down-as []
set total-revenue 0
set probe-count 0

  set numEpochs 0


end

to go
let probe 0
  let myDifference 0


while [not epochOver]
[


    if file-at-end? [stop]

    set data csv:from-row file-read-line
      ;  output-print first data
      ; output-print last data

    set sp ( (first data))
    set vix ((last data))


    ifelse (vix-on)
    [
     set trueDelta vix

    ]
    [
      set trueDelta delta
    ]
    set vixValues lput trueDelta vixValues

  ;  output-print trueDelta

; repeated-sampling. If On, our new probe is currentPrice plus or minus delta.
; If Off, our new probe ranges uniformly between currentPrice plus and minus delta.
ifelse (repeated-sampling)
[set probe (random-float 1)
 ifelse (probe <= 0.5)
   [set probe currentPrice - trueDelta]
   [set probe currentPrice + trueDelta]] ; end of if in ifelse(repeated-sampling)
[set probe (random-float 2 * trueDelta) - trueDelta + currentPrice] ; end of ifelse repeated-sampling



 set probe-count probe-count + 1
 set myDifference daRevenue(probe)
 set total-revenue total-revenue + myDifference ; daRevenue(probe)
 ifelse (probe >= currentPrice)
   [set up-data lput myDifference up-data]
   [set down-data lput myDifference down-data]

 if (fine-grained)
   [plot-quantities(currentPrice)(sp)]

; if (length up-data > episodeLength and length down-data > episodeLength)
 if (length up-data + length down-data >= epochLength)
   [set epochOver true]

] ; end of do while

if (epochOver) [

  if (dynamic-epsilon)
      [set epsilon dynamic-epsilon-coefficient * (mean vixValues)]


ifelse (mean up-data <= mean down-data)
  [set currentPrice (currentPrice + epsilon)]
  [set currentPrice (currentPrice - epsilon)]

  if (not fine-grained)
    [plot-quantities(currentPrice)(sp)]

 set epochOver false
  set up-data []
  set down-data []
  set up-data lput 0 up-data
  set down-data lput 0 down-data
  set numEpochs numEpochs + 1
  set avg-difference (((avg-difference * (numEpochs - 1) + daRevenue(currentPrice)) / numEpochs))
    set vixValues []

  ] ; end of if(epochOver)


end


to plot-quantity-price [daPrice]
set-current-plot "quantity-price"
clear-plot
set-plot-y-range 0 price-intercept
set-plot-x-range 0 quantityIntercept
set-current-plot-pen "Demand Curve"
plot-pen-up
plotxy 0 price-intercept
plot-pen-down
plotxy quantityIntercept 0
set-current-plot-pen "Monopoly Quantity"
plot-pen-up
plotxy m-quantity 0
plot-pen-down
plotxy m-quantity m-price
set-current-plot-pen "Monopoly Price"
plot-pen-up
plotxy 0 m-price
plot-pen-down
plotxy m-quantity m-price
end

to-report daRevenue [daQuantity] ; [daPrice]
  let difference 0

  set difference abs (sp - daQuantity)
  report difference
end

to-report daPriceIntercept [q-intercept daSlope]
  set price-intercept (q-intercept * daSlope)
  report price-intercept
end



to-report getMPrice [da-price-intercept da-slope da-m-quantity]
  report (da-price-intercept - (da-slope * da-m-quantity))
end

to plot-quantities [daQuantity mono-quant]
set-current-plot "S&P Price vs. Estimation"
set-current-plot-pen "Current Price"
plot daQuantity
set-current-plot-pen "S&P Price"
plot mono-quant
end


to debug
let probe 0


set probe (random-float 2 * trueDelta) - trueDelta + current-price
show (word "a = "  quantityIntercept)
show (word "price intercept = "  price-intercept)

show (word "monopoly price = "  m-price)

show (word "monopoly revenue = "  daRevenue(m-price) )
show (word "current-price = "  current-price)
show (word "probe = "  probe)
show (word "probe revenue = "  daRevenue(probe))
end
@#$#@#$#@
GRAPHICS-WINDOW
350
10
535
196
-1
-1
5.06
1
10
1
1
1
0
1
1
1
-17
17
-17
17
0
0
1
ticks
30.0

BUTTON
9
10
75
43
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
467
378
630
423
Current Estimation Price
currentPrice
3
1
11

MONITOR
467
427
562
472
Current Price
currentPrice
3
1
11

SLIDER
9
73
181
106
delta
delta
18
80
18.0
0.1
1
NIL
HORIZONTAL

SLIDER
9
107
181
140
epsilon
epsilon
4
20
10.080000000000002
0.1
1
NIL
HORIZONTAL

BUTTON
102
10
165
43
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
181
10
979
280
S&P Price vs. Estimation
NIL
NIL
0.0
1000.0
400.0
500.0
true
true
"" ""
PENS
"Current Price" 1.0 0 -2674135 true "" ""
"S&P Price" 1.0 0 -16777216 true "" ""

SWITCH
10
207
144
240
fine-grained
fine-grained
0
1
-1000

SWITCH
11
372
185
405
repeated-sampling
repeated-sampling
1
1
-1000

SLIDER
10
240
182
273
initialPrice
initialPrice
400
2400
400.1
0.1
1
NIL
HORIZONTAL

TEXTBOX
285
285
588
355
Current Monopoly and Firm Values\n---------------------------\nMonopoly quantities, prices, and revenues on the left.\nAgent's quantities, prices, and revenues on the right.
11
0.0
0

SLIDER
11
405
183
438
epochLength
epochLength
2
100
4.0
1
1
NIL
HORIZONTAL

MONITOR
14
521
455
566
NIL
version
17
1
11

SWITCH
11
273
137
306
random-as
random-as
0
1
-1000

SWITCH
11
339
170
372
random-walk-as
random-walk-as
0
1
-1000

SWITCH
434
315
573
348
vix-on
vix-on
0
1
-1000

MONITOR
341
380
472
425
Average Difference
avg-difference
17
1
11

SWITCH
273
315
434
348
dynamic-epsilon
dynamic-epsilon
0
1
-1000

SLIDER
256
283
594
316
dynamic-epsilon-coefficient
dynamic-epsilon-coefficient
0
1
0.56
.01
1
NIL
HORIZONTAL

CHOOSER
11
438
149
483
daRandomSeed
daRandomSeed
0 1 2 3 4 5 6 100 "system clock"
0

MONITOR
406
426
464
471
epsilon
epsilon
17
1
11

@#$#@#$#@
## WHAT IS IT?

This model explores how we can determine a relationship between the VIX “fear gauge” and the S&P stock market index. In general, comparisons between different Probe and Adjust operations can be made by running simulations using the operation created by Steven O. Kimbrough and by using the modified operations which have been provided in this program. Information regarding the standard model of Probe and Adjust are provided by SOK in the coursework of OIDD 319.

 Kimbrough, Steven O. (2007). Monopoly Probe and Adjust model. http://opim-sky.wharton.upenn.edu/~sok/agebook/applications/nlogo/monopolyProbeAndAdjust.nlogo University of Pennsylvania, Philadelphia, PA 19004, USA.     

 In this program, certain variables and functionality have been added, modified, or removed entirely due to relevance to the topic at hand. 

The VIX, also known as the CBOE Volatility Index, is the premier “fear gauge” of the stock market. In layman’s terms, the higher the tentative value of the VIX, the higher the unpredictability of the stock market. This means that the S&P, for example, could potentially crash or boom. The term “fear gauge” is often disputed because of the potential boom. In essence, the VIX is heavily correlated with the dynamism of the stock market. 

The program is simplified in the context of what’s being pursued. In the SOK model, standard economic formulas are used to compute maximal revenue, which is determined by a dynamic monopoly price. The simulation must “chase” this price to receive maximum revenue. In our model, the simulation must chase the S&P value, and this is done without using any economic formulas, which means it’s a relatively straightforward process and the code used to construct this program is not difficult to follow. 

Note that you will have to change the directory in the code so that the NetLogo program can find the file:

"[INSERT REST OF DIRECTORY HERE]/oidd project/FINAL-RAW.csv"


If we have dynamic delta on, this means that the program will read each successive VIX value on the excel file provided entitled FINAL-CSV.csv. The corresponding S&P values are picked up in the same manner.If dynamic-delta is off, then the VIX values picked up by the Netlogo CSV parser will be ignored. It’s merely just the difference between using the VIX values and not using them. We use the function daRevenue from SOK’s Probe and Adjust to calculate the absolute difference of the probe and the current S&P value. If the probe is above the currentPrice, the difference goes into the up-data list. If the probe is below the currentPrice, the difference goes into the down-data list. 

Once the epoch is over we find which of the two lists has the smaller mean difference and add either +epsilon or -epsilon to the currentPrice. We then update the average distance between the currentPrice and the current S&P value.

If dynamic epsilon is on (dynamic-delta MUST be on for this), then we keep track of the VIX values for each epoch, entitled vixValues. Once the epoch is, we then update epsilon to be dynamic-epsilon-coefficient * mean vixValues. We then update the currentPrice as we did before.

After each epoch we update the avg-distance, the average distance between currentPrice and the sp (the S&P price at the tic).



## RUNNING THE MODEL

On the Interface tab, click the setup button, then click the go button. The model will run until you click the go button again to stop it.

The Interface tab offers a number of sliders and switches for setting run parameter values.

    initialPrice

PARTLY FROM THE SOK MODEL: Sets the base, or anchor, quantity the monopolist agent uses during its first episode.  As in all episodes, the agent has a base value for price and it probes by offering to the S&P that are somewhat above or below this base quantity.

    episodeLength 

PARTLY FROM THE SOK MODEL: Sets the number of samples the agent takes before considering an adjustment of currentPrice.  The agent samples until the number of samples is greater than or equal to episodeLength. Then the agent adjusts currentPrice and a new episode begins.

    daRandomSeed

FROM THE SOK MODEL: Picking an item with this chooser determines how the random number generator is to be initialized for the run.  Picking "system clock" lets NetLogo do the initialization. This will result in a different random number stream for each run. Picking a number results in the random number generated with that number, resulting in an identical random number stream for each run.  This is useful for comparison and communication purposes.  Also, note that the chooser is user-editable, so it it possible to add and delete entries.

    random-as, random-walk-as

Price = a - dSlope*Quanity. dSlope is set by the interface slider:

	vix-on

Allows for VIX values to be read from the csv file and uses them as the delta value for probing.

	dynamic-epsilon-coefficient

What to multiply trueDelta by to create the epsilon value at the end of each epoch. The dynamic-epsilon switch must be turned ON. 
**VIX ON MUST BE TURNED ON**

	dynamic-epsilon

Allows for the epsilon at the end of each epoch to be dynamic-epsilon-coefficent * trueDelta
**VIX ON MUST BE TURNED ON**


## RELATED MODELS

This model was created and written by Noah Weiner, Nathan Kok, and Jonathan Avila for Steven Kimbrough's OIDD 319 course final project, with base code provided by Steven Orla Kimbrough. Please see SOK's Monopoly and Probe and Adjust Model for further information.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

link
true
0
Line -7500403 true 150 0 150 300

link direction
true
0
Line -7500403 true 150 150 30 225
Line -7500403 true 150 150 270 225

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
