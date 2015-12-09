#!/usr/bin/env ruby
require "csv"

module BigCartelCsvParser
   class OrderItem
      attr_accessor :product_name
      attr_accessor :product_option_name
      attr_accessor :quantity
      attr_accessor :price
      attr_accessor :total
      
      def initialize(item_hash)
      end
   end

   class Order
      attr_accessor :number
      attr_accessor :buyer_name
      attr_accessor :buyer_email
      attr_accessor :completed_at
      attr_accessor :status
      attr_accessor :payment_status
      attr_accessor :transactionid
      attr_accessor :shipping_status
      attr_accessor :shipping_address_1
      attr_accessor :shipping_address_2
      attr_accessor :shipping_city
      attr_accessor :shipping_state
      attr_accessor :shipping_zip
      attr_accessor :shipping_country
      attr_accessor :currency
      attr_accessor :order_items
      attr_accessor :order_item_count
      attr_accessor :order_item_total
      attr_accessor :order_total_price
      attr_accessor :order_total_shipping
      attr_accessor :order_total_tax
      attr_accessor :order_total_discount
      attr_accessor :order_discount_code
      attr_accessor :order_note

      def initialize(order_hash)
         @number = order_hash[:number]
         @buyer_name = [order_hash[:buyer_first_name],order_hash[:buyer_last_name]].join(' ')
         @buyer_email = order_hash[:buyer_email]
         @completed_at = order_hash[:completed_at]
         @status = order_hash[:status]
         @payment_status = order_hash[:payment_status]
         @transaction_id = order_hash[:transaction_id]
         @shipping_status = order_hash[:shipping_status]
         @shipping_address_1 = order_hash[:shipping_address_1]
         @shipping_address_2 = order_hash[:shipping_address_2]
         @shipping_city = order_hash[:shipping_city]
         @shipping_state = order_hash[:shipping_state]
         @shipping_zip = order_hash[:shipping_zip]
         @shipping_country = order_hash[:shipping_country]
         @currency = order_hash[:currency]
         @order_items = order_hash[:items]
         @order_item_count = order_hash[:item_count]
         @order_item_total = order_hash[:item_total]
         @order_total_price = order_hash[:total_price]
         @order_total_shipping = order_hash[:total_shipping]
         @order_total_tax = order_hash[:total_tax]
         @order_total_discount = order_hash[:total_discount]
         @order_discount_count = order_hash[:discount_count]
         @order_note = order_hash[:note]
      end
      
      # Parse csv strings as the following
      #
      # product_name:IT'S THE LIMIT FANZINE|product_option_name:|quantity:1|
      # price:1.5|total:1.5;product_name:WHEN YOU’RE OUT THERE FANZINE|
      # product_option_name:|quantity:1|price:1.5|total:1.5
      def parse_items
         item_array = []
         items = CSV.parse_line(@order_items, :col_sep => ";")
         puts items.inspect
         items.each do |item|
            option_hash = {}
            options = CSV.parse_line(item, :col_sep => "|")
            puts options.inspect
            options.each { |option|
               key, value = option.split(":")
               option_hash[key.to_sym] = value
            }
            puts option_hash.inspect
            item_array.push(OrderItem.new(option_hash))
         end
         item_array
      end
   end

   class Parser
      attr_accessor :orders

      def initialize(file)
         @csv = nil
         @csv_file = file
         @orders = Array.new
      end

      # load csv entries from csv file
      # convert each line to a hash with the field name symbols as keys.
      def load()
         
         csv = CSV.read(@csv_file, :headers => true, :header_converters => :symbol)
         @csv = csv.map {|row| row.to_hash }
         @csv.each do |row|
            @orders.push(Order.new(row))
         end
      end

   end
end # module

class Accountant
   def initialize()

   end

   def work
   end
end
