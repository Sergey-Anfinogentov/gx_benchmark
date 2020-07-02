function gx_align_testgx_align_test::test_gx_align_image
  required_accuracy = 0.1
  small_number = 0.01
  
  
  ;==creating test data========================================
  nx = 256
  ny = 128
  w = 5d
  xc = 0.5d*(nx - 1d)
  yc = 0.5d*(ny - 1d)
  grid_x = dindgen(nx)#replicate(1d,ny) - xc
  grid_y = dindgen(ny)##replicate(1d,nx) - yc
  expected_dx = 5.5
  expected_dy = -3.2
  reference = exp( - (grid_x^2 + grid_y^2)/w^2)
  shifted_img = exp( - ((grid_x - expected_dx)^2 + (grid_y - expected_dy)^2)/w^2)
  
  shifted_img_0 = shifted_img
  reference_0 = reference
  
  
  ;==test GX_ALIGN_IMAGE without keywords========================
  
  result = gx_align_image(shifted_img, reference)
  measured_dx = result[0]
  measured_dy = result[1]
  
  ;check that the shifts were measured correctly
  assert, abs(measured_dx - expected_dx) lt required_accuracy,$
     'failed to measure X-shift: %6.2f instead of %6.2f ', measured_dx, expected_dx
  assert, abs(measured_dy - expected_dy) lt required_accuracy,$
     'failed to measure Y-shift: %6.2f instead of %6.2f ', measured_dy,expected_dy
  
  ;Check that the arguments have not being changed   
  assert, total(abs(reference - reference_0)) eq 0.,$
     'reference image has been changed, which is not expected'
  assert, total(abs(shifted_img - shifted_img_0)) eq 0.,$
    'image to align has been changed, which is not expected'
    
 ;==test GX_ALIGN_IMAGE  with the REPLACE keyword=================

  result = gx_align_image(shifted_img, reference, /replace)
  measured_dx = result[0]
  measured_dy = result[1]
  
  ;check that the shifts were measured correctly
  assert, abs(measured_dx - expected_dx) lt required_accuracy,$
     'failed to measure X-shift (REPLACE=1): %6.2f instead of %6.2f ', measured_dx, expected_dx
  assert, abs(measured_dy - expected_dy) lt required_accuracy,$
     'failed to measure Y-shift (REPLACE=1) %6.2f instead of %6.2f ', measured_dy,expected_dy
  
  ;check that the reference image has not being changed
  assert, total(abs(reference - reference_0)) eq 0.,$
     'reference image has been changed (REPLACE=1), which is not expected'
   
  ;check that the image (first argument) was correctly shifted and matches the reference
  max_residual = max(abs(shifted_img - reference))
  assert, max_residual lt small_number,$
     'Aligned image does not match reference image, maximal residual is %8.2e',max_residual
 
  return,1
end

function gx_align_test::test_gx_align_map
  
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
  
  gx_align_map, map, reference
  
  ;check that the shifts were measured correctly
  assert, abs(map.xc - expected_xc) lt required_accuracy,$
    'failed to measure X-center (low-res reference) %6.2f instead of %6.2f ', map.xc ,  expected_xc
  assert, abs(map.yc - expected_yc) lt required_accuracy,$
    'failed to measure Y-center (low-res reference) : %6.2f instead of %6.2f ', map.yc, expected_yc
    
  ; check that INTER_MAP returns correctly shifted map
  map_t = inter_map(map, reference, cubic = -0.5)
  max_residual = max(abs(map_t.data - reference.data))
  assert, max_residual lt small_number,$
    'Aligned map does not match reference map (low-res reference), maximal residual is %6.3f',max_residual
    
  ;swap maps and test again
  map.xc = xc
  map.yc = yc
  expected_xc = xc + dx
  expected_yc = yc + dy
  
  temp = map
  map = reference
  reference = temp
  
  gx_align_map, map, reference
  
  ;check that the shifts were measured correctly
  assert, abs(map.xc - expected_xc) lt required_accuracy,$
    'failed to measure X-center (high-res reference):  %6.2f instead of %6.2f ', map.xc ,  expected_xc
  assert, abs(map.yc - expected_yc) lt required_accuracy,$
    'failed to measure Y-center(high-res reference): %6.2f instead of %6.2f ', map.yc, expected_yc
  
  ; check that INTER_MAP returns correctly shifted map
  map_t = inter_map(map, reference, cubic = -0.5)
  max_residual = max(abs(map_t.data - reference.data))
  assert, max_residual lt small_number,$
    'Aligned map does not match reference map (high-res reference), maximal residual is %6.3f',max_residual
  


  return,1
end


pro gx_align_test__define
  compile_opt idl2
  define = {gx_align_test, inherits MGutTestCase }
end