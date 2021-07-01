class Menu < ApplicationRecord
  belongs_to :user

  has_one_attached :pdf_file
  has_one_attached :qr_code

end
