class Book < ApplicationRecord
  include PgSearch
  multisearchable against: [:title, :subtitle, :description]
  monetize :price_cents

  belongs_to :publisher, required: false
  belongs_to :author

  validates :title, :released_on, :author, :isbn_10, :isbn_13, presence: true
  validates :isbn_10, :isbn_13, uniqueness: true
  validates :isbn_10, length: { is: 10 }
  validates :isbn_13, length: { is: 13 }

  mount_base64_uploader :cover, CoverUploader
end
