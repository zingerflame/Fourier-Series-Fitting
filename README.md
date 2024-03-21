How to use the code (it's not cleaned up yet):

Purpose: Franck-hertz experiment fitting



**Lines 1-60:**


10 Trial data processing and formatting, just have 10 csv files of similar form. Only thing to note is that your y axis will be raised by 10^10 so account for it in figure titles.

**Lines 61-69:**

Defines fourier domain for inner products. The graph generated will be of just raw data, and uncomment the error bars if you don't want to omit them (it will look very ugly but lab TA might require it so play around with the sizes or something).

**Line 73:**

Creates the vertical uncertainty. NOTE: This uncertainty is the range/2 of first 47 data points, which should be fine for most experiments, but look at your data and ask yourself if the trend is present within the first 47. If not, make a smaller interval (i.e. change 47->25).
The comments for this section are in lines 138-161, i just couldnt be bothered to move it.


**Lines 75-103**

Series is computed using dot product of data points. YOU CAN CHANGE k HERE FOR NUMBER OF TERMS. 25 usually fits good. IMPORTANT Variables generated are your fourier coefficients A, B vectors for sin and cos, a0 for your first cos coefficient. And their respective uncertainties dA and dB. Note that the uncertainty for a0 = 0 because of the way we calculated it. This line also generates the symbolic function equivalent for later use.

**Lines 104-110:**

Plots the symbolic function against its derivative, mostly commented out because its just  a visualizer for where the zeros are.

**Lines 113-133:**

VERY VERY IMPORTANT: Observe that the ranges vector are ranges for where the zeros are approximately between. Replace these values with your data by observing approximate zero locations using 104-110 because the vpasolve uses these as a guess for where the minima should be. The rest of the code just plots it.

**Lines 163-191:**

Residual analysis, makes the residual plot with error bars, which is very ugly. Lines 174/175 are the ylines which you can visualize how many residuals fall in the range of your exp. uncertainty, which is somewhat related to your chi square. The ratio variable gives you the proportion that falls within that range. The chi square is also done here, with some comments about how to justify it. MAKE SURE TO CHANGE THE TITLE IF YOU CHANGED YOUR NUMBER OF TERMS EARLIER.

**rest of document**

Ignore it, do the linear fit on excel.
