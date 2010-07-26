module ::JabberJaw
  class Command
    
    attr_reader :matcher, :config, :options, :block, :message, :application, :full_message, :sender
    attr_accessor :message_delivered
    
    def initialize(matcher = nil, config = {}, &block)
      @name = matcher || 'default'
      matcher ||= /(.*)/
      matcher = /^#{matcher}#{config[:split]||' '}(.+)$/ if matcher.kind_of? String or matcher.kind_of? Symbol
      @matcher, @config, @block = matcher, config, block
      singleton_class.send(:define_method, :_execute, &block)
    end
    
    def application=(app)
      @application = app
      self
    end
    
    def handles?(message, opts = {})
      return false unless @response = matcher.match(message)
      return false unless config[:only].nil? or [config[:only]].flatten.include?(opts[:adapter])
      true
    end
    
    def handle(message, opts = {})
      self.message_delivered = false
      @sender, @options, @message, @full_message = opts[:from], opts, message, message
      @message = @response[1] if @response and @response.length == 2
      args = @response[1, _execute_arity] if _execute_arity >= 1
      @message, args = args, args[0].split(config[:split] || /\s/, _execute_arity) if args and args.length == 1 and _execute_arity >= 1
      args ||= []
      args.fill(nil, args.length..._execute_arity)
      returned = _execute(*args)
      reply returned if returned.kind_of? String and no_message_delivered?
    end
    
    def send(message, opts = {})
      self.message_delivered = true
      application.deliver(message, {:through => incoming_adapter}.merge(opts))
    end
    
    def reply(message)
      send message, :to => sender
    end
    
    def incoming_adapter
      options[:adapter]
    end
    
    def no_message_delivered?
      !message_delivered?
    end
    
    def message_delivered?
      message_delivered
    end
    
    def to_s
      @name.to_s + ' command'
    end
    
    private
    
    def singleton_class
      @singleton_class ||= class << self; self; end
    end
    
    def _execute_arity
      @execute_arity ||= block.arity
    end
  end
end