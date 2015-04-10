Spree::Product.class_eval do

  add_search_scope :ascend_by_seller do
    joins(:seller).order("`spree_sellers`.name ASC")
  end

  add_search_scope :ascend_by_master_price do
    joins(:master => :default_price).order("#{price_table_name}.amount ASC")
  end

  add_search_scope :descend_by_master_price do
    joins(:master => :default_price).order("#{price_table_name}.amount DESC")
  end

  add_search_scope :price_between do |low, high|
    if !low.blank? and !high.blank?
      joins(:master => :default_price).where(Spree::Price.table_name => { :amount => low..high })
    else
      self.active
    end
  end

  add_search_scope :descend_by_popularity do
    joins(:master).includes(:line_items)
    order(%Q{
         COALESCE((
           SELECT
             COUNT(#{Spree::LineItem.quoted_table_name}.id)
           FROM
             #{Spree::LineItem.quoted_table_name}
           JOIN
             #{Spree::Variant.quoted_table_name} AS popular_variants
           ON
             popular_variants.id = #{Spree::LineItem.quoted_table_name}.variant_id
           WHERE
             popular_variants.product_id = #{Spree::Product.quoted_table_name}.id
         ), 0) DESC
      }).references(:line_items, :master)
  end


  add_search_scope :master_price_lte do |price|
    joins(:master => :default_price).where("#{price_table_name}.amount <= ?", price)
  end

  add_search_scope :master_price_gte do |price|
    joins(:master => :default_price).where("#{price_table_name}.amount >= ?", price)
  end


  add_search_scope :selective_with do |*value|
    includes(variants_including_master: :option_values).
      includes(:product_properties).
      where("#{Spree::OptionValue.table_name}.name in (?) OR #{Spree::ProductProperty.table_name}.value in (?)", value, value)
    .references(variants_including_master: :option_values).references(:product_properties)
  end

  add_search_scope :seller_any do |*opts|
    conds = opts.map {|o| o.to_i }
    includes(:seller).where("spree_products.seller_id in (?)", conds).references(:seller)
  end

  add_search_scope :brand_any do |*opts|
    conds = opts.map {|o| o.to_i }
    includes(:brand).where("spree_products.brand_id in (?)", conds).references(:brand)
  end

  # add_search_scope :brand_scope do |*opts|
  #   conds = opts.map {|o| o.to_i }
  #   in_taxons(conds)
  # end

  add_search_scope :ascend_by_seller do
    joins(:seller).order("`spree_sellers`.name ASC")
  end

  add_search_scope :selective_simple_scope do |*opts|
    # return default sort if there is many sorts
    cond = Spree::Product.descend_by_master_price.values[:order]
    return Spree::Product.joins(:master).order(cond) if (opts.nil? || opts.length != 1)

    if opts.include?'seller_ascending'
      joins(:seller).order("`spree_sellers`.name ASC")
    else
      cond = Spree::Core::ProductFilters.simple_scopes[:conds][opts.shift]
      Spree::Product.joins(:master).order(cond)
    end

  end

end
