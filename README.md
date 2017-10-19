Smoothing Algorithm Using Bézier Curves
================

<center>
Rachel Jiaying Gu
</center>
</br>

This R function is inspired by an article posted by **Jon Bittner** on January 31, 2012.
The article can be found here: [Mystery solved! The secret of Excel curved line interpolation](https://blog.splitwise.com/2012/01/31/mystery-solved-the-secret-of-excel-curved-line-interpolation/)

The main purpose of this R function is to reproduce the (third-order/cubic) **Bezier Spline** that Microsoft Excel used in its **smoothed line** function.

![Excel Smooth](\img\excel%20smooth.png)

#### Bézier Curves

A Bézier curve is a parametric curve frequently used in computer graphics, animation, modeling, CAD, CAGD and many other related fields. Bezier curves and surfaces are curves written in Bernstein basis form; so, they are known many years ago. However, these applications are used heavily only in the last 30 years.

A Bézier curve is defined by a set of control points *P*<sub>0</sub> through *P*<sub>*n*</sub>, where n is called its order (n = 1 for linear, 2 for quadratic, etc.). The first and last control points are always the end points of the curve; however, the intermediate control points (if any) generally do not lie on the curve. The sums in the following sections are to be understood as affine combinations, the coefficients sum to 1.

#### A Specific Case - Cubic Bézier Curves

Four points *P*<sub>0</sub>, *P*<sub>1</sub>, *P*<sub>2</sub> and *P*<sub>3</sub> in the plane or in higher-dimensional space define a cubic Bézier curve. The curve starts at *P*<sub>0</sub> going toward *P*<sub>1</sub> and arrives at *P*<sub>3</sub> coming from the direction of *P*<sub>2</sub>. Usually, it will not pass through *P*<sub>1</sub> or *P*<sub>2</sub>; these points are only there to provide directional information. The distance between *P*<sub>1</sub> and *P*<sub>2</sub> determines "how far" and "how fast" the curve moves towards *P*<sub>1</sub> before turning towards *P*<sub>2</sub>.

Bézier equations are parametric equations in a variable *t*, and are symmetrical relative to *x* and *y*:

Writing *B*<sub>*P*<sub>*i*</sub>, *P*<sub>*j*</sub>, *P*<sub>*k*</sub></sub>(*t*) for the quadratic Bézier curve defined by points *P*<sub>*i*</sub>, *P*<sub>*j*</sub>, and *P*<sub>*k*</sub>, the cubic Bézier curve can be defined as an affine combination of two quadratic Bézier curves:

*B*(*t*)=(1 − *t*)•*B*<sub>*P*<sub>0</sub>, *P*<sub>1</sub>, *P*<sub>2</sub></sub>(*t*)+*t* • *B*<sub>*P*<sub>1</sub>, *P*<sub>2</sub>, *P*<sub>3</sub></sub>(*t*),1 ≥ *t* ≥ 0

The explicit form of the curve is:

*B*(*t*)=(1 − *t*)<sup>3</sup> • *P*<sub>0</sub> + 3(1 − *t*)<sup>2</sup>*t* • *P*<sub>1</sub> + *t*<sup>3</sup> • *P*<sub>3</sub>, 1 ≥ *t* ≥ 0

For some choices of *P*<sub>1</sub> and *P*<sub>2</sub> the curve may intersect itself, or contain a cusp.

Any series of any 4 distinct points can be converted to a cubic Bézier curve that goes through all 4 points in order. Given the starting and ending point of some cubic Bézier curve, and the points along the curve corresponding to t = 1/3 and t = 2/3, the control points for the original Bézier curve can be recovered.

#### Explanation of my Smoothing function

An easy-to-understand explanation of my Smoothing function is that the function adds adequate enough points between two neighbouring data points using the Bézier equations so that the line looks smooth.

**Functions:**

Bezier4 function computes the xy coordinates of **one** point on the bezier curve.

    Bezier4(xyarr, i, t)

    # xyarr: matrix format of a 2-dimension data set
    # i    : the indexes of 4 chart points in x/y
    # t    : value between 0 and 1, inclusive

Smoothing function computes the xy coordinates of **all** point on the bezier curve.

    Smoothing(xyarr, g = 0.1)

    # xyarr: matrix format of 2 arrays x, y
    # g    : granularity of the curve, default set as 0.1, 
    #        which means insert 1/0.1 points between two neighbouring data points

#### Example

Below is an example using a very simple time series data set, the **Value** is generated randomly.

|       |     |     |     |     |     |     |     |     |     |     |
|:------|----:|----:|----:|----:|----:|----:|----:|----:|----:|----:|
| Time  |    1|    2|    3|    4|    5|    6|    7|    8|    9|   10|
| Value |   31|   26|   55|    6|   47|   48|   81|   37|   55|   17|

<img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-1-1.png" style="display: block; margin: auto;" />

Now try to tune parameter **g** and see how it affects the smoothness. *n* = 1/*g* number of points will be insert between 2 neighbouring data points.

<img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-2-1.png" style="display: block; margin: auto;" /><img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-2-2.png" style="display: block; margin: auto;" /><img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-2-3.png" style="display: block; margin: auto;" /><img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-2-4.png" style="display: block; margin: auto;" /><img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-2-5.png" style="display: block; margin: auto;" /><img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-2-6.png" style="display: block; margin: auto;" />

For *g* = 0.05 and smaller, it is smooth enough.

#### Other Spline Functions

**splinefun {stats}**

Interpolating Splines: Perform cubic (or Hermite) spline interpolation of given data points, returning either a list of points obtained by the interpolation or a function performing the interpolation.

Interpolation takes place at **n** equally spaced points spanning the interval \[xmin, xmax\].

<img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-3-1.png" style="display: block; margin: auto;" /><img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-3-2.png" style="display: block; margin: auto;" /><img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-3-3.png" style="display: block; margin: auto;" /><img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-3-4.png" style="display: block; margin: auto;" /><img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-3-5.png" style="display: block; margin: auto;" /><img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-3-6.png" style="display: block; margin: auto;" />

**smooth.spline {stats}**

Fits a cubic smoothing spline to the supplied data.

*spar* is a smoothing parameter, typically (but not necessarily) in (0, 1\]. The coefficient *λ* of the integral of the squared second derivative in the fit (penalized log likelihood) criterion is a monotone function of spar.

<img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-1.png" style="display: block; margin: auto;" /><img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-2.png" style="display: block; margin: auto;" /><img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-3.png" style="display: block; margin: auto;" /><img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-4.png" style="display: block; margin: auto;" /><img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-5.png" style="display: block; margin: auto;" /><img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-6.png" style="display: block; margin: auto;" /><img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-7.png" style="display: block; margin: auto;" /><img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-8.png" style="display: block; margin: auto;" /><img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-9.png" style="display: block; margin: auto;" /><img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-10.png" style="display: block; margin: auto;" /><img src="Smoothing_Algorithm_Using_Bézier_Curves_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-11.png" style="display: block; margin: auto;" />

**plotly**

*smoothing* is a smoothing parameter which control the amount of smoothing, typically in \[0, 1.3\] with default as 1. Only works if shape is set to *spline*.

![Plotly Smooth](plotly%20smooth.png)

#### Comparison

I choose a smooth enough curve from each of the functions above and compare with the Excel smooth function I wrote.

**splinefun** is the twistest curve that way more than necessary - it adds a downward trend and following an upward trend in between Time 1 and Time 2, which makes the curved line biased, cause we can't see this trend in the original data points! Actually, it's the limitation of all the spline function when the plotted data set has extreme pikes.

**smooth.spline** fit the data into a predictive function as all the points don't pass through the original data points. This makes tuning parameter very important.

**plotly** produce a spline very close to the **Excel smooth**. I did some research, plotly didn't disclose what kind of spline it used.

![Compare](compare.png)
