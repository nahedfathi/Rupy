require 'json'

class Person
    attr_accessor :name
  
    def initialize(name)
      @name = name
    end
  
    def valid_name?
      @name.match?(/\A[a-zA-Z ]+\z/)
    end
  end
  
  module Contactable
    def self.contact_details(email, mobile)
      "#{email} | #{mobile}"
    end
  end
  
  class User < Person
    attr_accessor :email, :mobile
  
    def initialize(name, email, mobile)
      super(name)
      @email = email
      @mobile = mobile
    end
  
    def self.valid_mobile?(mobile)
      mobile.match?(/\A0\d{10}\z/)
    end
    # ///////////////////////////////Registering///////////////////////////////
    def create
        if !valid_name?
        puts "Sorry, name is invalid."
        return false
        elsif !self.class.valid_mobile?(mobile)
        puts "sorry, mobile numberis invalid."
        return false
        else
        user_data = {name: name, email: email, mobile: mobile}
        users = User.read_users_from_file
        users << user_data
        User.write_users_to_file(users)
        puts "Welcome, #{name}."
        return self
        end
    end
    # ///////////////////////////////listing///////////////////////////////
    def self.list(n = nil)
      users = read_users_from_file
      if n.nil?
        users.each {|user| puts "#{user["name"]} - #{Contactable.contact_details(user["email"], user["mobile"])}"}
      else
        users.first(n).each {|user| puts "#{user["name"]} - #{Contactable.contact_details(user["email"], user["mobile"])}"}
      end
    end
  
    private
  
    def self.read_users_from_file
      if File.exist?('users.json')
        JSON.parse(File.read('users.json'))
      else
        []
      end
    end
  
    def self.write_users_to_file(users)
      File.write('users.json', JSON.pretty_generate(users))
    end
  end
# //////////////////////////////////
# puts "Name:"
# name = gets.chomp

# puts "Email:"
# email = gets.chomp

# puts "Mobile:"
# mobile = gets.chomp

# user = User.new(name, email, mobile)
# user.create
# /////////////////////////////////
puts "Enter (*) to list all registered users or the number of users you would like to list:"
input = gets.chomp

if input == "*"
  User.list
elsif input.match?(/\A\d+\z/)
  User.list(input.to_i)
else 
  puts "Invalid input. Please enter '*' or integer number."
end