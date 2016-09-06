class Book < ApplicationRecord
  belongs_to :publisher
  belongs_to :author

  validates :title, :released_on, :author, :isbn_10, :isbn_13, presence: true
  validates :isbn_10, :isbn_13, uniqueness: true
  validates :isbn_10, length: { is: 10 }
  validates :isbn_13, length: { is: 13 }
end
