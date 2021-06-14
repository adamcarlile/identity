module Api
  class InvitationsController < BaseController
    permit 'invitations:write'

    swagger_path '/invitations' do
      operation :post do
        security do
          key :identity_auth, ['invitations:write']
        end
        key :summary, 'Create an invitation for a user'
        key :description, 'Returns an invitation token to be used to complete the user signup'
        parameter do
          key :name, :invitation
          key :in, :body
          key :description, 'Invitation to create'
          key :required, true
          schema do
            property :redirect_uri do
              key :type, :string
            end
            property :confirm_details do
              key :type, :boolean
            end
            property :user do
              key :type, :object
              property :email do
                key :type, :string
              end
              property :first_name do
                key :type, :string
              end
              property :last_name do
                key :type, :string
              end
              property :mobile_number do
                key :type, :string
              end
            end
          end
        end
        response 200 do
          key :description, 'Invitation response'
          schema do
            key :'$ref', :Invitation
          end
        end
        response :default do
          key :description, 'unexpected error'
          schema do
            key :'$ref', :Error
          end
        end
      end
    end

    def create
      if invitation.save
        render json: invitation.as_json
      else
        render json: {
          code: 422,
          message: invitation.errors,
          type: :unprocessable_entity
        }, status: :unprocessable_entity
      end
    end

    private

    def invitation
      @invitation ||= Api::InvitationSerializer.new(user.invitations.create(invitation_params), self)
    end

    def user
      @user ||= User.by_mobile_or_email(mobile_number: user_params[:mobile_number], email: user_params[:email])
        .first_or_create(user_params)
    end

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :mobile_number, :postcode)
    end

    def invitation_params
      params.permit(:redirect_uri, :confirm_details).merge({ application: application })
    end

  end
end
