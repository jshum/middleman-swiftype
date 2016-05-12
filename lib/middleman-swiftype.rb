require "middleman-core"

require "middleman-swiftype/commands"

require "middleman-swiftype/extension"
::Middleman::Extensions.register(:swiftype, ::Middleman::Swiftype::Extension)