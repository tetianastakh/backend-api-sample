namespace :data_migrations do
  desc 'Creates or updates all permissions'
  task(seed_permissions: :environment) do
    permissions_to_create.each do |permission_attrs|
      next if Account::Permission.exists?(name: permission_attrs[:name])

      permission = Account::Permission.create(permission_attrs)

      unless permission.valid?
        puts "Failed to create '#{permission_attrs[:name]}' permission:"
        puts "\t#{permission.errors.full_messages}"
      end
    end
  end

  private

  def permissions_to_create
    [
      ##########################################################################
      # Accounts
      ##########################################################################
      {
        name: :manage_users,
        description: 'Able to manage all users'
      },
      {
        name: :read_companies,
        description: 'Able to view your current company'
      },
      {
        name: :write_companies,
        description: 'Able to update your company'
      },
      {
        name: :read_roles,
        description: 'Able to view your company\'s roles'
      },
      {
        name: :write_roles,
        description: 'Able to create, update, and destroy your company\'s roles'
      },
      {
        name: :read_users,
        description: 'Able to view your company\'s users'
      },
      {
        name: :write_users,
        description: 'Able to create, update, and destroy your company\'s users'
      },
      {
        name: :read_permissions,
        description: 'Able to view permissions for your company'
      }
    ]
  end
end
