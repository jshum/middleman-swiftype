# Require core library
require "middleman-core"

# Extension namespace
module Middleman
  module Swiftype

    class << self
      attr_accessor :swiftype_options
    end

    class Options < Struct.new(:api_key, :engine_slug, :pages_selector, :process_html, :generate_sections, :generate_info, :generate_image, :title_selector, :should_index); end

    # For more info, see https://middlemanapp.com/advanced/custom_extensions/
    class Extension < Middleman::Extension

      # config_name, default_value, description, required : true or false
      option :api_key, '', 'API key for swiftype', required: true
      option :engine_slug, '', 'Engine slug for switype', required: true
      option :pages_selector, '', 'Pages selector method call'
      option :title_selector, false, 'Title selector method call'
      option :process_html, false, 'Process html method call'
      option :generate_sections, false, 'Generate section method call'
      option :generate_info, '', 'Generate info method call'
      option :generate_image, false, 'Generate image method call'
      option :should_index, false, 'Should index method call'

      # create app.swiftype
      def swiftype(options=nil)
        @_swiftype ||= Struct.new(:options).new(options)
      end

      def initialize(app, options_hash={}, &block)
        super

        options = Options.new(options_hash)
        yield options if block_given?

        options.pages_selector ||= lambda { |p| p.path.match(/\.html/) && p.template? && !p.directory_index? }
      end

      def after_configuration
        swiftype(options)
        # swiftype_options are saved as a class attribute when middleman configurations are loaded
        ::Middleman::Swiftype.swiftype_options = options
      end

      def after_build(builder)
          helper = MiddlemanSwiftypeHelper.new app, options
          helper.generate_search_json
      end

    end

  end
end
