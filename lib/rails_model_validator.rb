require "rails_model_validator/version"
require "forwardable"
require "dry/initializer"

class RailsModelValidator
  extend ::Dry::Initializer
  extend Forwardable

  param :subject

  def_delegators :subject, :errors, :new_record?, :persisted?, :changes

  def validate
    raise NoImplementedError, "Implement #validate in #{self.class.name}"
  end

  protected

  alias create? new_record?
  alias update? persisted?

  %i(
    Absence
    Acceptance
    Confirmation
    Exclusion
    Format
    Inclusion
    Length
    Numericality
    Presence
  ).each do |type|
    define_method :"validate_#{type.downcase}_of" do |*attrs, **options|
      call_validator("ActiveModel::Validations::#{type}Validator".constantize, attrs, options)
    end
  end

  def call_validator(klass, attrs, options = {})
    klass.new({attributes: attrs}.merge(options)).validate(subject)
  end

  private

  class << self
    def call(*args, &block)
      new(args, &block).call
    end
  end
end
