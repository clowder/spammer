class Message
  def initialize(path_to_message)
    # NOTE: Should the fact that some messages have crap encoding be a feature?
    @raw_message = File.read(path_to_message).encode('UTF-8', 'UTF-8', :invalid => :replace)
  end

  def html?
    html_regex = /<                       # Is there an opening tag, or a tag that closes itself
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

    !!(@raw_message =~ html_regex)
  end

  def quoted_printable?
    !!(headers =~ /quoted\-printable/i)
  end

  private
  def headers
    @headers ||= @raw_message.split("\n\n").first
  end
end
