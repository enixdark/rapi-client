class UnauthorizedError < StandardError
  def message
    "the access token invalid"
  end
end