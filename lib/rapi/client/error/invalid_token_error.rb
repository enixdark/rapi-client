class InvalidTokenError < StandardError
  def message
    "the token invalid"
  end
end