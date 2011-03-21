module DefaultRedirects
  def self.included(klass)
    klass.post_process :html do
      def post_create(response)
        if response.is_a? Hash
          path_name = self.class.superclass.name.underscore.gsub("_controller","")
          Vanna::Response.new :status => 301, :location => "/#{path_name}/#{response[:id]}"
        else
          response
        end
      end
    end
  end
end
