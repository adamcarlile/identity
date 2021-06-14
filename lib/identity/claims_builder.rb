module Identity
  class ClaimsBuilder
    class << self
      def call(opts)
        new(**opts).call
      end
    end
    SCOPE_MAPPINGS = {
      openid: [:sub],
      email: [:email, :email_verified],
      profile: [:name, :family_name, :given_name, :middle_name, :nickname, :preferred_username, :profile, :website, :picture, :gender, :birthdate, :zoneinfo, :locale, :updated_at],
      address: [:address],
      phone: [:phone_number, :phone_number_verified]
    }.freeze

    TOKEN_CLAIM_KEYS = [:sub, :name, :email, :phone_number, :phone_number_verified].freeze

    def initialize(application:,
                  resource: nil,
                  scopes:,
                  expires_in:,
                  created_at: Time.zone.now,
                  issuer:,
                  token: false)
      @issuer       = issuer
      @application  = application
      @resource     = resource
      @scopes       = scopes
      @expires_in   = expires_in.seconds.from_now.to_i
      @created_at   = created_at
      @token        = token
    end

    def call
      essential_claims.merge(subject_claims).merge(platform_claims)
    end

    private

    def essential_claims
      {
        aud: @application.uid,
        iss: @issuer,
        exp: @expires_in,
        iat: @created_at.to_i,
      }
    end

    def platform_claims
      # Extra claims
      { }
    end

    def subject_claims
      return {} unless @resource
      requested_claim_keys.map {|k| [k, @resource&.public_send(k)] }.to_h
    end

    def scope_claim_keys
      SCOPE_MAPPINGS.slice(*@scopes.map(&:to_sym)).values.flatten
    end

    def requested_claim_keys
      return (scope_claim_keys & TOKEN_CLAIM_KEYS) if @token
      scope_claim_keys
    end

  end
end
