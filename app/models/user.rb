class User < ActiveRecord::Base

  belongs_to :client
  belongs_to :subgroup

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

  def is_vendor?
    self.role_type == "vendor"
  end

  def is_admin_or_owner?
    is_admin? or is_owner?
  end

  def operators
    Operator.where(:vendor_id => id)
  end

end