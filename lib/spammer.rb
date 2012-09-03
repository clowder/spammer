require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

# Using recursion to get nested tags
class HtmlCleaner
  def self.html_regex
    @html_regex ||= /<                       # Is there an opening tag, or a tag that closes itself
                     ([a-z\-]+)              # Catch the tag name
                     .*?\/?>                 # Tolerate junk or the tag being self closing
                     (?:
                       (?<=\/>)              # Was the preciding tag closed
                         |                   # Then do nothing
                         (                   # Else check for closing tag that matches
                           (.*?)             # Catch the content between the tags
                           <\/\1>
                         )
                     )/imx
  end

  def initialize(string)
    @string = string
  end

  def clean
    if html?
      HtmlCleaner.new(cleaned).clean
    else
      @string
    end
  end

  def html?
    @string =~ self.class.html_regex
  end

  private
  def cleaned
    @string.gsub(self.class.html_regex, '\2')
  end
end

class Message
  def self.punctuation_regex
    /[,\s\?!&;:\(\)\.\"\'\-]+/
  end

  def initialize(path)
    @content = File.read(path)
  end

  def headers
    @headers ||= @content.split("\n\n").first
  end

  def body
    @body ||= if quoted_printable?
                extract_body.unpack('M').first
              else
                extract_body
              end
  end


  def html?
    body =~ HtmlCleaner.html_regex
  end

  def plain_text
    @plain_text ||= HtmlCleaner.new(body).clean
  end

  def dictionary
    data.split(self.class.punctuation_regex)
  end

  private
  def extract_body
    @content.split("\n\n").drop(1).join('\n\n')
  end

  def quoted_printable?
    headers =~ /quoted\-printable/i
  end
end

ham  = Dir['data/easy_ham/*'].map { |path| Message.new(path) }
spam = Dir['data/spam/*'].map { |path| Message.new(path) }

problem = Libsvm::Problem.new
parameter = Libsvm::SvmParameter.new

parameter.cache_size = 1 # in megabytes
parameter.eps = 0.001
parameter.c = 10

dictionary = (spam + ham).inject([]) { |memo, msg| memo + message.dictionary }

labels   = (spam.map { 1 } + (ham.map { 0 })
features = (spam + ham).map { |message| Libsvm::Node.features(dictionary.map { |word| message.dictionary.include?(word) ? 1 : 0 }) }

problem.set_examples(labels, features)

model = Libsvm::Model.train(problem, parameter)

test_feature = Libsvm::Node.features(dictionary.map { |word| test.split(punctuation_regex).include?(word) ? 1 : 0 })
prediction = model.predict(test_feature)

binding.pry

