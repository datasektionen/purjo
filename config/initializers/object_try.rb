class Object
  def try (method, *args)
    send(method, *args) if respond_to?(method)
  end
end
