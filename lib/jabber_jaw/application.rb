require 'jabber_jaw/application_base'
module ::JabberJaw
  
  def self.applications
    @applications ||= []
  end
  
  class Application
    
    extend ::JabberJaw::ApplicationBase::ClassMethods
    
    def self.inherited(klass)
      ::JabberJaw.applications << klass
    end
    
  end
end