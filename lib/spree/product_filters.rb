#  all logic in overrides


# module Spree
#   module Core
#     module ProductFilters

#       # Spree::Product.add_search_scope :selective_with do |*value|
#       #   includes(variants_including_master: :option_values).
#       #     includes(:product_properties).
#       #     where("#{OptionValue.table_name}.name in (?) OR #{ProductProperty.table_name}.value in (?)", value, value)
#       #   .references(variants_including_master: :option_values).references(:product_properties)
#       # end
#       # Spree::Product.add_search_scope :seller_any do |*opts|
#       #   conds = opts.map {|o| o.to_i }
#       #   includes(:seller).where("spree_products.seller_id in (?)", conds)
#       # end
#       # Spree::Product.add_search_scope :brand_scope do |*opts|
#       #   conds = opts.map {|o| o.to_i }
#       #   Spree::Product.in_taxons(conds)
#       # end
#       # Spree::Product.add_search_scope :price_between do |low, high|
#       #   if !low.blank? and !high.blank?
#       #     joins(:master => :default_price).where(Price.table_name => { :amount => low..high })
#       #   end 
#       #   self.active
#       # end
      
#       # Spree::Product.add_search_scope :ascend_by_seller do 
#       #   joins(:seller).order("`spree_sellers`.name ASC")
#       # end      

#       # Spree::Product.add_search_scope :selective_simple_scope do |*opts|
#       #   # return default sort if there is many sorts
#       #   cond = Spree::Product.descend_by_master_price.values[:order]
#       #   return Spree::Product.joins(:master).order(cond) if (opts.nil? || opts.length != 1)

#       #   if opts.include?'seller_ascending'
#       #     joins(:seller).order("`spree_sellers`.name ASC")
#       #   else
#       #     cond = Spree::Core::ProductFilters.simple_scopes[:conds][opts.shift]
#       #     Spree::Product.joins(:master).order(cond)
#       #   end

#       # end


#       # def ProductFilters.price_filter(taxon)
#       #   values = taxon.min_max
#       #   {
#       #     :name => Spree.t("price_filter"),
#       #     :scope => :price_between,
#       #     :labels => values
#       #   }
#       # end

#       def ProductFilters.option_filter( option_type, taxon)
#         values = Spree::OptionValue.in_taxon(taxon, option_type).order("position").map(&:name).compact.uniq
#         {
#           :name => option_type.presentation,
#           :scope => :selective_with,
#           :labels => values.map { |k| [k, k] }
#         }
#       end

#       def ProductFilters.seller_filter(taxon)
#         taxon ||= Spree::Taxonomy.first.root
#         scope = Spree::Seller.in_taxon(taxon)
#         {
#           name:   Spree.t("seller"),
#           scope:  :seller_any,
#           labels: scope.map  { |t| [t.name, t.id] },
#           conds:  nil
#         }
#       end

#       def ProductFilters.brand_filter(taxon)
#         #taxon ||= Spree::Taxonomy.first.root
#         scope = taxon.brands_in_taxon
#         {
#           name:   Spree.t("brand"),
#           scope:  :brand_scope,
#           labels: scope.map  { |t| [t.name, t.id] },
#           conds:  nil
#         }
#       end
      
#       def ProductFilters.simple_scopes
#         conds = [ ["price_ascending",   Spree::Product.ascend_by_master_price.values[:order]],
#                   ["price_descending",  Spree::Product.descend_by_master_price.values[:order]],
#                   ["seller_ascending",   Spree::Product.ascend_by_seller.values[:order]],
#                   ["newest",          Spree::Product.ascend_by_updated_at.values[:order]],
#                   ["popularity",        Spree::Product.descend_by_popularity.values[:order]] ]
#         {
#           name:   Spree.t('sort_by'),
#           scope:  :selective_simple_scope,
#           labels: conds.map { |k,v| [k, Spree.t(k)] },
#           conds:  Hash[*conds.flatten]
#         }
#       end

#     end
#   end
# end
