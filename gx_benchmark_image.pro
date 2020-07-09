

;+
  ; :Description:
  ;    This procedure quantitatively compared modeled image with the observed one
  ;
  ; :Params:
  ;    data_model - dblarr(nx, ny), in,  synthetic MW image to benchmark
  ;    data_obs - dblarr(nx, ny), in,  reference observed image to compare with
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
function gx_benchmark_image, data_model, data_obs, brightness_threshold = brightness_threshold
  if not keyword_set(brightness_threshold) then begin
    mask =data_model*0.+1.
  endif else begin
    mask = abs(data_obs) gt (brightness_threshold * max(abs(data_obs)))
  endelse
  
  
  
  ;COnvert input data to double precision floats
  data_model_d = double(data_model*mask)
  data_obs_d = double(data_obs*mask)
  
  ind = where(mask)
  n_pics = total(mask)
  cor = correlate(data_model_d, data_obs_d)
  chi2 = total((data_model_d[ind]-data_obs_d[ind])^2)/n_pics
  rho2 = total((data_model_d[ind]/data_obs_d[ind] -1d)^2)/n_pics
  rho = total(data_model_d[ind]/data_obs_d[ind] -1d)/n_pics
  chi2_norm = total((data_model_d[ind]-data_obs_d[ind])^2)/total(data_obs_d[ind]^2)
  max_r = max(data_model_d)/max(data_obs_d)
  return,{cor:cor, chi2:chi2, chi2_norm:chi2_norm, rho:rho, rho2:rho2}


end