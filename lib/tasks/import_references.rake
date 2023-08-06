namespace :import do
  desc "Import References dynamic file path i.e. bin/rake \"import:references[docs/sharki-refs-to-upload-230723.csv]\""
  task :references, [:file_path] => :environment do |t, args|
    references = CSV.read(args.file_path, headers: true).map(&:to_h)

    references.each do |ref|
      next if Reference.exists?(name: ref["author_year"])

      begin
        Reference.create!(name: ref["author_year"], year: ref["year"], reference: ref["resource"], author_year: ref["author_year"], data_source: ref["source"], doi: ref["DOI"], suffix: ref["suffix"])
      rescue ActiveRecord::RecordInvalid => invalid_doi
        puts invalid_doi.message
        puts "#{ref["author_year"]} had invalid DOI of #{ref["DOI"]}"
      end
    end
  end
end
