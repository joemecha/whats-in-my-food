require 'rails_helper'

# Solid test, but could be more robust and improved with within blocks, 
# counting the number of Food elements on the page which should be 10, and 
# thinking about a sad path. Also, we should be stubbing the API call.

RSpec.describe 'Foods Index (search results)' do
  describe 'happy path' do
    before :each do 
      visit root_path

      fill_in :q, with: 'sweet potatoes'
    end

    it 'user sees search results for food' do
      json_response = File.read('spec/fixtures/sweet_potatoes_search_result.json')
      stub_request(:get, "https://api.nal.usda.gov/fdc/v1/foods/search?api_key=X5MqWQCLRSlxUlXnpdm2q51W13hIhOhj5krsN0ep&numberOfResultsPerPage=10&query=sweet%20potatoes").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'Api-Key'=>'X5MqWQCLRSlxUlXnpdm2q51W13hIhOhj5krsN0ep',
       	  'User-Agent'=>'Faraday v1.4.2'
           }).
         to_return(status: 200, body: json_response)
      
      click_button 'Search'
      expect(current_path).to eq(foods_path)
      
      expect(page.status_code).to eq 200
      expect(page).to have_content("Total items returned: 44128")
      expect(page).to have_content("GTIN/UPC code:")
      expect(page).to have_content("Description:")
      expect(page).to have_content("Brand Owner:")
      expect(page).to have_content("Ingredients:")
    end
  end
end