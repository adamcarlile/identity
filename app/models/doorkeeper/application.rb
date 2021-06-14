module Doorkeeper
  class Application < ActiveRecord::Base

    self.table_name = 'oauth_applications'

    has_many :user_invitations,
      class_name: 'User::Invitation'

    scope :ordered, -> { order(name: :asc) }

    def template
      @template ||= Template.find(template_name) if template_name.present?
    end

    def template?
      !!template
    end

  end
end
