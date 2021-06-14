class ExceptionPresenter < SimpleDelegator
  include Swagger::Blocks

  swagger_schema :Error do
    key :required, [:code, :message, :type]
    property :code do
      key :type, :string
    end
    property :message do
      key :type, :string
    end
    property :type do
      key :type, :string
    end
  end

  def initialize(request, object)
    @request = request
    super(object)
  end

  def status_code
    Rack::Utils::SYMBOL_TO_STATUS_CODE[code]
  end

  def code
    object.respond_to?(:code) ? super : status_symbol
  end

  def message
    object.respond_to?(:message) ? super : 'Something went wrong'
  end

  def type
    object.respond_to?(:type) ? super : object.class.to_s.underscore
  end
  
  def as_json
    {
      code: code,
      message: message, 
      type: type
    }
  end

  def to_json(*args)
    as_json.to_json
  end

  def object
    __getobj__
  end

  def persisted?
    false
  end

  private

  def status_symbol
    Rack::Utils::SYMBOL_TO_STATUS_CODE.invert[Integer(@request.path.delete('/'))] || :internal_server_error
  end

end
