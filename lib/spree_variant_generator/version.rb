module SpreeVariantGenerator
  VERSION = '1.0.0'.freeze

  module_function

  # Returns the version of the currently loaded SpreeVariantGenerator as a
  # <tt>Gem::Version</tt>.
  def version
    Gem::Version.new VERSION
  end
end
