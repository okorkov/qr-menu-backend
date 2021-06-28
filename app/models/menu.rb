class Menu < ApplicationRecord
  belongs_to :user

  has_many_attached :pdf_files

end
