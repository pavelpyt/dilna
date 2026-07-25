require "test_helper"

class NoteTest < ActiveSupport::TestCase
  test "vyžaduje text" do
    note = jobs(:havarie).notes.new(user: users(:owner))

    assert_not note.valid?
    assert_includes note.errors.attribute_names, :body
  end
end
