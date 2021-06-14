class User
  class SingleAccessTokenMailer < ApplicationMailer

    def login_email
      @token = params[:token]
      mail(to: @token.user.email, subject: 'Login')
    end

  end
end