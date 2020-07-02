;+
; :Description:
;    This procedure quantitatively compared modeled image with the observed one
;
; :Params:
;    map - map structure, in,  synthetic MW image to benchmark
;    reference - map structure, in,  reference (observed) map to compare with
;
; :Keywords:
;    brightness_threshold - double, default:0d, in, set this keyword to analize
;       only pixels with the brightness above some threshold.
;       Setting "brightness_threshold=0.1d" will result in processing only pixels
;       with the brightness above 10% of the maximum brigntness values in the reference image
;
; :Return value:
;     The routine returns a structure with the following fields:
;       cor - Pearson correlation coefficient
;       chi2 - squared residual = average(|y - y_obs|^2)
;       chi2_norm - globally normalized squared residual = average(|y - y_obs|^2)/sum(y_obs^2)
;       rho2 - locally normalised squared residual = average(|y - y_obs|^2/y_obs^2)
;       rho - locally normalised residual = average(|y - y_obs|^2/y_obs^2)
;       max_r - ratio of maximum intensities =  max(y)/max(y_obs)
;
; :Author: Sergey Anfinopgentov (anfinogentov@iszf.irk.ru)
;-

function gx_benchmark_map, map, reference, brightness_threshold = brightness_threshold
  ;align map
  gx_align_map, map, reference
  
  ;Interpolate reference map (which is assumed to have broader than the synthetic image)
  map_ref = inter_maP(reference, map)
  
  metrics = gx_benchmark_image(map.data, map_ref.data, brightness_threshold = brightness_threshold)

  return, metrics
end