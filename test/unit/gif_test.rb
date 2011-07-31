require 'test_helper'
require 'shoulda'

class GifTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Gif.new.valid?
  end

  context "with a sample gif" do
    setup do
      @gif = Gif.create :name => "test", :nsfw => true
    end

    should "have created gif" do
      assert_equal "test", @gif.name
      assert @gif.nsfw
    end

    should "accept a couple of tags" do
      @gif.tag_list.add "tag", "tag2", "tag3"
      @gif.save
      assert_equal 3, @gif.tags.size
    end
  end
end
