#	Program: THOUGHTWORKS PROBLEM TWO: SALES TAXES coded in RUBY
#	Author: Nadine L. Dabby
#	Date: Nov. 9, 2013
#
#
#	SPECIFICATION:
#
#	Basic sales tax is applicable at a rate of 10% on all goods, 
#	except books, food, and medical products that are exempt. 
#	Import duty is an additional sales tax applicable on all 
#	imported goods at a rate of 5%, with no exemptions.
# 
#	When I purchase items I receive a receipt which lists the 
#	name of all the items and their price (including tax), 
#	finishing with the total cost of the items, and the total 
#	amounts of sales taxes paid.  The rounding rules for sales 
#	tax are that for a tax rate of n%, a shelf price of p contains 
#	(np/100 rounded up to the nearest 0.05) amount of sales tax.
#
#	Write an application that prints out the receipt details for 
#	these shopping baskets...
#
#
#	DESCRIPTION:
#
#	This application prints out the receipt details for a shopping 
#	basket of items.The program first parses the shopping basket 
#	dividing assigning quantities and prices to the items on the list.
#	Next the program segments the list to decide what gets what tax where
#	and then we compute the items plus tax
#
#
#	ASSUMPTIONS:
#	1) We assume the input comes in the following form with no empty 
#	lines before or after the text:
#
#	Integer" "String" at "Float"\n"
#
#	2)  The input file is called "grocery.rb".
#
#
#	INPUT: 
#	The input file is "grocery.rb".
#
#	OUTPUT: 
#	The program will print output to the screen. 
#	
#	VARIABLES:
# 	$salesTax  - 	A global variable that stores the Sales Tax rate.
# 	$importTax - 	A global variable that stores the Import Tax rate.
#	$exemptions - 	A global array that stores strings of tax-exempted items
#	ShoppingList - 	An array to store all of the shopping items
#
#	CLASS:
#	GroceryItem - An object class that stores the quantity, name and price of an item
#					as well as procedures for checking if the item is tax exempt or imported
#					and calculating sales tax and cost (price + tax) of the item
#
#
#	PROCEDURES:
#	round_by - 	takes an increment value as an argument and returns self 
#			   	rounded up to the nearest increment amount
#				this procedure is overloaded into the Float Class
#
#	compute_sales_tax - 	takes an array of GroceryItem objects 
#				and returns the total sales tax of all items
#
#	compute_sales_total - 	takes an array of GroceryItem objects 
#				and returns the sales total (cost + tax) of all items
#
# 	GroceryItem.initialize -  takes an integer, string and float as arguments and 
#							initializes quantity, name and price attributes
#
#	GroceryItem.is_import - takes no arguments, returns true if the item is an import
#							and returns false otherwise
#
#	GroceryItem.is_sales_tax_exempt - 	takes no arguments, returns true if the item is 
#							sales tax exempt and returns false otherwise
#
#   GroceryItem.calculate_tax - takes no arguments, returns tax rate
#
#	GroceryItem.cost - 	takes no arguments and returns the total cost of an item  
#			   			including tax.
#
#
#


#set tax rates as global variables 
$salesTax = 0.1
$importTax = 0.05

#set an array full of tax exempted words
$exemptions = ["book", "medicine", "medical", "pill", "headache", "food", "chocolate"]

#create array to hold all shopping items
ShoppingList = Array.new()

#define procedure for rounding up to the nearest increment amount
class Float
  def round_by(increment)
    (self /increment).ceil * increment
  end
end

#define object for grocery item

class GroceryItem
  attr_reader :quantity, :name, :price     	#allows user to read attributes
  def initialize(quantity, name, price)		#initializes quantity, name and price attributes
    @quantity = quantity
    @name = name
    @price = price
  end

  public
  #function calculates the total cost of an item including tax
  def cost()					
  	tax = self.calculate_tax()							#get tax rate of the item
  	i_cost_this_much = price + (price*tax).round_by(0.05) #calculate price + tax rounded to the nearest 0.05 	     
    return i_cost_this_much
  end 
 
  #function calculates the tax rate on the item
  def calculate_tax()
    tax = 0
      if is_import() == true			#checks if item is imported
        tax+= $importTax				#if yes, adds global import tax to tax rate
      end
      if is_sales_tax_exempt() == false #checks if item is tax exempt
   		tax+= $salesTax					#if not, adds global sales tax to tax rate
      end 
  	  return tax
  end
 
  private
  #function checks if an item is tax-exempt, returns a boolean value
  def is_sales_tax_exempt()
    if $exemptions.any? { |x| name.include? x }
      return true
    else
      return false
    end
  end
  
  #function checks if an item is imported, returns a boolean value
  def is_import()
     return name.match("imported") != nil
  end 
end

# function takes an array of GroceryItem objects and returns the sales total (cost + tax) of all items
def compute_total(basket)
  total = 0
  for x in basket
    total+= x.cost  	#adds individual item costs to total
  end
  return total 			#returns total
end

# function takes an array of GroceryItem objects and returns the total sales tax of all items
def compute_sales_tax(basket)
  sales_tax = 0
  for x in basket
    sales_tax+= (x.price * x.calculate_tax).round_by(0.05) #calculate item tax rounded to the nearest 0.05 
  end														#and add to total sales_tax
  return sales_tax 
end



#This is the main loop of the program: it reads in the input and creates new items
File.open('grocery.rb', 'r') do |f1|  #read input file one line at a time
  while line = f1.gets  

    quantity = Integer(line[/\d*\s/]) #parses quantity of items and converts to integer
    
    name = line[/\s(.*?)\sat/] 		#segment string that describes item 
    name = name[1..-4]				#remove initial space and  final " at" to generate a string of the item

    tempprice = line.split(/at\s(.*?)/) #parses item cost
    price = Float(tempprice[2])			#converts string to float
	
	item = GroceryItem.new(quantity, name, price) #creates a new GroceryItem using quantity, name and price
	ShoppingList.push(item)  #adds the new item into the ShoppingList array
  end  
  

#This is part of the program prints out the receipt
  ShoppingList.each {|x| print(x.quantity, " ", x.name, ": ", '%.2f' % x.cost, "\n") } # individual items and costs
  print("Sales Taxes: ", '%.2f' % compute_sales_tax(ShoppingList), "\n")  #prints total sales tax 
  print("Total: ", '%.2f' % compute_total(ShoppingList), "\n")			#prints total cost	
end 


