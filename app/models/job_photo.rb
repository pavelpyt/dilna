class JobPhoto < ApplicationRecord
  belongs_to :job
  belongs_to :user

  has_one_attached :image

  validates :image, presence: true
end
