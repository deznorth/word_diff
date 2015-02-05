require "spec_helper"

describe "WordDiff" do

  include Rack::Test::Methods

  def app
    WordDiff.new
  end

  it "inits the octokit client" do
    expect(WordDiff.client.class).to eql(Octokit::Client)
  end

  it "parses the push" do
    fixture = File.open(fixture("md-exists.json")).read
    stub_request(:get, "https://api.github.com/repos/benbalter/test-repo-ignore-me/contents/").
        to_return(:status => 200, :body => fixture, :headers => {'Content-Type'=>'application/json'})

    stub = stub_request(:put, "https://api.github.com/repos/benbalter/test-repo-ignore-me/contents/file.md").
         to_return(:status => 200)

    post "/", File.open(fixture("push.json")).read

    expect(stub).to have_been_requested
  end

end