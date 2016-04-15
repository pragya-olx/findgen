# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Client.create(:name => "TCS", :location => "Noida")
User.create(:name => "Owner", :email => "owner@findgen.com", :encrypted_password => "test", :role_type => "owner")
User.create(:name => "Admin", :email => "admin@tcs.com", :encrypted_password => "test", :role_type => "admin", :client_id => 1)

User.create(:name => "Approver", :email => "approver@tcs.com", :encrypted_password => "test", :role_type => "approver", :client_id => 1)

User.create(:name => "Spoc", :email => "spoc@tcs.com", :encrypted_password => "test", :role_type => "spoc", :client_id => 1)

User.create(:name => "Luminous", :email => "lum@vendor.com", :role_type => "vendor")

