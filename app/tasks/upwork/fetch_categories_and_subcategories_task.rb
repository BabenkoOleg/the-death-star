module Upwork
  class FetchCategoriesAndSubcategoriesTask < BaseTask
    def perform!
      client = Upwork::Api.new

      categories_data = client.fetch(:categories)['categories']

      categories_data.each do |data|
        category = Upwork::Category.find_or_create_by(title: data['title']) do |c|
          c.upwork_id = data['id']
        end

        puts " --> processed category \e[1m\e[32m#{category.title}\e[0m\e[22m with subcategories:"

        data['topics'].each do |topic|
          subcategory = category.subcategories.find_or_create_by(title: topic['title']) do |s|
            s.upwork_id = topic['id']
          end

          puts "       #{subcategory.title}"
        end
      end
    end
  end
end
