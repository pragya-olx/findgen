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

	def is_spoc?
		self.role_type == "spoc"
	end

	def is_approver?
		self.role_type == "approver"
	end

	def is_admin_or_owner?
		is_admin? or is_owner?
	end

end