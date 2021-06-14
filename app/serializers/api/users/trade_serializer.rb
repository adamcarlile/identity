module Api
  module Users
    class TradeSerializer < SimpleDelegator
      include Swagger::Blocks

      swagger_schema :Trade do
        key :required, [:trade_id, :state]
        property :trade_id do
          key :type, :string
        end
        property :state do
          key :type, :string
          key :enum, Trade.available_states.map(&:to_s)
        end
      end

      def initialize(trade)
        super(trade)
      end

      def as_json
        {
          trade_id: external_id,
          state: state,
        }
      end

      def reload
        self.class.new(super)
      end

    end
  end
end