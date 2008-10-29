require File.join(File.dirname(__FILE__), *%w[spec_helper])

describe Image do
  def fixture_file
    File.open(File.join(File.dirname(__FILE__), *%w[fixtures v.jpg])).read
  end
  
  def created_file
    File.join(File.dirname(__FILE__), *%W[.. public images filename.png])
  end
  
  attr_reader :attrs
  before(:each) do
    @attrs = {:filename => "filename", :data => fixture_file}
  end
  
  after(:each) do
    FileUtils.rm_rf(created_file)
  end
  
  describe "hooks" do
    describe "before save" do
      it "saves data as an image" do
        File.exists?(created_file).should_not be_true
        image = Image.create(attrs)
        File.exists?(created_file).should be_true
      end
    end

    describe "before destroy" do
      it "deletes the corresponding image file" do
        File.exists?(created_file).should_not be_true
        image = Image.create(attrs)
        image.destroy
        File.exists?(created_file).should_not be_true
      end
    end
  end
end