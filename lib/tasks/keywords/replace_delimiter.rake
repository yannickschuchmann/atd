
require "csv"

namespace :keywords do
  task replace_delimiter: :environment do

    options = {
      encoding: "utf-8", 
      liberal_parsing: true,
      col_sep: "\t"
    }

    new_file = []
    File.open(Rails.root.join("public", "small", "2016-11 Amazon Search Terms nov16.csv"), options) do |file|
      new_file = file.each_line.map do |line, index|
        row = CSV.parse_line(line.scrub(""), options)
        row.to_csv(col_sep: ",")
      end
    end

    File.open('new_csv.csv', 'w') do |f|
      new_file.each do |line|
        f << line
      end
    end
  end
end