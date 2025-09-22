puts "Clearing old data…"
RecipeSearch.delete_all
IngredientListItem.delete_all
IngredientList.delete_all
Ingredient.delete_all
User.delete_all

puts "Creating user…"
user = User.create!(email: "test@example.com", first_name: "Test", last_name: "User")

puts "Creating ingredient list…"
ingredient_list = IngredientList.create!(title: "Protein List", user: user)

puts "Adding ingredient to list…"
ingredient = Ingredient.create!(title: "Chicken Breast", provider_name: "mealdb", provider_id: SecureRandom.uuid)
IngredientListItem.create!(ingredient_list: ingredient_list, ingredient: ingredient)

puts "Done seeding!"
