class ApiKey < ApplicationRecord
  has_many :access_tokens

  before_validation :generate_key, on: :create

  validates :key, presence: true
  validates :active, presence: true

  class << self
    def activated
      where(active: true)
    end
  end

  def disable
    update_column :active, false
  end

  private

  def generate_key
    self.key = SecureRandom.hex
  end
end
