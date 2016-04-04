ActiveAdmin.register Box do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
  permit_params :collection_id, :brain_type, :private

  index do
    column :id
    column :created_at
    column :updated_at
    column "Collection" do |box|
      link_to box.collection.name, admin_collection_path(box.collection_id)
    end
    column :brain_type
    column :private
    actions
  end

  show do
    attributes_table do
      row :id
      row :collection_id
      row :created_at
      row :updated_at
      row :brain_type
      row :private
    end
    panel "Contents" do
      prints = box.prints
      table_for box.collection.things do |thing|
        column "Object ID" do |t|
          link_to t.id, admin_thing_path(t.id)
        end
        column "Object Image" do |t|
          link_to image_tag(t.image, :width => 80), admin_thing_path(t.id)
        end
        column "Name", :name
        column :description
        print = box.prints.where(:thing_id == thing.id)[0]
        column "Print ID" do |t|
          print = box.prints.where(thing_id: t.id)[0]
          link_to print.id, admin_print_path(print.id) unless print.nil?
        end
        column "Print Image" do |t|
          print = box.prints.where(thing_id: t.id)[0]
          link_to image_tag(print.image, :width => 80), admin_print_path(print.id) unless print.nil?
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :collection
      f.input :brain_type, as: :select, collection: Box.brain_types.keys
      f.input :private
    end
    f.actions
  end
end
