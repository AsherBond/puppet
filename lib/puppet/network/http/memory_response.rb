class Puppet::Network::HTTP::MemoryResponse
  attr_reader :code, :type, :body

  def respond_with(code, type, body)
    @code = code
    @type = type
    @body = body
  end
end
