module OmbuLabs
  module Auth
    class Engine < ::Rails::Engine
      isolate_namespace OmbuLabs::Auth
    end
  end
end
