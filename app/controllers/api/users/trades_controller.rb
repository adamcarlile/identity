module Api
  module Users
    class TradesController < BaseController
      permit 'trades:write'

      swagger_path '/users/{user_id}/trades' do
        operation :get do
          security do
            key :identity_auth, ['trades:write']
          end
          key :summary, 'Return the list of trades associated with that User'
          key :description, 'We can get back an index of trades, and the various states that they are in'
          parameter do
            key :name, :user_id
            key :in, :path
            key :required, true
            key :type, :string
            key :format, :uuid
          end
          response 200 do
            key :description, 'Array of User::Trade association objects'
            schema do
              key :type, :array
              items do
                key :'$ref', :Trade
              end
            end
          end
          response :default do
            key :description, 'unexpected error'
            schema do
              key :'$ref', :Error
            end
          end
        end

        operation :post do
          security do
            key :identity_auth, ['trades:write']
          end
          key :summary, 'Create a trade associaton  a User'
          key :description, 'Allows a user to have multiple trade ID\'s associated with it'
          parameter do
            key :name, :user_id
            key :in, :path
            key :required, true
            key :type, :string
            key :format, :uuid
          end
          parameter do
            key :name, :trade
            key :in, :body
            key :description, 'The trade record to create'
            key :required, true
            schema do
              property :trade_id do
                key :type, :string
              end
              property :state do
                key :type, :string
                key :enum, Trade.available_states.map(&:to_s)
              end
            end
          end
          response 201 do
            key :description, 'User::Trade association response'
            schema do
              key :'$ref', :Trade
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

      swagger_path '/users/{user_id}/trades/{trade_id}/{event}' do
        operation :post do
          security do
            key :identity_auth, ['trades:write']
          end
          key :summary, 'Trigger a state change a User::Trade association'
          key :description, 'Allow the changing of the state after the initial creation'
          parameter do
            key :name, :user_id
            key :in, :path
            key :required, true
            key :type, :string
            key :format, :uuid
          end
          parameter do
            key :name, :trade_id
            key :in, :path
            key :required, true
            key :type, :string
          end
          parameter do
            key :name, :event
            key :in, :path
            key :required, true
            key :type, :string
            key :enum, Trade.available_events.map(&:to_s)
          end
          response 200 do
            key :description, 'User::Trade association object'
            schema do
              key :'$ref', :Trade
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
        if trade.valid? && trade.save!
          render json: trade.as_json
        else
          render json: trade.errors, status: :unprocessable_entity
        end
      end

      def index
        render json: user.trades.map {|trade| Api::Users::TradeSerializer.new(trade).as_json }
      end

      def event
        trade.public_send("#{params[:event]}!")
        render json: trade.reload.as_json
      end

      private

      def trade
        @trade ||= Api::Users::TradeSerializer.new(trade_object)
      end

      def user
        @user ||= User.find(params[:user_id])
      end

      def permitted_params
        params.require(:trade).permit(:trade_id, :state)
      end

      def trade_object
        params[:id] ? user.trades.find_by(external_id: params[:id]) : user.trades.new(trade_params)
      end

      def trade_params
        { external_id: permitted_params[:trade_id], state: permitted_params[:state] }
      end
    
    end
  end
end