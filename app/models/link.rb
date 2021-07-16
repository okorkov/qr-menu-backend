class Link < ApplicationRecord

  belongs_to :user
  
  has_one_attached :qr_code

end
