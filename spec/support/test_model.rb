class TestModel
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :name, :string
  attribute :size, :integer

  validate { TestValidator.new(self).validate }
end
