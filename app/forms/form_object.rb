class FormObject
  include Virtus.model
  include ActiveModel::Validations
  include ActiveModel::Naming
  include ActiveModel::Conversion
end