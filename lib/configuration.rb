module Configuration
  extend self

  def parameter *params
    params.each do |param|
      attr_accessor param
      #define_method name do |*values|
        #value = values.first
        #value ? self.send("#{name}=", value) : instance_variable_get("@#{name}")
      #end
    end
  end

  def config(&block)
    instance_eval &block
  end
end
