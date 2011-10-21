require "savon"

require "tec_doc/version"

module TecDoc
  extend self

  autoload :Client,               "tec_doc/client"

  autoload :Brand,                "tec_doc/brand"
  autoload :Language,             "tec_doc/language"
  autoload :VehicleManufacturer,  "tec_doc/vehicle_manufacturer"
  autoload :VehicleModel,         "tec_doc/vehicle_model"

  attr_accessor :client
end