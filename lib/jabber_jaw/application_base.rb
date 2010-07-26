require 'jabber_jaw/command'
module ::JabberJaw
  module ApplicationBase
    
    def self.included(klass)
      klass.extend(ClassMethods)
    end
    
    module ClassMethods
      def command(matcher, options = {}, &block)
        command = JabberJaw::Command.new(matcher, options, &block)
        command.application = self
        commands[matcher] = command
      end
    
      def commands
        @commands ||= {}
      end
    
      def helpers(*mods, &block)
        mods.each do |mod|
          JabberJaw::Command.include mod if mod.kind_of? Module
        end
        JabberJaw::Command.class_eval &block if block_given?
      end
    
      def connect(adapter, *args)
        options = (args.pop if args.last.kind_of? Hash) || {}
        if adapter.kind_of? Class
          connections << [adapter, args, options]
        elsif tmp = adapterize(adapter) and tmp.kind_of? Class
          connections << [tmp, args, options]
        end
      end
      
      def connections
        @connections ||= []
      end
      
      def adapters
        @adapters ||= {}
      end
      
      def threads
        @threads ||= []
      end
      
      def adapterize(adapter)
        eval('JabberJaw::Adapters::'+adapter.to_s.split('_').map(&:capitalize).join(''))
      end
      
      def run!
        Thread.abort_on_exception = true
        connect :stdio if connections.empty?
        connections.each do |adapter, args, options|
          conn_name = options.delete(:as) || adapter.to_s.intern
          args.push(options) unless options.empty?
          adapter = adapter.new(*args)
          adapter.listen(self, :as => conn_name)
          adapters[conn_name] = adapter
          fork do
            adapter.run!
            loop do; sleep 0.5; end
          end
        end
        Process.wait
      end
      
      def restart!
        threads.map(&:kill)
        run!
      end
      
      def handle(message, options = {})
        puts "Recieved Message: #{message} from #{options[:from]}"
        commands.each do |name, command|
          if command.handles?(message, options)
            puts "Message is handled by #{command}"
            return command.handle(message, options)
          end
        end
      end
      
      def deliver(message, options = {})
        adapter = adapters[options.delete(:through)]
        adapter.send(message, options) if adapter
      end
    end
  end
end