ActiveAdmin.register_page "Imports" do
  page_action :create, method: :post do
    if params[:csv_url].present?
      KeywordsImportJob.perform_later(params[:csv_url]) 
      flash[:notice] = "Created job to import keywords successfully!"
    else
      flash[:error] = "Please provide a valid URL!"
    end

    redirect_to "/admin/imports"
  end

  content do
    columns do
      column do
        panel "Import CSV file" do
          form action: "imports/create", method: :post do |f|
            f.input type: :hidden, name: :authenticity_token, value: form_authenticity_token
            f.input :csv_url, type: :text, name: 'csv_url', placeholder: 'URL of CSV file'
            f.input :submit, type: :submit
          end
        end
      end
    
      column do
        panel "Import jobs" do
          div do
            link_to "Go to Sidekiq WebUI", "/sidekiq", target: :_blank
          end
        end
      end
    end
  end
end
