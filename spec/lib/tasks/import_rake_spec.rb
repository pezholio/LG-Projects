describe "import:authorities" do
  include_context "rake"

  before(:each) do
    VCR.use_cassette('authorities') do
      stub_request(:get, "https://raw.githubusercontent.com/github/government.github.com/gh-pages/_data/governments.yml")
                  .to_return(body: File.read(File.join(Rails.root, 'fixtures', 'governments.yml')))

      subject.invoke

      Authority.count.should == 2
    end
  end

  it "generates the correct number of authorities" do
    Authority.count.should == 2
  end

  it "generates the correct information for an authority" do
    authority = Authority.find_by(username: "Lichfield-District-Council")
    authority.name.should == "Lichfield District Council"
    authority.avatar.should == "https://avatars.githubusercontent.com/u/1985219?s=64"
  end

  it "generates the correct number of repos" do
    authority = Authority.find_by(username: "Lichfield-District-Council")
    authority.repos.count.should == 7
  end

  it "generates the correct data for a repo" do
    repo = Repo.find_by(name: "Licensing")
    repo.name.should == "Licensing"
    repo.description.should == "Licensing"
    repo.url.should == "https://github.com/Lichfield-District-Council/Licensing"
    repo.civic_present?.should == false
  end

  it "gets the correct additional details for a repo with a civic.json file" do
    repo = Repo.find_by(name: "Ratemyplace")
    repo.civic_present?.should == true
    repo.owner['name'].should == 'Lichfield District Council'
    repo.owner['type'].should == 'Local council'
    repo.owner['@id'].should == 'http://gov.uk/councils/lichfield-district-council'
    repo.deployments.first['name'].should == 'Ratemyplace'
    repo.deployments.first['@id'].should == 'http://www.ratemyplace.org.uk'
    repo.service_categories.first['name'].should == "Food Safety"
    repo.service_categories.first['@id'].should == "http://id.esd.org.uk/az/F28157"
    repo.technologies.first['name'].should == "Ruby on Rails"
    repo.technologies.first['@id'].should == "http://rubyonrails.org"
  end

end
