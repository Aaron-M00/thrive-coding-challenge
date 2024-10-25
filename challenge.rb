require 'json'

class CompanyProcessor
  attr_reader :companies, :users

  def initialize(companies_path, users_path, output_path)
    @companies = load_data(companies_path)
    @users = load_data(users_path)
    @output_path = output_path
  end

  def process_all
    File.open(@output_path, 'w') do |file|
      original_stdout = $stdout
      $stdout = file
      begin
        process_companies
      ensure
        $stdout = original_stdout
      end
    end
  end

  private

  def process_companies
    company_ids = @companies.map { |company| company["id"] }
    valid_users = @users.select { |user| company_ids.include?(user["company_id"]) }

    @companies.each do |company|
      company_users = valid_users.filter { |user| user["company_id"] == company["id"] }
      next if company_users.empty?
      process_company(company, company_users)
    end
  end

  def load_data(file_path)
    JSON.parse(File.read(file_path))
  rescue Errno::ENOENT, JSON::ParserError => e
    puts "Error reading #{file_path}: #{e.message}"
    exit
  end

  def process_company(company, users)
    top_up_amount = company["top_up"]
    total_top_up = users.sum { |user| user["active_status"] ? top_up_amount : 0 }
    emailed_users, not_emailed_users = users.partition { |user| user["email_status"] && company["email_status"] }

    display_company_info(company, emailed_users, not_emailed_users, total_top_up)
  end

  def display_company_info(company, emailed_users, not_emailed_users, total_top_up)
    puts "Company Id: #{company['id']}"
    puts "Company Name: #{company['name']}"
    display_users_info("Users Emailed:", emailed_users, company["top_up"])
    display_users_info("Users Not Emailed:", not_emailed_users, company["top_up"])
    puts "Total amount of top ups for #{company['name']}: #{total_top_up}\n\n"
  end

  def display_users_info(header, users, top_up_amount)
    puts header if users.any?
    users.each do |user|
      new_token_balance = user['tokens'] + (user['active_status'] ? top_up_amount : 0)
      puts "\t#{user['first_name']} #{user['last_name']} (#{user['email']})"
      puts "\t  Previous Token Balance: #{user['tokens']}"
      puts "\t  New Token Balance: #{new_token_balance}"
    end
  end
end

processor = CompanyProcessor.new('companies.json', 'users.json', 'output.txt')
processor.process_all
