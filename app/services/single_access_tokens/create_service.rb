module SingleAccessTokens
  class CreateService < ServiceObject
    
    def initialize(user:, intent:)
      @user         = user
      @intent       = intent.to_s.parameterize.underscore.to_sym
    end

    def call
      invalidate_previous_tokens!
      if access_token.valid? && access_token.save!
        fire :success, access_token
      else
        fire :failure, "Oops, looks like something went wrong"
      end
    end

    private

      def params
        {
          intent: @intent,
        }.reject {|k, v| v.blank? }
      end

      def invalidate_previous_tokens!
        previous_tokens.each {|x| x.revoke! }
      end

      def access_token
        @access_token ||= @user.single_access_tokens.build(params)
      end

      def previous_tokens
        @previous_tokens ||= @user.single_access_tokens.available.where(intent: @intent)
      end

  end
end