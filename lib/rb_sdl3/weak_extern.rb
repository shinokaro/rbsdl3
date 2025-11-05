# frozen_string_literal: true

module RbSDL3
  module WeakExtern
    def extern(signature, *opts)
      super
    rescue Fiddle::DLError => e
      name = signature.match(/(?<name>\w+)(?=\s*\()/)&.[](:name)
      begin
        import_symbol(name)
        raise e
      rescue Fiddle::DLError
        warn <<-EOS, uplevel: 3
missing symbol (expected on some platforms or versions); continuing: #{name}()
        EOS
      end 
    end
  end
end
