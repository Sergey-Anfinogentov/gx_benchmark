function gx_benchmark_test::test_gx_benchmark_map

  width = 0.2d
  dx = 0.2d
  dy = -0.3d
  xc = 0.5d
  yc = -0.3d
  expected_xc = xc - dx
  expected_yc = yc - dy

  required_accuracy = 0.001d
  small_number = 0.01

  ;preparing test maps
  def_map, reference
  reference.xunits = "Rsun"
  reference.yunits = "Rsun"
  reference.rsun = 1.0d
  reference.xc= xc
  reference.yc= yc
  reference.dx =0.015d
  reference.dy = 0.015d
  reference.id = "reference map"

  map = reference
  map.dx =0.01d
  map.dy = 0.01d
  map.id = "test map"

  map = add_tag(rem_tag(map,"data"),dblarr(200,210),"data")
  reference = add_tag(rem_tag(reference,"data"),dblarr(300,310),"data")

  x = get_map_xp(map)
  y = get_map_yp(map)
  data = exp(-((x-dx)^2+(y-dy)^2)/width^2)
  map.data = data

  x = get_map_xp(reference)
  y = get_map_yp(reference)
  data = exp(-((x)^2+(y)^2)/width^2)
  reference.data = data

  metrics = gx_benchmark_map( map, reference)
  
  ;check that correlation coefficient is computed correctly
  assert, metrics.cor gt 0.99d,$
    'Correlation coefficient is not computed correctly: %6.2f ', metrics.cor
  
  ;check that chi2 is computed correctly
  assert, metrics.chi2 lt 0.01d,$
    'chi2 is not computed correctly: %6.2f ', metrics.chi2
    
  ;check that chi2_norm  is computed correctly
  assert, metrics.chi2_norm lt 0.01d,$
    'chi2_norm is not computed correctly: %6.2f ', metrics.chi2_norm
    
  ;check that chi2_norm  is computed correctly
  assert, metrics.rho2 lt 0.01d,$
    'rho2 is not computed correctly: %6.2f ', metrics.rho2
    
  ;check that chi2_norm  is computed correctly
  assert, abs(metrics.rho) lt 0.05d,$
    'rho is not computed correctly: %6.2f ', metrics.rho



  return,1
end


pro gx_benchmark_test__define
  compile_opt idl2
  define = {gx_benchmark_test, inherits MGutTestCase }
end