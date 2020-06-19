class TestValidator < RailsModelValidator
  def validate
    name_present
    size_is_not_too_high
  end

  private

  def name_present
    validate_presence_of(:name)
  end

  def size_is_not_too_high
    errors.add(:size, :invalid) if subject.size.to_i > 99
  end
end
