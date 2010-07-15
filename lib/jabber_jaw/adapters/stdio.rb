require 'jabber_jaw/adapter'
module ::JabberJaw
  module Adapters
    class Stdio < JabberJaw::Adapter
      
      def initialize(inf = $stdin, out = $stdout)
        @in, @out = inf, out
      end
      
      def send(message, opts = {})
        @out << "#{opts[:to].to_s + ': ' if opts[:to]}#{message}\r\n"
      end
      
      def run!
        @out << 'JabberJaw> ' if @out.tty?
        while message = @in.gets
          handle message.chomp, :from => 'stdin' unless message == ''
          @out << 'JabberJaw> ' if @out.tty?
        end
      end
    end
  end
end