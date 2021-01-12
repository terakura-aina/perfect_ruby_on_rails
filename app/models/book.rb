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
  # 独自のメソッドの場合はvalidate
    if book.name.include?("exercise")
      book.errors[:name] << "「exercise」を含めることはできません。"
    end
  end

  before_validation do |book|
    book.name = self.name.gsub(/CAT/) do |matched|
      # gsubメソッドはマッチした全ての部分を特定の文字列に置き換えてくれる
      "lovery #{matched}"
    end
  end

  after_destroy do |book|
    Rails.logger.info "Book is deleted: #{book.attributes.inspect}"
  end

  def high_price?
    price >= 5000
  end

  after_destroy :if => :high_price? do |book|
    Rails.logger.warn "Book with high price is deleted: #{book.attributes.inspect}"
    Rails.logger.warn "Please check!!"
  end
end
