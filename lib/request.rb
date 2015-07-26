class Request
  attr_reader :verb, :path, :file_path, :type, :status

  def initialize(request_line)
    request = request_line.split(" ")
    @verb = request[0].downcase
    @path = request[1].downcase

    file_path = File.join(WEB_ROOT, @path)
    if File.exist?(file_path) && !File.directory?(file_path)
      @type = :file
      @status = 200
      @file_path = file_path
    elsif route_exists?(route)
      @type = :route
      @status = 200
    else
      @type = :not_found
      @status = 404
    end

  end

  def route
    "#{verb} #{path}"
  end

  def proc
    $routes.fetch(self.route)
  end
end
