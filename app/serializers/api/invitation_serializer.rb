module Api
  class InvitationSerializer < SimpleDelegator
    include Swagger::Blocks

    swagger_schema :Invitation do
      key :required, [:id, :user_id, :state, :invitation_url]
      property :id do
        key :type, :string
        key :format, :uuid
      end
      property :user_id do
        key :type, :string
        key :format, :uuid
      end
      property :state do
        key :type, :string
        key :enum, User::Invitation.available_states.map(&:to_s)
      end
      property :invitation_url do
        key :type, :string
        key :format, :uri
      end
    end

    def initialize(invitation, context)
      @context = context
      super(invitation)
    end

    attr_reader :context

    delegate :invitation_url, to: :context

    def as_json
      {
        id: id,
        user_id: user_id,
        state: state,
        invitation_url: invitation_url(id: token)
      }
    end

  end
end