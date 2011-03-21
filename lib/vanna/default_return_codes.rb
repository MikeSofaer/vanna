module DefaultReturnCodes
  def self.included(klass)
    klass.post_process :json do
      def post_create(response)
        if response.is_a? Hash
          Vanna::Response.new :status => 201, :body => response
        else
          response
        end
      end
    end
  end
end
