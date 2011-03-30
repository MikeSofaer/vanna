module DefaultRedirects
  def self.included(klass)
    klass.instance_eval do
      def redirect_on(from_method, opts)
        to_method = opts[:to]
        post_process :html do
          define_method "post_#{from_method}".to_sym  do |response|
            if response.is_a? Hash
              path_name = self.class.superclass.name.underscore.gsub("_controller","")
              location =
                if to_method == :show
                  "/#{path_name}/#{response[:id]}"
                elsif to_method == :index
                  "/#{path_name}"
                end
              Vanna::Response.new :status => 301, :location => location
            else
              response
            end
          end
        end
      end
    end
    klass.redirect_on :create, :to => :show
  end
end
