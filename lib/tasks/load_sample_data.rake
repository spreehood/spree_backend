namespace :db do
  desc 'Load sample data'
  task load_sample_data: :environment do
    csv_file_path = Rails.root.join('lib', 'tasks', 'sample.csv')
    batch_size = 1000
    rows = []
    batch = 0
    duplicate_rows = {}

    CSV.foreach(csv_file_path, headers: true) do |row|
      if row['duplicate'] == 'True'
        duplicate_rows[row['name']] ||= []
        duplicate_rows[row['name']] << row
        next
      end

      rows << row
      if rows.size >= batch_size
        batch += 1
        puts "Batch #{batch}"
        process_batch(rows)
        rows.clear
      end
    end
    process_batch(rows) unless rows.empty?
    process_duplicate(duplicate_rows)
  end
end

def process_batch(rows)
  products_to_import = []
  product_stores = []
  product_images = []
  product_classifications = []
  rows.each do |row|
    main_category = row['main_category']
    store = find_or_create_store(main_category)
    taxonomy = find_or_create_taxonomy(store)
    details = JSON.parse(row['details'])
    categories = parse_categories(row['categories'])
    default_shipping_category = Spree::ShippingCategory.find_or_create_by!(name: 'Default')

    product_stores << { store_id: store.id, sku: row['sku'] }
    product_images << { image: instantiate_image(row['image']), sku: row['sku'] }
    products_to_import << Spree::Product.new(name: row['name']) do |product|
      product.price = row['price']
      product.description = row['description']
      product.available_on = row['available_on']
      product.make_active_at = Time.zone.now
      product.status = 'active'
      product.shipping_category = default_shipping_category
      product.sku = row['sku']
      product.vendor = find_or_instantiate_vendor(details['Brand']) if details['Brand']
      product.reviews << Spree::Review.new(rating: row['rating'].to_i, name: 'Anonymous', review: "review")
      details.each do |key, value|
        next if value.blank? || !value.is_a?(String) || key.blank?
        property = Spree::Property.find_or_create_by!(name: key, presentation: key)
        product.product_properties << Spree::ProductProperty.new(property: property, value: value)
      end

      prev_taxon = taxonomy.taxons.find_by(parent_id: nil)
      categories.each do |category|
        next if category == row['main_category']

        prev_taxon = Spree::Taxon.find_or_create_by!(name: category, parent: prev_taxon, taxonomy: taxonomy)
        product.classifications << Spree::Classification.new(taxon: prev_taxon)
      end
      product.run_callbacks(:save) { false }
    end
  end

  # there will me some duplicate slugs due to inconstancy in name
  products_to_import = products_to_import.uniq { |product| product.slug }

  Spree::Product.import(products_to_import, recursive: true, validate: false)

  Spree::StoreProduct.import(
    product_stores.filter_map do |p|
      product_id = Spree::Product.joins(:master).find_by(master: { sku: p[:sku] })&.id
      { product_id:, store_id: p[:store_id] } if product_id
    end
  )
  product_images.each do |image|
    next if image[:image].blank?

    product = Spree::Product.joins(:master).find_by(master: { sku: image[:sku] })
    next unless product

    product.images << image[:image]
  end
end

