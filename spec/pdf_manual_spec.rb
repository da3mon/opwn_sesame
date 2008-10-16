require File.join(File.dirname(__FILE__), *%w[spec_helper])

describe PdfManual do
  def fixture_file
    File.open(File.join(File.dirname(__FILE__), *%w[fixtures v.jpg]))
  end
  
  def created_file
    File.join(File.dirname(__FILE__), *%W[.. public pdfs filename.pdf])
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
        thread = nil
        mock(Thread).new.yields
        image = PdfManual.create(attrs)
        File.exists?(created_file).should be_true
      end
    end

    describe "before destroy" do
      it "deletes the corresponding image file" do
        File.exists?(created_file).should_not be_true
        thread = nil
        mock(Thread).new.twice.yields
        pdf = PdfManual.create(attrs)
        pdf.destroy
        File.exists?(created_file).should_not be_true
      end
    end
  end
end