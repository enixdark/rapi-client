class InvalidClientIdError < StandardError
  def message
    "the client id invalid"
  end
end