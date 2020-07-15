class ApplicationPolicy
  class << self
    def enforce!(args = {})
      args.each_pair do |policy, policy_methods|
        policy.enforce!(*policy_methods)
      end
    end
  end

  attr_reader :user, :record

  def initialize(user, record = nil)
    @user   = user
    @record = record
  end

  def enforce!(*policy_methods)
    policy_methods.each do |policy_method_and_args|
      next if self.send(*policy_method_and_args)
    end
  end

  def manage?(domain)
    has_permissions?("manage_#{domain}")
  end

  private

  def has_permissions?(*permission_names)
    @user.permissions.where(name: permission_names).exists?
  end
end
