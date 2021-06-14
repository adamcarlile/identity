module Sessions
  module Token
    class ResponseForm < FormObject
      
      attribute :token, String
      validates :token, presence: true
    
    end
  end
end