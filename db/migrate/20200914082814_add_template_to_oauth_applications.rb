class AddTemplateToOauthApplications < ActiveRecord::Migration[6.0]
  def change
    add_column :oauth_applications, :template_name, :string
  end
end
