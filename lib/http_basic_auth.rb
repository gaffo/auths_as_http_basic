module HttpBasicAuth

  def self.included(base)
    base.extend ActMacro
  end

  module ActMacro
    def authenticates_via_http_basic(class_to_check, username_field, password_field, options = {})
      self.send(:include, HttpBasicAuth::InstanceMethods)

      class_inheritable_reader :http_basic_auth__class_to_check
      write_inheritable_attribute :http_basic_auth__class_to_check, class_to_check

      class_inheritable_reader :http_basic_auth__username_field
      write_inheritable_attribute :http_basic_auth__username_field, username_field

      class_inheritable_reader :http_basic_auth__password_field
      write_inheritable_attribute :http_basic_auth__password_field, password_field

      class_inheritable_reader :http_basic_auth__conditions
      write_inheritable_attribute(:http_basic_auth__conditions, (options[:conditions] || {}))

      before_filter :http_basic_auth_before_filter
    end
  end

  module InstanceMethods

    def http_basic_auth_before_filter
      authenticate_or_request_with_http_basic do |user_name, password|
        model_to_check = self.http_basic_auth__class_to_check.to_s.classify.constantize
        conditions = {http_basic_auth__username_field => user_name,
                      http_basic_auth__password_field => password}
        conditions.merge!(http_basic_auth__conditions)
        user = model_to_check.find(:first, :conditions => http_basic_auth__conditions)
        user.nil? ? false : true
      end
    end

  end

end