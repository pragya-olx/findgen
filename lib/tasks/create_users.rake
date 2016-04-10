namespace :users do

  desc "Add new roles for users"
  task :create => :environment do
    # admin_role = Role.find_or_create_by_name(Role::ADMIN)
    # junior_admin_role = Role.find_or_create_by_name(Role::JUNIOR_ADMIN)
    # read_only_role = Role.find_or_create_by_name(Role::READ_ONLY)

    User.create(:name => ENV['name'],
    	:email => ENV['email'],
    	:encrypted_password => ENV['password'],
    	:role_type => ENV['role_type'],
    	:client_id => ENV['client_id']
    )

  end

end