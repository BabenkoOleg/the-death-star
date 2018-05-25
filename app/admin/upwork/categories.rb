ActiveAdmin.register Upwork::Category do
  menu label: 'Categories', parent: 'Upwork', priority: 4

  config.sort_order = 'id_asc'

  permit_params :titel, :upwork_id

  filter :title

  index do
    selectable_column
    id_column
    column :title do |category|
      link_to category.title, admin_upwork_category_path(category)
    end
    column :subcategories do |category|
      link_to('Subcategories', admin_upwork_subcategories_path(q: { category_id_eq: category.id }), class: 'member_link')
    end
    actions
  end
end
