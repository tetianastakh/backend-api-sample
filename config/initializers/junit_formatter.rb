module RSpecJUnitFormatterExtension
  def self.included(base)
    base.class_eval do
      def classname_for(notification)
        fp = example_group_file_path_for(notification)
        fp[2..-1].sub(%r{\.[^/]*\Z}, "").gsub(%r{\A\.+|\.+\Z}, "") + '.rb'
      end
    end
  end
end

RSpecJUnitFormatter.send(:include, RSpecJUnitFormatterExtension)
