module Accounts
  class UserRepository < ::BaseRepository
    class << self
      def search(options = {})
        options = default_opts.merge(options.to_h).with_indifferent_access

        users = User.all
        users = filter(users, options)
        users = order(users, options)

        paginate(users, options)
      end

      private

      def default_opts
        {
          page: 1,
          per_page: 10,
          field: 'created_at',
          direction: 'DESC'
        }.with_indifferent_access
      end

      def filter(users, options)
        users = users.where(id: options[:id]) if options[:id]

        return users
      end
    end
  end
end
