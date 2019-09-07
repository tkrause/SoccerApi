namespace :build do
  desc "Build and test api docs"

  task docs: :environment do
    begin
      Rake::Task["docs:generate"].invoke

      # now modify the file generated
      filename = Rails.root.join('doc', 'api', 'index.apib')
      # read the files
      lines = File.readlines(filename)

      unless lines.first.start_with? 'FORMAT: 1A'
        return
      end

      File.open(filename, "w") do |f|
        lines.drop(2).each do |line|
          f.puts line
        end
      end
    rescue Exception => ex
      puts ex.inspect
      abort 'Error while building. Docs not output'
    end
  end

end
