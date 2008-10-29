%w(spec dm-core dm-validations).each { |f| require f }
Dir[File.join(File.dirname(__FILE__), *%w[.. lib *])].each { |f| require f }

Spec::Runner.configure do |c|
  c.mock_with :rr
  c.before(:all) do
    DataMapper.setup(:default, 'sqlite3::memory:')
    DataMapper.auto_migrate!
  end
end

class Hash
  def drop(*keys)
    copy = self.dup
    keys.each { |k| copy.delete(k) }
    copy
  end
end

describe Hash do
  it "#drop" do
    {:a => :foo, :b => :bar}.drop(:a).should == {:b => :bar}
  end
end
