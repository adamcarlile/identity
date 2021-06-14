module Identity
  module TokenResponse
    
    def body
      hash = {}
      hash['id_token'] = @token.token if @token.includes_scope? :openid

      super.merge(hash)
    end

  end
end
