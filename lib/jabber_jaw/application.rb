require 'jabber_jaw/command'
module ::JabberJaw
  class Application
    class << self
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
        connect :stdio if connections.empty?
        connections.each do |adapter, args, options|
          conn_name = options.delete(:as)
          args.push(options) unless options.empty?
          adapter = adapter.new(*args)
          adapter.listen(self, :as => conn_name)
          adapters[conn_name] = adapter
          threads << Thread.new(adapter) do |adapter|
            adapter.run!
          end.join
        end
      end
      
      def restart!
        threads.map(&:kill)
        run!
      end
      
      def handle(message, options = {})
        commands.each do |name, command|
          if command.handles?(message, options)
            command.handle(message, options)
            return true
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