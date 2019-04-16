ActiveAdmin.register_page "Imports" do
  page_action :create, method: :post do
    if params[:csv_url].present?
      KeywordsImportJob.perform_later(
        url: params[:url],
        date: params[:date],
        skip_header_lines: params[:skip_header_lines]
      ) 
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
            div do
              f.label :url
              f.input :url, type: :text, name: 'url', placeholder: 'URL of CSV file'
            end
            div do
              f.label :date
              f.input :date, type: :date, name: 'date', value: Date.today, placeholder: 'Date of CSV'
            end
            div do
              f.label :skip_header_lines
              f.input :skip_header_lines, type: :number, name: 'Skip header lines', value: 1
            end
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
