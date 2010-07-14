module ::JabberJaw
  class Adapter
    
    attr_accessor :handler, :name
    
    def listen(handler, opts = {})
      self.handler = handler
      self.name = (opts[:as] || self.class)
    end
    
    def handle(message, opts = {})
      handler.handle message, opts.merge({:adapter => name})
    end
    
  end
end