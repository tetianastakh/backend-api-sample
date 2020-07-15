module Accounts
  class BaseService
    class << self
      def find(current_user, id)
        query = scope_to_current_company(current_user, id)
        item  = item_class.find_by(query)

        raise ::Exceptions::RecordNotFound.new unless item

        item
      end

      private

      def scope_to_current_company(user, id)
        query = { id: id }
        return query if user.is_admin?
        return query.merge(company_id: user.company.id)
      end

      def item_class
        raise 'For subclesses only!'
      end
    end
  end
end
