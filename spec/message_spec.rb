require 'spec_helper'

describe Message do
  let(:spam_quoted_printable_with_html) { 'data/spam/00001.7848dde101aa985090474a91ec93fcf0' }
  let(:plain_spam)                      { 'data/spam/00002.d94f1b97e48ed3b553b3508d116e6a09' }

  it "knows if it contains html" do
    Message.new(spam_quoted_printable_with_html).html?.should == true
  end

  it "knows if there is no html" do
    Message.new(plain_spam).html?.should == false
  end

  it "knows if the message is quoted printable" do
    Message.new(spam_quoted_printable_with_html).quoted_printable?.should == true
  end

  it "knows if the message is not quoted printable" do
    Message.new(plain_spam).quoted_printable?.should == false
  end
end
