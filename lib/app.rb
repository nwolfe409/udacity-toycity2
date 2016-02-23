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
	puts "  #####                                 ######                            "
	puts " #     #   ##   #      ######  ####     #     # ###### #####   ####  #####  #####"
	puts " #        #  #  #      #      #         #     # #      #    # #    # #    #   # "
	puts "  #####  #    # #      #####   ####     ######  #####  #    # #    # #    #   # "
	puts "       # ###### #      #           #    #   #   #      #####  #    # #####    #"
	puts " #     # #    # #      #      #    #    #    #  #      #      #    # #   #    #  "
	puts "  #####  #    # ###### ######  ####     #     # ###### #       ####  #    #   # "
	dividing_line
end

def dividing_line
	puts "********************************************************************************"
end

def print_date # Print today's date
	time = Time.new
	puts time.strftime("Current date: %m/%d/%Y")
end

def products_header # Print "Products" in ascii art
	puts "                     _            _       "
	puts "                    | |          | |      "
	puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
	puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
	puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
	puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
	puts "| |                                       "
	puts "|_|                                       "
	dividing_line
end

def parse_products
	$products_hash["items"].each do |toy| # For each product in the data set:
		print_item_data(toy)
		dividing_line
	end
end

def print_item_data(toy)
	puts "Toy title: #{toy["title"]}" # Print the name of the toy
	puts "Retail price: #{toy["full-price"]}" # Print the retail price of the toy
	puts "Total number of purchases: #{toy["purchases"].length}" 	# Calculate and print the total number of purchases
	puts "Total sales: #{calc_total_sales_products(toy)}" # Calculate and print the total amount of sales
	puts "Average price: #{calc_total_sales_products(toy)/toy["purchases"].length}" # Calculate and print the average price the toy sold for
	puts "Average discount: #{toy["full-price"].to_f-(calc_total_sales_products(toy)/toy["purchases"].length)}" # Calculate and print the average discount (% or $) based off the average sales price
end

def calc_total_sales_products(toy)
	total_sales = 0
	toy["purchases"].each do |purchase|
		total_sales = total_sales + purchase["price"]
	end
	return total_sales
end

def brands_report_header # Print "Brands" in ascii art
	puts " _                         _     "
	puts "| |                       | |    "
	puts "| |__  _ __ __ _ _ __   __| |___ "
	puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
	puts "| |_) | | | (_| | | | | (_| \\__ \\"
	puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
	puts
	dividing_line
end

def parse_brands # For each brand in the data set:
	unique_brands = $products_hash["items"].map { |item| item["brand"] }.uniq
	  unique_brands.each_with_index do | brand, index |

	    brands_toys = $products_hash["items"].select { |item| item["brand"] == brand }
	    total_stock_brand = 0
	    total_full_price_brand = 0
	    brand_sales = 0

	    brands_toys.each do |item|
	      item["purchases"].each do |el|
	        brand_sales += el["price"].to_f
	      end
	    end

	    brands_toys.each { |toy| total_stock_brand += toy["stock"].to_i }
	    brands_toys.each { |toy| total_full_price_brand += toy["full-price"].to_f }

	    puts "Brand: #{brand}"
	    puts "current stock on hand: #{total_stock_brand}"
	    puts "Average price: #{(total_full_price_brand/brands_toys.length).round(2)}"
	    puts "Total sales: #{brand_sales.round(2)}"


	  end
	end



	# Print the name of the brand
	# Count and print the number of the brand's toys we stock
	# Calculate and print the average price of the brand's toys
	# Calculate and print the total sales volume of all the brand's toys combined

def brands_items_data

end

start
