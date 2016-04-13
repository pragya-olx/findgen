namespace :locations do

  desc "Add locations"
  task :load => :environment do
    # admin_role = Role.find_or_create_by_name(Role::ADMIN)
    # junior_admin_role = Role.find_or_create_by_name(Role::JUNIOR_ADMIN)
    # read_only_role = Role.find_or_create_by_name(Role::READ_ONLY)

    file = File.read('/tmp/cities1.json')
    data_hash = JSON.parse(file)

    data_hash.each do |k,v|
    end
  end

end