# Function: this is a simple ruby script that calls Codecov's API to make sure it's returning the proper coverage

require 'rest-client'
require 'json'

puts "Codecov API Validation\n"

# nap time
def nap
  puts "Waiting 120 seconds for report to upload before pinging API...\n"
  sleep(120)
end

def ping_api
  puts "Pinging Codecov's API..\n"

  # REST call
  response_data = RestClient.get('https://codecov.io/api/gh/codecov/Ruby-Standard-2', params: { token: ENV['API_KEY'] })

  # Parse request data to JSON format
  to_json = JSON.parse(response_data)

  # get the commit data and coverage percentage
  commit_data = to_json.dig('commits', 0)
  coverage_percentage = commit_data.dig('totals', 'c')

  # Coverage percentage should be 93.65079 (this is specfied via environment variables on GitHub), fail build otherwise

  if coverage_percentage == ENV['CORRECT_COVERAGE']
    puts "Success! Codecov's API returned the correct coverage percentage, #{ENV['CORRECT_COVERAGE']}"
    exit 0
  else
    puts 'Whoops, something is wrong D: Codecov did not return the correct coverage percentage.'
    puts "Coverage percentage should be #{ENV['CORRECT_COVERAGE']} but Codecov returned #{coverage_percentage}"
    exit 1
  end
end

def run!
  nap
  ping_api
end

run!
