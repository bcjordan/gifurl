require 'test_helper'

class GifsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Gif.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Gif.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Gif.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to gif_url(assigns(:gif))
  end

  def test_edit
    get :edit, :id => Gif.first
    assert_template 'edit'
  end

  def test_update_invalid
    Gif.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Gif.first
    assert_template 'edit'
  end

  def test_update_valid
    Gif.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Gif.first
    assert_redirected_to gif_url(assigns(:gif))
  end

  def test_destroy
    gif = Gif.first
    delete :destroy, :id => gif
    assert_redirected_to gifs_url
    assert !Gif.exists?(gif.id)
  end
end
