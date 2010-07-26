module ::JabberJaw
  VERSION = '3.0.0'
  require 'jabber_jaw/application'
  require 'jabber_jaw/command'
  require 'jabber_jaw/adapters'
end


# This covers top-level applications that are not
# wrapped in a class' warm, loving embrace.
# It requires that you require the file from the file
# which is being executed, and it requires that you
# don't have any JabberJaw applications defined
# aside from the top-level one.

if caller(1)[0].split(':')[0] == $0
  include ::JabberJaw::ApplicationBase::ClassMethods 
  at_exit do
    if JabberJaw.applications.empty?
      puts "Initializing Top-Level JabberJaw Application"
      run!
    end
  end
end