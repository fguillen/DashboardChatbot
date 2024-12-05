if Rails.env.production?
  Rails.logger.info "Setting ONNX Runtime library path"
  OnnxRuntime.ffi_lib = "/usr/lib/libonnxruntime.so.1.19.2"
end
