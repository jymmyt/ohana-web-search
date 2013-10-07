require 'spec_helper'

feature 'search results map', :js=>true do

  context 'results have entries that have coordinates', :vcr do
    it "displays a results list map" do
      visit('/organizations/')
      expect(page).to have_selector("#map-view")
    end
  end

  context 'results have entries that do not have coordinates', :vcr do
    # Set to pending because a search that doesn't return a map has
    # not not been found.
    xit "does not display a results list map" do
      search_from_home({:keyword=>'alcohol and drug helpline'})
      expect(page).to_not have_selector("#map-view")
    end
  end

end

feature 'nearby map', :js=>true do

  context 'location has coordinates', :vcr do
    it "displays a nearby map" do
      visit('/organizations/521d32b91974fcdb2b00001c')
      expect(page).to have_selector("#detail-map-view")
    end
  end

  context 'location does not have coordinates', :vcr do
    it "does not display a nearby map" do
      visit('/organizations/521d33901974fcdb2b002581')
      expect(page).to_not have_selector("#detail-map-view")
    end
  end

end