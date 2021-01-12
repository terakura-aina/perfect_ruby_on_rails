class Book < ApplicationRecord
  scope :costory, -> { where('price > ?', 3000) }
  # Book.costory == Book.where('price > ?', 3000) 同等の意味として扱える
  scope :written_about, ->(theme) { where('name like ?', "%#{theme}%") }
  # Book.costory.written_about('java')と記述することで、3000円以上のjavaと書かれた本を探すことができる

  belongs_to :publisher
  has_many :authors, through: :book_authors

  validates :name, presence: true
  validates :name, length: { maximum: 15 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  # greater_than_or_equal_to: => 指定された値と等しいか、それよりも大きくなければならないことを指定する
  validate do |book|
    if book.name.include?("exercise")
      book.errors[:name] << "「exercise」を含めることはできません。"
    end
  end
end
