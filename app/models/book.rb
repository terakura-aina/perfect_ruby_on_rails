class Book < ApplicationRecord
  scope :costory, -> { where('price > ?', 3000) }
  # Book.costory == Book.where('price > ?', 3000) 同等の意味として扱える
  scope :written_about, ->(theme) { where('name like ?', "%#{theme}%") }
  # Book.costory.written_about('java')と記述することで、3000円以上のjavaと書かれた本を探すことができる

  belongs_to :publisher
  has_many :authors, through: :book_authors
end
