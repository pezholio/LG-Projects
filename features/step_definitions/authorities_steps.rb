Given(/^I have (\d+) authorities in the database$/) do |arg1|
  Authority.create(username: "authority-1", name: "Authority 1", avatar: "http://example.com/doge.gif")
  Authority.create(username: "authority-2", name: "Authority 2", avatar: "http://example.com/doge2.gif")
end

When(/^I visit the homepage$/) do
  visit('/')
end

Then(/^I should see (\d+) authorities listed$/) do |num|
  all('div.media').count.should == num.to_i
end

Given(/^an authority "(.*?)"$/) do |name|
  @authority = Authority.create(username: name.parameterize, name: name, avatar: "http://example.com/doge.gif")
end

Given(/^that authority has (\d+) repos$/) do |num|
  num.to_i.times do |n|
    @authority.repos << Repo.new(
                                    name: "Repo #{n}",
                                    description: "Description for Repo #{n}",
                                    url: "http://www.github.com/test/repo-#{n}",
                                    civic_present?: false
                                   )
  end
  @authority.save
end

When(/^I visit the authority page for that authority$/) do
  visit(authority_path(@authority))
end

Then(/^I should see that authority's name$/) do
  page.body.should match /#{@authority.name}/
end

Then(/^I should see that authority's avatar$/) do
  page.body.should match /#{@authority.avatar}/
end


Then(/^I should see (\d+) repos? listed$/) do |num|
  all('div.repo').count.should == num.to_i
end

Given(/^that authority has a repo called "(.*?)" with additional metadata$/) do |arg1|
  @authority.repos << Repo.new(
                                name: "Ratemyplace",
                                description: "Description for Ratemyplace",
                                url: "http://www.github.com/test/ratemyplace",
                                civic_present?: true,
                                thumbnail: "http://www.example.com/nyan-cat.gif",
                                status: "Live",
                                owner: {
                                  'name' => 'Lichfield District Council',
                                  'type' => 'Local council',
                                  '@id' => 'http://gov.uk/councils/lichfield-district-council'
                                },
                                deployments: [{'name' => 'Ratemyplace', '@id' => 'http://www.ratemyplace.org.uk'}],
                                service_categories: [{'name' => 'Food Safety', '@id' => 'http://id.esd.org.uk/az/F28157'}],
                                technologies: [{'name' => 'Ruby on Rails', '@id' => 'http://rubyonrails.org'}]
                              )
end


Then(/^that page should have the correct metadata listed$/) do
  repo = @authority.repos.first
  page.body.should match /#{repo.thumbnail}/
  page.body.should match /#{repo.status}/
  page.body.should match /#{repo.owner['name']}/
  page.body.should match /#{repo.service_categories.first['name']}/
  page.body.should match /#{repo.technologies.first['name']}/
end
