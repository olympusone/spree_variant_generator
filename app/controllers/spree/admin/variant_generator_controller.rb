module Spree
    module Admin
        class VariantGeneratorController < BaseController
            include Spree::Admin::ProductConcern

            def new
                @product = Spree::Product.find_by(slug: params[:id])
            end
        end
    end
end