namespace :upwork do
  desc 'Update the list of available categories and subcategories'
  task fetch_categories_and_subcategories: :environment do
    Upwork::FetchCategoriesAndSubcategoriesTask.perform!
  end

  desc 'Update the list of available skills'
  task fetch_skills: :environment do
    Upwork::FetchSkillsTask.perform!
  end
end
