class ServiceObject
  class << self
    def run!(*args, &block)
      service = new(*args)
      if block_given?
        yield(service)
      else
        service.success { |_service, *args| return args.first }
      end
      service.call
    rescue => e
      raise e if Rails.application.config.consider_all_requests_local
      if service && service.phonebook[:failure].present?
        Raven.capture_exception(e)
        service.fire(:failure, e.message.to_s)
      else
        raise e
      end
    end
  end

  def phonebook
    @phonebook ||= {}
  end

  def on(event, &block)
    phonebook[event] = block
    self
  end

  def fire(event, *payload)
    phonebook[event].call(self, *payload) unless phonebook[event].blank? and return
  end

  def method_missing(method, *args, &block)
    if blk = block || args.detect {|x| x.is_a? Proc}
      on(method, &blk)
    end
  end
end
