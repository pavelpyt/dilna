require "test_helper"

class JobPhotoTest < ActiveSupport::TestCase
  test "vyžaduje přiložený soubor" do
    job_photo = jobs(:havarie).job_photos.new(user: users(:owner))

    assert_not job_photo.valid?
    assert_includes job_photo.errors.attribute_names, :image
  end
end
