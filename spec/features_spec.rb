require 'spec_helper'

describe Features do
  it "knows what the important features are" do
    Features.named.should == [:html?, :quoted_printable?, :references?]
  end

  it "knows how it extract features from the incoming object" do
    message = mock(:html? => true, :quoted_printable? => false, :references => [])

    features = Features.new(message)
    features.html?.should == 1.0
    features.quoted_printable?.should == 0.0
    features.references?.should == 0.0
  end

  it "can be turned into a formal example for libsvm" do
    message = mock(:html? => true, :quoted_printable? => false, :references => [:ref])
    Features.new(message).to_example.should == [Libsvm::Node.new(0,1.0), Libsvm::Node.new(1,0.0), Libsvm::Node.new(2,1.0)]
  end
end
