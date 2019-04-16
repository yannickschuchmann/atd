describe Keywords::CreateRecords do
  let(:csv_path) { Rails.root.join('spec', 'support', 'keywords_csv').to_s }
  let(:csv_name) { "2019-02_Amazon-Suchbegriffe_DE_022019_small.csv" }
  let(:csv_name_deprecated) { "2015-11 Amazon Search Terms nov15_small.csv" }
  let(:file_options) { {encoding: 'bom|utf-8'} }

  let(:csv_file) { File.open(File.join(csv_path, csv_name), file_options)  }
  let(:csv_file_deprecated) { File.open(File.join(csv_path, csv_name_deprecated), file_options)  }

  subject { described_class.call(csv_file: csv_file, date: '01/04/2017', skip_header_lines: 2) }

  describe '.call' do
    it 'is a success' do
      puts Benchmark.measure {subject}
      expect(subject).to be_a_success
    end

    context 'even when runs a second time' do
      subject { 2.times do 
          described_class.call(csv_file: csv_file, date: '01/04/2017', skip_header_lines: 2) 
        end
      }

      it 'creates only new record' do
        expect{subject}.to change{Keyword.count}.by(18)
          .and change{KeywordRank.count}.by(18)
          .and change{Product.count}.by(47)
          .and change{ProductPerformance.count}.by(54)
      end
    end
  end
end
