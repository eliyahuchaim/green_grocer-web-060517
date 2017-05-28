#items = [
  #{"AVOCADO" => {:price => 3.0, :clearance => true }},
  #{"AVOCADO" => {:price => 3.0, :clearance => true }},
  #{"KALE"    => {:price => 3.0, :clearance => false}}
#]

def consolidate_cart(cart)

new_cart = {}

cart.each do |key|
  key.each do |item,attributes|
    if new_cart.include?(item)
        new_cart[item][:count] += 1
      else
        new_cart[item] = attributes
        new_cart[item][:count] = 1
      end
    end
  end
  new_cart
end


def apply_coupons(cart, coupons)
coupons.each do |coupon|
   if cart.include?(coupon[:item]) && coupon[:num] <= cart[coupon[:item]][:count]
     if cart.include?("#{coupon[:item]} W/COUPON")
        cart["#{coupon[:item]} W/COUPON"][:count] += 1
        cart[coupon[:item]][:count] -= coupon[:num]
     else
        cart["#{coupon[:item]} W/COUPON"] = {}
        cart["#{coupon[:item]} W/COUPON"][:price] = coupon[:cost]
        cart["#{coupon[:item]} W/COUPON"][:clearance] = cart[coupon[:item]][:clearance]
        cart["#{coupon[:item]} W/COUPON"][:count] = 1
        cart[coupon[:item]][:count] -= coupon[:num]
     end
    end
  end
  cart
 end


def apply_coupon(cart, coupons)

cart_with_coupon = {}

cart.each do |key|
  key.each do |item,details|
    coupons.each do |k,v|
        if item == v
        cart[item][:count] -= coupons[:num]
        cart_with_coupon["#{item} W/COUPON"] = {:price => "#{coupons[:cost]}", :clearance => cart[item][:clearance], :count => 1}
end
end
end
end
cart.merge!(cart_with_coupon)
return cart
end


def apply_clearance(cart)

cart.each do |item,details|
      if details[:clearance] == true
      cart[item][:price] = (cart[item][:price] * 0.8).round(2)
       end
    end
    cart
  end




  def checkout(cart, coupons)
    new_cart = consolidate_cart(cart)
    new_cart = apply_coupons(new_cart, coupons)
    new_cart = apply_clearance(new_cart)

    total = 0
    new_cart.each {|item, data| total += new_cart[item][:price] * new_cart[item][:count]}
    total > 100 ? total = (total * 0.9).round(2) : total
   end
