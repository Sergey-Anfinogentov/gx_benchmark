function gx_benchmark_map, map, reference
  ;align map
  gx_align_map, map, reference
  
  ;Interpolate reference map (which is assumed to have broader than the synthetic image)
  map_ref = inter_maP(reference, map)
  
  metrics = gx_benchmark_image(map.data, map_ref.data)

  return, metrics
end