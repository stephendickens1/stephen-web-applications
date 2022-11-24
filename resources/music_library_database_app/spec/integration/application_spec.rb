require "spec_helper"
require "rack/test"
require_relative '../../app'



describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context 'GET /albums/:id' do
    it 'should return info about album 2' do
      response = get('/albums/2')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: Pixies')
    end 
  end 

  context 'GET /albums' do
    it 'should return the list of albums' do
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/albums/2">Surfer Rosa</a>')
      expect(response.body).to include('<a href="/albums/3">Waterloo</a>')
      expect(response.body).to include('<a href="/albums/4">Super Trouper</a>')
    end
  end


  context 'GET /albums/new' do
    it 'should return the form to add a new album' do
      response = get('/albums/new')


      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/albums">')
      expect(response.body).to include('input type="text" name="title" />')
      expect(response.body).to include('input type="text" name="release_year" />')
      expect(response.body).to include('input type="text" name="artist_id" />')
    end 
  end 





  context 'POST /albums' do
    it 'should validate album parameters' do
      response = post('/albums', invalid_artist_title: 'OK Computer', another_invalid_thing: 123)

      expect(response.status).to eq(400)
    end 




    it 'should create a new album record' do
      response = post('/albums', title: "OK Computer", release_year: "1997", id: "1")

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/albums')

      expect(response.body).to include('OK Computer')
    end
  end

  context 'GET /artists' do
    it 'should return a list of all the artists in the test database music_library_test' do
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/artists/1">Pixies</a>')
      expect(response.body).to include('<a href="/artists/2">ABBA</a>')
      expect(response.body).to include('<a href="/artists/3">Taylor Swift</a>')
    end 
  end

  context 'GET /artists/:id' do
    it 'should return an HTML page showing the details for a single artist' do
      response = get('artists/2')

      expect(response.status).to eq(200)
      expect(response.body).to include('ABBA are')
      expect(response.body).to include('pioneers in Pop!')
    end
  end 






  context 'POST /artists' do
    it 'should create a new artist' do
      response = post('/artists', id: "5", name: "Wild nothing", genre: "Indie")

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/artists')

      expect(response.body).to include('Wild')
    end
  end

  
end
