class Service
  def self.perform(*args, **kwargs, &block)
    instance = new
    instance.perform(*args, **kwargs, &block)
  end

  def perform(*args, **kwargs, &block)
    raise 'You need to overwrite this method in actual service'
  end
end
