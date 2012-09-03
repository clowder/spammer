class PreclassifiedMessage < Value.new(:label, :message)
  extend Forwardable

  def_delegators :@message, :html?, :quoted_printable?
end
