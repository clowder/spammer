require 'spec_helper'

describe Features do
  it "knows what the important features are" do
    Features.named.should == [:html?, :quoted_printable?]
  end

  it "is equal to an ordered collection of the named features" do
    message = mock(:html? => true, :quoted_printable? => false)
    Features.new(message).should == [1, 0]
  end

  it "can be turned into a formal example for libsvm" do
    message = mock(:html? => true, :quoted_printable? => false)
    Features.new(message).to_example.should == [Libsvm::Node.new(0,1.0), Libsvm::Node.new(1,0.0)]
  end
end
