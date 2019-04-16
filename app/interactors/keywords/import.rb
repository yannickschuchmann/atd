module Keywords
  class Import
    include Interactor::Organizer

    organize 
      Keywords::GetCSV, 
      Keywords::CreateRecords
  end
end
