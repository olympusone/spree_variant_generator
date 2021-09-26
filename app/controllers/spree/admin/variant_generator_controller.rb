module Spree
    module Admin
        class VariantGeneratorController < BaseController
            include Spree::Admin::ProductConcern

            def new
                @product = Spree::Product.find_by(slug: params[:id])
                @variant = @product.master
                @tax_categories = TaxCategory.order(:name)
            end

            def create
                product = Spree::Product.find_by(slug: params[:id])

                option_value_ids = variant_params[:option_value_ids].reject(&:empty?).map(&:to_i)

                groups = Spree::OptionValue.where(id: option_value_ids)
                    .select("option_type_id, array_agg(id) AS ids")
                    .group(:option_type_id).map(&:ids)
                
                if groups.empty?
                    raise Exception.new I18n.t("errors.variant_generator.empty_option_value_ids", {
                        option_types: Spree.t(:option_types)
                    }) 
                end

                combinations = groups.first.product(*groups.drop(1))

                attributes = variant_params.except(:option_value_ids)

                existing_variant_option_ids = product.variants.map(&:option_value_ids).reject(&:empty?)

                Spree::Variant.transaction do
                    combinations.each do |combo|
                        unless existing_variant_option_ids.include?(combo)
                            variant = product.variants.build(attributes)
                            variant.option_value_ids = combo
                            variant.generated = true
                            variant.save!
                        end
                    end

                    flash[:success] = I18n.t('variant_generator.form.success')
                    redirect_to admin_product_variants_url(product)
                end
            rescue Exception => exception
                flash[:error] = exception
                redirect_back(fallback_location: admin_product_variants_url(product))
            rescue ActiveRecord::RecordInvalid => exception
                flash[:error] = exception
                redirect_back(fallback_location: admin_product_variants_url(product))
            end

            private
            def variant_params
                params.require(:variant).permit(:sku, :price, :compare_at_price, :cost_price, :tax_category_id,
                     :discontinue_on, :weight, :height, :width, :depth, option_value_ids: [])
            end
        end
    end
end