ActiveAdmin.register Upwork::Skill do
  menu label: 'Skills', parent: 'Upwork', priority: 6

  config.sort_order = 'id_asc'
  config.filters = false

  permit_params :title

  index do
    selectable_column
    id_column
    column :title do |skill|
      link_to skill.title, admin_upwork_skill_path(skill)
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
    end
    f.actions
  end
end
