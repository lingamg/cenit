module RailsAdmin
  module Models
    module Setup
      module RendererAdmin
        extend ActiveSupport::Concern

        included do
          rails_admin do
            navigation_label 'Transformations'
            weight 411
            configure :code, :code

            wizard_steps do
              steps =
                {
                  start:
                    {
                      :label => I18n.t('admin.config.renderer.wizard.start.label'),
                      :description => I18n.t('admin.config.renderer.wizard.start.description')
                    },
                  end:
                    {
                      label: I18n.t('admin.config.renderer.wizard.end.label'),
                      description: I18n.t('admin.config.renderer.wizard.end.description')
                    }
                }
              if !bindings[:object].file_extension_enum.empty?
                steps[:end] =
                  {
                    label: I18n.t('admin.config.renderer.wizard.select_file_extension.label'),
                    description: I18n.t('admin.config.renderer.wizard.select_file_extension.description')
                  }
              end
              steps
            end

            current_step do
              obj = bindings[:object]
              if obj.style.blank?
                :start
              else
                :end
              end
            end

            edit do
              field :namespace, :enum_edit, &RailsAdmin::Models::Setup::FieldsConfigAdmin.shared_non_editable
              field :name, &RailsAdmin::Models::Setup::FieldsConfigAdmin.shared_non_editable


              field :source_data_type do
                RailsAdmin::Models::Setup::FieldsConfigAdmin.shared_read_only
                inline_edit false
                inline_add false
              end
              field :style do
                RailsAdmin::Models::Setup::FieldsConfigAdmin.shared_read_only
                visible { bindings[:object].type.present? }
                help 'Required'
              end
              field :bulk_source do
                RailsAdmin::Models::Setup::FieldsConfigAdmin.shared_read_only
                visible { bindings[:object].style.present? && bindings[:object].source_bulkable? }
              end
              field :mime_type do
                RailsAdmin::Models::Setup::FieldsConfigAdmin.shared_read_only
                label 'MIME type'
                visible { bindings[:object].style.present? }
              end
              field :file_extension do
                RailsAdmin::Models::Setup::FieldsConfigAdmin.shared_read_only
                visible { !bindings[:object].file_extension_enum.empty? }
                help { "Extensions for #{bindings[:object].mime_type}" }
              end
              field :code, :code do
                visible { bindings[:object].style.present? && bindings[:object].style != 'chain' }
                help { 'Required' }
                code_config do
                  {
                    mode: case bindings[:object].style
                          when 'html.erb'
                            'text/html'
                          when 'xslt'
                            'application/xml'
                          else
                            'text/x-ruby'
                          end
                  }
                end
              end
            end

            show do
              field :namespace
              field :name
              field :source_data_type
              field :bulk_source
              field :style
              field :mime_type
              field :file_extension
              field :code

              field :_id
              field :created_at
              #field :creator
              field :updated_at
              #field :updater
            end

            list do
              field :namespace
              field :name
              field :source_data_type
              field :style
              field :mime_type
              field :file_extension
              field :updated_at
            end
          end
        end

      end
    end
  end
end
