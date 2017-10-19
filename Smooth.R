Bezier4 = function(xyarr, i, t)
  {
    # xyarr: matrix format of a 2-dimension data set
    # i    : the indexes of 4 chart points in x/y
    # t    : value between 0 and 1, inclusive
    
    # Excel uses a 4 control points when drawing smooth curves
    # Bezier4 function computes the xy coordinates of one point on the bezier curve
    # The 4 chart points pts1-4 are used to determine 4 control points bz1-4 for drawing a bezier curve
    
    # bz1 = pts2 always
    # bz2 = on a line through pts2 parallel to pts3-pts1, at a distance from pts2 = 1/6th the length |pts3-pts1|
    # bz3 = on a line through pts3 parallel to pts2-pts4, at a distance from pts3 = 1/6th the length |pts2-pts4|
    # bz4 = pts3 always
    #
    # bz2 and bz3 are also subject to additional modification as follows:
    # for bz2, limit [1/6th the length of pts3-pts1] to never be more than 1/2 the length of |pts3-pts2|
    # for bz3, limit [1/6th the length of pts2-pts4] to never be more than 1/2 the length of |pts3-pts2|
    # in cases where just bz2 is being limited to |pts3-pts2|/2, for bz3 reduce the length of [pts2-pts4]/6 by replacing it with (pts3-pts2)/2 * |pts4-pts2|/|pts3-pts1|
    # in cases where just bz3 is being limited to |pts3-pts2|/2, for bz2 reduce the length of [pts3-pts1]/6 by replacing it with (pts3-pts2)/2 * |pts3-pts1|/|pts4-pts2|
    # Also, endpoint intervals (designated by pts1=pts2 or pts3=pts4) are handled a little differently. In this case use 1/3 instead of 1/6.
    
    # 4 chart points
    pts1 = xyarr[i[1],]
    pts2 = xyarr[i[2],]
    pts3 = xyarr[i[3],]
    pts4 = xyarr[i[4],]
    
    d12 = dist(xyarr[c(i[1],i[2]),])
    d23 = dist(xyarr[c(i[2],i[3]),])
    d34 = dist(xyarr[c(i[3],i[4]),])
    d13 = dist(xyarr[c(i[1],i[3]),])
    d24 = dist(xyarr[c(i[2],i[4]),])
    
    bz1 = pts2
    bz4 = pts3
    
    if(d13/6 < d23/2 & d24/6 < d23/2)
    { 
      # normal case: both 1/6th vectors are less than d23/2
      f = ifelse(i[1] == i[2], 1/3, 1/6)  # f=1/3: endpoint intervals
      bz2 = f * (pts3 - pts1) + pts2
      f = ifelse(i[3] == i[4], 1/3, 1/6)  # f=1/3: endpoint intervals
      bz3 = f * (pts2 - pts4) + pts3
    }else if(d13/6 >= d23/2 & d24/6 >= d23/2)
    { 
      # both 1/6th vectors are larger than d23/2
      bz2 = d23/2/d13 * (pts3 - pts1) + pts2
      bz3 = d23/2/d24 * (pts2 - pts4) + pts3
    }else if(d13/6 >= d23/2)
    {
      bz2 = d23/2/d13 * (pts3 - pts1) + pts2
      bz3 = d23/2/d24 * (d24/d13) * (pts2 - pts4) + pts3
    }else
    {
      bz2 = d23/2/d13 * (d13/d24) * (pts3 - pts1) + pts2
      bz3 = d23/2/d24 * (pts2 - pts4) + pts3
    }
    
    # Four control point Bezier interpolation
    px = (1-t)^3 * bz1[1] + 3 * t * (1-t)^2 * bz2[1] + 3 * t^2 * (1-t) * bz3[1] + t^3 * bz4[1]
    py = (1-t)^3 * bz1[2] + 3 * t * (1-t)^2 * bz2[2] + 3 * t^2 * (1-t) * bz3[2] + t^3 * bz4[2]
    
    return(matrix(c(px, py), ncol = 2, byrow = TRUE))
  }

Smoothing = function(xyarr, g = 0.1)
{
  curve = matrix(xyarr[1,], ncol = 2)
  index = c(1,1:nrow(xyarr), nrow(xyarr)) # add index for endpoint intervals
  granular = g
  
  for(i in 1:(nrow(xyarr)-1))
  {
    for(t in seq(granular, 1, granular))
    {
      curve = rbind(curve, Bezier4(xyarr, index[i:(i+3)], t))
    }
  }
  
  return(curve)
}
