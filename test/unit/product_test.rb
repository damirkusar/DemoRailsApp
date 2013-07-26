require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products


  def new_product(image_url) Product.new(title: 'My Book Title',
                                         description: 'yyy',
                                         price: 1,
                                         image_url: image_url)
  end

  test 'image url is ending with jpg || png || gif' do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg fred.doc.jpg http://a.b.c/x/y/z/fred.gif }
    bad = bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |url|
      assert new_product(url).valid?, "#{url} shouldn't be invalid"
    end

    bad.each do |url|
      assert new_product(url).invalid?, "#{url} shouldn't be valid"
    end

  end

  test 'product attributes must not be empty' do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test 'product price must be positive' do
    product = Product.new(title:        'My Book Title',
                          description:  'Hello Book',
                          image_url:    'zz.jpg')
    product.price = -1;
    assert product.invalid?
    assert_equal 'must be greater than or equal to 0.01', product.errors[:price].join('; ')

    product.price = 0;
    assert product.invalid?
    assert_equal 'must be greater than or equal to 0.01', product.errors[:price].join('; ')

    product.price = 1;
    assert product.valid?
  end

  test 'product is not valid without a unique title' do
    product = Product.new(title: products(:ruby).title,
                          description: 'yyy',
                          price: 1,
                          image_url: 'fred.gif')
    assert !product.save
    assert_equal 'has already been taken', product.errors[:title].join('; ')
  end

  test 'title must contain more than 10 signs' do
    product = products(:ruby)
    product.title = 'short'
    assert product.invalid?
    assert_equal 'must be more than 10 signs', product.errors[:title].join('; ')
  end

end