def process_duplicate(rows)
  puts 'processing duplicates'

  option_type_cache = {}
  products_dont_need_variant = []
  products_to_import = []
  product_stores = []
  product_images = []
  product_classifications = []
  product_option_types = []
  i = 0
  rows.each do |item, list|
    i += 1
    break if i > 100
    all_details = {}
    list.each do |entry|
      details = JSON.parse(entry['details'])
      details.each do |key, value|
        next if value.blank? || !value.is_a?(String) || key.blank?

        all_details[key] ||= []
        all_details[key] << value
      end
    end

    details_for_options  = all_details.filter do |key, value|
      not_required = [
        'Brand',
        'Item Weight',
        'Item Dimensions',
        'Date First Available',
        'Package Dimensions',
        'Department',
        'Product Dimensions',
        'Item model number',
        'Brand Name',
        'Part Number',
        'Item Dimensions LxWxH',
        'Item Package Dimensions L x W x H',
        'Assembled Height',
        'Assembled Length',
        'Assembled Width',
      ].include?(key)
      value.map(&:downcase).uniq.length  != 1 && !not_required
    end

    details_for_options.each do |key, value|
      next if Spree::OptionType.find_by(name: key)

      option_type_cache[key.downcase] ||= {
        option_type: Spree::OptionType.find_or_initialize_by(name: key.downcase, presentation: key),
        values: [],
      }

      option_type = option_type_cache[key.downcase][:option_type]
      value.uniq.each do |val|
        next if option_type_cache[key.downcase][:values].include?(val.downcase)
        option_type.option_values << Spree::OptionValue.find_or_initialize_by(name: val, presentation: val)
      end

      option_type_cache[key.downcase][:values] += value.uniq.map(&:downcase)
    end

    if details_for_options.empty?
      products_dont_need_variant << list[0]
    else
      option_keys = details_for_options.keys
      row = list[0]
      main_category = row['main_category']
      store = find_or_create_store(main_category)
      taxonomy = find_or_create_taxonomy(store)
      details = JSON.parse(row['details'])
      categories = parse_categories(row['categories'])
      default_shipping_category = Spree::ShippingCategory.find_or_create_by!(name: 'Default')

      product_stores << { store_id: store.id, sku: row['sku'] }
      product_images << { image: instantiate_image(row['image']), sku: row['sku'] }
      products_to_import << {
        product: Spree::Product.new(name: row['name']) do |product|
          product.price = row['price']
          product.description = row['description']
          product.available_on = row['available_on']
          product.make_active_at = Time.zone.now
          product.status = 'active'
          product.shipping_category = default_shipping_category
          product.sku = row['sku']
          product.vendor = find_or_instantiate_vendor(details['Brand']) if details['Brand']
          product.reviews << Spree::Review.new(rating: row['rating'].to_i, name: 'Anonymous', review: "review")
          details.each do |key, value|
            next if value.blank? || !value.is_a?(String) || key.blank? || option_keys.include?(key)

            property = Spree::Property.find_or_create_by!(name: key, presentation: key)
            product.product_properties << Spree::ProductProperty.new(property: property, value: value)
          end

          prev_taxon = taxonomy.taxons.find_by(parent_id: nil)
          categories.each do |category|
            next if category == row['main_category']

            prev_taxon = Spree::Taxon.find_or_create_by!(name: category, parent: prev_taxon, taxonomy: taxonomy)
            product.classifications << Spree::Classification.new(taxon: prev_taxon)
          end

          product.run_callbacks(:save) { false }
        end,
        variants: list,
        product_option_types: option_keys.map(&:downcase)
      }
    end
  end

  Spree::OptionType.import(option_type_cache.values.map{|v| v[:option_type]}, validate: false, recursive: true) if option_type_cache.present?
  products_to_import = products_to_import.map do |product_info|
    product = product_info[:product]
    product_info[:product_option_types].each do |option|
      option_type = Spree::OptionType.find_by(name: option)
      next unless option_type
      product.product_option_types << Spree::ProductOptionType.new(option_type: option_type)
    end
    variants = []
    product_info[:variants].each_with_index do |row, i|
      sku = i == 0 ?  "#{row['sku']}-#{i}": row['sku']
      variant = Spree::Variant.new(
        sku: sku,
        cost_price: row['price'].to_f,
        cost_currency: 'USD'
      )
      details = JSON.parse(row['details'])
      variant.vendor = find_or_instantiate_vendor(details['Brand']) if details['Brand']
      details.each do |key, value|
        if product_info[:product_option_types].include?(key.downcase)
          option_type = Spree::OptionType.find_by(name: key.downcase)
          option_value = Spree::OptionValue.find_by(name: value.downcase, option_type: option_type)
          next unless option_value && option_type

          variant.option_value_variants << Spree::OptionValueVariant.new(option_value: option_value)
        end
      end
      variants << variant if variant.option_value_variants.present?
    end
    product.variants = variants
    product
  end
  Spree::Product.import(products_to_import, recursive: true, validate: false)

  Spree::StoreProduct.import(
    product_stores.filter_map do |p|
      product_id = Spree::Product.joins(:master).find_by(master: { sku: p[:sku] })&.id
      { product_id:, store_id: p[:store_id] } if product_id
    end
  )
  product_images.each do |image|
    next if image[:image].blank?

    product = Spree::Product.joins(:master).find_by(master: { sku: image[:sku] })
    next unless product

    product.images << image[:image]
  end
  process_batch(products_dont_need_variant)
end

def find_or_create_store(name)
  code = name.downcase.gsub(' ', '').gsub(',', '')
  @store_cache ||= {}
  @store_cache[code] ||= Spree::Store.find_or_create_by!(code: code) do |store|
    store.name = name
    store.checkout_zone = Spree::Zone.find_by(name: 'North America')
    store.default_country = Spree::Country.find_by(iso: 'US')
    store.default_currency = 'USD'
    store.supported_currencies = 'USD'
    store.supported_locales = 'en,fr'
    store.default_locale = 'en'
    store.url = Rails.env.development? ? "#{code}.lvh.me:4000" : "demo-#{code}.spreecommerce.org"
    store.mail_from_address = "#{code}@example.com"
  end
end

def find_or_create_taxonomy(store)
  @taxonomy_cache ||= {}
  @taxonomy_cache[store.id] ||= Spree::Taxonomy.find_or_create_by!(store: store) do |taxonomy|
    taxonomy.name = store.name
  end
end

def find_or_instantiate_vendor(name)
  @vendor_cache ||= {}
  @vendor_cache[name] ||= Spree::Vendor.find_by(name: name) || Spree::Vendor.new(name: name)
rescue ActiveRecord::RecordInvalid
  nil
end

def instantiate_image(image_url)
  Spree::Image.new(
    attachment: { io: URI.parse(image_url).open, filename: File.basename(URI.parse(image_url).path) }
  )
rescue => e
  nil
end

def parse_categories(categories)
  JSON.parse(categories.gsub("'", '"'))
rescue => e
  []
end
