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
    !!(header_data =~ /quoted\-printable/i)
  end

  def references
    if headers['References']
      headers['References'].strip.split(/\s+/)
    else
      []
    end
  end

  private
  def headers
    @headers ||= Hash[header_data.scan(/^([^:]+):([^\n]+(?:\s{2,}[^\n]+)*)/)]
  end

  def header_data
    @header_data ||= @raw_message.split("\n\n").first
  end
end
