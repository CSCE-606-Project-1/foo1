puts "Clearing old data…"
RecipeSearch.destroy_all
IngredientListItem.destroy_all
IngredientList.destroy_all
Ingredient.destroy_all

# qacer6973@gmail.com is Quan's test account. Seeded lists shall make it to this account
puts "Finding or creating user…"
user = User.find_by(email: "qacer6973@gmail.com")

if user.nil?
  user = User.create!(
    email: "qacer6973@gmail.com",
    first_name: "Qacer",
    last_name: "Test"
  )
  UserAccount.create!(user: user)
  puts "Created new user"
else
  puts "Found existing user: #{user.email}"

  user.ingredient_lists.destroy_all
end

puts "Creating multiple ingredient lists…"

protein_list = IngredientList.create!(title: "Protein List", user: user)
puts "Adding ingredients to Protein List…"
chicken = Ingredient.find_or_create_by!(title: "Chicken Breast", provider_name: "mealdb", provider_id: "1")
beef = Ingredient.find_or_create_by!(title: "Ground Beef", provider_name: "mealdb", provider_id: "2")
salmon = Ingredient.find_or_create_by!(title: "Salmon", provider_name: "mealdb", provider_id: "3")
IngredientListItem.create!(ingredient_list: protein_list, ingredient: chicken)
IngredientListItem.create!(ingredient_list: protein_list, ingredient: beef)
IngredientListItem.create!(ingredient_list: protein_list, ingredient: salmon)

one_test_list = IngredientList.create!(title: "One Test List", user: user)
chicken = Ingredient.find_or_create_by!(title: "Chicken", provider_name: "mealdb", provider_id: "4")
IngredientListItem.create!(ingredient_list: one_test_list, ingredient: chicken)

test_list = IngredientList.create!(title: "Test List", user: user)
chicken = Ingredient.find_or_create_by!(title: "Chicken", provider_name: "mealdb", provider_id: "7")
salt = Ingredient.find_or_create_by!(title: "Salt", provider_name: "mealdb", provider_id: "8")
IngredientListItem.create!(ingredient_list: test_list, ingredient: chicken)
IngredientListItem.create!(ingredient_list: test_list, ingredient: salt)

puts "Seed data created successfully!"
puts "User: #{user.email}"
puts "Ingredient Lists: #{user.ingredient_lists.pluck(:title).join(', ')}"
puts "Sample lists available in dropdown: Protein List, Vegetarian List, Test List"
