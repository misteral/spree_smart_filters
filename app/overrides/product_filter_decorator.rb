module Spree
  module Core
    ProductFilters.module_eval do


      ####################################  - smart filters - #######################################


      def ProductFilters.option_filter_products(products, option_type)
        values = products.with_option(option_type).map(&:variants_including_master).flatten.map{|n| n.option_values.detect { |o| o.option_type == option_type}}.flatten.uniq.compact
        values.sort_by! {|obj| obj.position}
        if !values.blank?
          {
            :name => option_type.presentation,
            :scope => :selective_with,
            :labels => values.map { |k| [k.name, k.name] }
          }
        end
      end

      def ProductFilters.seller_filter_products(products)
        scope = products.map(&:seller).uniq.compact
        {
          name:   Spree.t("seller"),
          scope:  :seller_any,
          labels: scope.map  { |t| [t.name, t.id] },
          conds:  nil
        }
      end

      def ProductFilters.brand_filter_products(products)
        scope = products.map(&:brand).uniq.compact
        scope.sort_by! {|obj| obj.name}
        if scope.first.present?
          {
            name:   Spree.t("brand"),
            scope:  :brand_any,
            labels: scope.map  { |t| [t.name, t.id] },
            conds:  nil
          }
        end
      end

      def ProductFilters.price_filter_products(products)
        products_price = products.map(&:price)
        values = [products_price.min.to_i, products_price.max.to_i]
        {
          :name => Spree.t("price_filter"),
          :scope => :price_between,
          :labels => values
        }
      end



      ####################################  - taxon filters - #######################################

      def ProductFilters.price_filter(taxon)
        values = taxon.min_max
        {
          :name => Spree.t("price_filter"),
          :scope => :price_between,
          :labels => values
        }
      end

      def ProductFilters.option_filter( option_type, taxon)
        values = Spree::OptionValue.in_taxon(taxon, option_type).order("position").map(&:name).compact.uniq
        {
          :name => option_type.presentation,
          :scope => :values_any,
          :labels => values.map { |k| [k, k] }
        }
      end

      def ProductFilters.seller_filter(taxon)
        taxon ||= Spree::Taxonomy.first.root
        scope = Spree::Seller.in_taxon(taxon)
        {
          name:   Spree.t("seller"),
          scope:  :seller_any,
          labels: scope.map  { |t| [t.name, t.id] },
          conds:  nil
        }
      end

      def ProductFilters.brand_filter(taxon)
        taxon ||= Spree::Taxonomy.first.root
        scope = Spree::Brand.in_taxon(taxon)
        {
          name:   Spree.t("brand"),
          scope:  :brand_any,
          labels: scope.map  { |t| [t.name, t.id] },
          conds:  nil
        }
      end

      def ProductFilters.simple_scopes
        conds = [ ["price_ascending",   Spree::Product.ascend_by_master_price.values[:order]],
                  ["price_descending",  Spree::Product.descend_by_master_price.values[:order]],
                  ["seller_ascending",   Spree::Product.ascend_by_seller.values[:order]],
                  ["newest",          Spree::Product.ascend_by_updated_at.values[:order]],
                  ["popularity",        Spree::Product.descend_by_popularity.values[:order]] ]
        {
          name:   Spree.t('sort_by'),
          scope:  :selective_simple_scope,
          labels: conds.map { |k,v| [k, Spree.t(k)] },
          conds:  Hash[*conds.flatten]
        }
      end

    end
  end
end
