require 'jabber_jaw/adapter'
require 'xmpp4r/client'
module ::JabberJaw
  module Adapters
    class Xmpp < JabberJaw::Adapter
      include Jabber
      
      attr_accessor :jid, :client, :options
      
      def initialize(username, password, options = {})
        self.jid = JID.new(username)
        self.client = Client.new(jid)
        self.options = options
        @password = password
      end
      
      def send(message, opts = {})
        msg = Jabber::Message.new(opts[:to], message)
        msg.type = opts[:type] || :chat
        client.send msg
      end
      
      def run!
        client.connect
        client.auth(@password)
        client.send(Presence.new(options[:presence]))
        client.add_message_callback do |msg|
          handle msg.body, :from => msg.from, :type => msg.type if msg.body
        end
      end
    end
  end
end