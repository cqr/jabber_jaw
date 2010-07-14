require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe JabberJaw::Adapter do
  it 'stores the specified handler' do
    adapter = JabberJaw::Adapter.new()
    handler = mock('handler')
    adapter.listen(handler)
    adapter.handler.should == handler
  end
  
  it 'passes `handle` to the handler' do
    adapter = JabberJaw::Adapter.new
    handler = mock('handler')
    adapter.listen(handler)
    handler.should_receive(:handle)
    adapter.handle('message')
  end
  
  describe 'includes the name of the adapter in its `handle` call' do
    it 'when not subclassed or named' do
      adapter = JabberJaw::Adapter.new
      handler = mock('handler')
      adapter.listen(handler)
      handler.should_receive(:handle).once.with('message', :adapter => JabberJaw::Adapter)
      adapter.handle('message')
    end
    
    it 'when not subclassed but named' do
      adapter = JabberJaw::Adapter.new
      handler = mock('handler')
      adapter.listen handler, :as => 'foobar'
      handler.should_receive(:handle).once.with('message3', :adapter => 'foobar')
      adapter.handle('message3')
    end
    
    it 'when subclassed but not named' do
      class JabberJaw::Adapters::Subbed < JabberJaw::Adapter; end
      adapter = JabberJaw::Adapters::Subbed.new
      handler = mock('handler')
      adapter.listen handler
      handler.should_receive(:handle).once.with('message4', :adapter => JabberJaw::Adapters::Subbed )
      adapter.handle('message4')
    end
  end

end