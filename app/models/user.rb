class User < ActiveRecord::Base

	belongs_to :client

	def authenticate(val)
		self.encrypted_password == val
	end

	def is_owner?
		self.role_type == "owner"
	end

	def is_admin?
		self.role_type == "admin"
	end

end