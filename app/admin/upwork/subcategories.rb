ActiveAdmin.register Upwork::Subcategory do
  menu label: 'Subategories', parent: 'Upwork', priority: 5

  config.sort_order = 'id_asc'

  permit_params :titel, :category_id, :upwork_id

  filter :category, as: :select

  index do
    selectable_column
    id_column
    column :title do |subcategory|
      link_to subcategory.title, admin_upwork_subcategory_path(subcategory)
    end
    column :category do |subcategory|
      link_to subcategory.category.title, admin_upwork_category_path(subcategory.category)
    end
    actions
  end
end
