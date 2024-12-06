# I have to install the onnxruntime library by hand https://github.com/ankane/informers/issues/12
if Rails.env.production?
  Rails.logger.info "Setting ONNX Runtime library path"
  OnnxRuntime.ffi_lib = "/usr/lib/libonnxruntime.so.1.19.2"
end
