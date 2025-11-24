require(terra)
require(leaflet)
require(purrr)
require(htmltools)

xs = list.files("FloodYears_tiles/",full.names = TRUE)

voi = aggregate(vect("vc_voi"))

voi_id  = sapply(strsplit(xs,"_"),function(x) substr(x[5],1,4))

xs = xs[voi_id < 4000]
voi_id = voi_id[voi_id < 4000]

voi_id  = sapply(strsplit(xs,"_"),function(x) substr(x[5],1,4))

rl = lapply(xs,function(x) rast(x))

# Pick one raster as the template (e.g. the first one)
template <- rast(voi,res=res(rl[[1]])) #rl[[1]]

# Resample all rasters to match the template's resolution and extent
rl_resampled <- lapply(rl, function(r) {
  resample(r, template, method = "bilinear")  # or method = "near" for categorical data
})

# Now mosaic them with a function (e.g. mean)
r_mosaic <- do.call(mosaic, c(rl_resampled, fun = mean))
