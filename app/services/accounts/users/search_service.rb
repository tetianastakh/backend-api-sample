module Accounts
  module Users
    class SearchService
      def perform(user, options = {})
        options = default_opts.merge(options.to_h).with_indifferent_access

        users = User.all
        users = filter(users, options)
        users = search_based_on_query(users, options)
        users = order_and_paginate(users, options)

        return users
      end

      private

      def default_opts
        {
          q: nil,
          role: nil,
          page: 1,
          per_page: 10,
          field: 'created_at',
          direction: 'DESC'
        }.with_indifferent_access
      end

      def filter(users, options)
        users = users.where(role: options[:role]) if options[:role].present?
        users = filter_by_company_id(users, options[:company_id]) if options[:company_id].present?

        return users
      end

      def search_based_on_query(users, options)
        if options[:q]
          fields = %w[first_name last_name email phone_number full_name]
          ransack_string = fields.join('_or_').concat('_cont')
          users = users.ransack(ransack_string.to_sym => options[:q]).result
          users = users.seek(options[:q]).result if users.nil?
        end

        return users
      end

      def order_and_paginate(users, options)
        if options[:field] && options[:direction]
          users = users.order(options[:field] => options[:direction])
        end

        return users if options[:per_page] == 'ALL'

        if options[:page] && options[:per_page]
          users = users.paginate(options.slice(:page, :per_page))
        end

        return users
      end

      private
      
      def filter_by_company_id(users, company_id)
        users.joins(:company_user).where(companies_users: { company_id: company_id })
      end
    end
  end
end