require 'json'

# methods go here

def start
  setup_files # load, read, parse, and create the files
  create_report # create the report!
end

def setup_files #method to open the JSON file and parse the data
    path = File.join(File.dirname(__FILE__), '../data/products.json')
    file = File.read(path)
    $products_hash = JSON.parse(file)
    $report_file = File.new("report.txt", "w+")
end

def create_report # start report generation
	sales_report_header
	print_date
	products_header
	parse_products
	brands_report_header
	parse_brands
end

def sales_report_header # Print "Sales Report" in ascii art
	$report_file.puts "  #####                                 ######                            "
	$report_file.puts " #     #   ##   #      ######  ####     #     # ###### #####   ####  #####  #####"
	$report_file.puts " #        #  #  #      #      #         #     # #      #    # #    # #    #   # "
	$report_file.puts "  #####  #    # #      #####   ####     ######  #####  #    # #    # #    #   # "
	$report_file.puts "       # ###### #      #           #    #   #   #      #####  #    # #####    #"
	$report_file.puts " #     # #    # #      #      #    #    #    #  #      #      #    # #   #    #  "
	$report_file.puts "  #####  #    # ###### ######  ####     #     # ###### #       ####  #    #   # "
	dividing_line
end

def dividing_line
	$report_file.puts "********************************************************************************"
end

def print_date # Print today's date
	time = Time.new
	$report_file.puts time.strftime("Current date: %m/%d/%Y")
end

def products_header # Print "Products" in ascii art
	$report_file.puts "                     _            _       "
	$report_file.puts "                    | |          | |      "
	$report_file.puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
	$report_file.puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
	$report_file.puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
	$report_file.puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
	$report_file.puts "| |                                       "
	$report_file.puts "|_|                                       "
	dividing_line
end

def parse_products
	$products_hash["items"].each do |toy| # For each product in the data set:
		print_item_data(toy)
		dividing_line
	end
end

def print_item_data(toy)
	$report_file.puts "Toy title: #{toy["title"]}" # Print the name of the toy
	$report_file.puts "Retail price: #{toy["full-price"]}" # Print the retail price of the toy
	$report_file.puts "Total number of purchases: #{toy["purchases"].length}" 	# Calculate and print the total number of purchases
	$report_file.puts "Total sales: #{calc_total_sales_products(toy)}" # Calculate and print the total amount of sales
	$report_file.puts "Average price: #{calc_total_sales_products(toy)/toy["purchases"].length}" # Calculate and print the average price the toy sold for
	$report_file.puts "Average discount: #{toy["full-price"].to_f-(calc_total_sales_products(toy)/toy["purchases"].length)}" # Calculate and print the average discount (% or $) based off the average sales price
end

def calc_total_sales_products(toy)
	total_sales = 0
	toy["purchases"].each { |purchase| total_sales = total_sales + purchase["price"]}
	return total_sales
end

def brands_report_header # Print "Brands" in ascii art
	$report_file.puts " _                         _     "
	$report_file.puts "| |                       | |    "
	$report_file.puts "| |__  _ __ __ _ _ __   __| |___ "
	$report_file.puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
	$report_file.puts "| |_) | | | (_| | | | | (_| \\__ \\"
	$report_file.puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
	$report_file.puts
	dividing_line
end

def parse_brands # For each brand in the data set:
	unique_brands = $products_hash["items"].map { |item| item["brand"] }.uniq
	unique_brands.each_with_index do | brand, index |
		print_brands_data(brand)
	end
end

def brands_items_data(brand)
	brands_items = $products_hash["items"].select { |item| item["brand"] == brand }
	return brands_items
end

def print_brands_data(brand)
	$report_file.puts "Brand: #{brand}" # Print the name of the brand
	
	total_stock_brand(brand)
	
	brand_average_price(brand)
	
	brand_sales(brand)
	
	dividing_line
end

def brand_sales(brand)	# Calculate and print the total sales volume of all the brand's toys combined
	brand_sales = 0											
	brands_items_data(brand).each do |item|
		item["purchases"].each do |count|
	        brand_sales += count["price"].to_f
	    end
	end
	$report_file.puts "Total sales of #{brand}: #{brand_sales.round(2)}"	# Calculate and print the total sales volume of all the brand's toys combined
end

def brand_average_price(brand)	# Calculate and print the average price of the brand's toys
	total_full_price_brand = 0																
	brands_items_data(brand).each do |toy|																	
		total_full_price_brand += toy["full-price"].to_f													
	end																	
	$report_file.puts "Average price of #{brand}: #{(total_full_price_brand/brands_items_data(brand).length).round(2)}"	
end

def total_stock_brand(brand)	# Count and print the number of the brand's toys we stock
	total_stock_brand = 0							
	brands_items_data(brand).each do |toy|		
		total_stock_brand += toy["stock"].to_i
	end								
	$report_file.puts "#{brand} on hand: #{total_stock_brand}"	
end

start
