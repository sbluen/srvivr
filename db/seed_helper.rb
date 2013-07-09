#!usr/bin/env ruby

require 'bcrypt'
pw=BCrypt::Password.create('password')
puts pw