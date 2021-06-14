module Sessions
  module Token
    class ResponsesController < SessionsController

      def create
        super
      end

      protected

      def form
        @form ||= Sessions::Token::ResponseForm.new(token: params[:token])
      end

    end
  end
end