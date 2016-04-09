class User < ActiveRecord::Base

	def authenticate(val)
		self.encrypted_password == val
	end

end