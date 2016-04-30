# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

c = Client.create(:name => "TCS", :location => "Noida")
User.create(:name => "Innvoative View", :email => "admin@innov.com", :encrypted_password => "test", :role_type => "owner", :employee_id => "1")
User.create(:name => "MayankAdmin", :email => "nsit.mayankgupta@gmail.com", :encrypted_password => "test", :role_type => "admin", :client_id => c.id, :employee_id => "2")

User.create(:name => "Amit", :email => "amitdce123@gmail.com", :encrypted_password => "test", :role_type => "approver", :client_id => c.id, :employee_id => "3")

User.create(:name => "MayankSpoc", :email => "to.mayank89@gmail.com", :encrypted_password => "test", :role_type => "spoc", :client_id => c.id, :employee_id => "4")

User.create(:name => "Luminous", :email => "lum@vendor.com", :role_type => "vendor")
User.create(:name => "Bajaj", :email => "bajaj@vendor.com", :role_type => "vendor")

