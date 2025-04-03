class EdamamService
  include HTTParty
  base_uri 'https://api.edamam.com'

  def initialize
    @app_id = ENV['EDAMAM_APP_ID']
    @app_key = ENV['EDAMAM_APP_KEY']
  end

  def search_recipes(query = '', options = {})
    response = self.class.get('/api/recipes/v2', {
      query: {
        type: 'public',
        q: query,
        app_id: @app_id,
        app_key: @app_key,
        random: true
      }.merge(options)
    })

    if response.success?
      format_recipes(response['hits'])
    else
      []
    end
  end

  private

  def format_recipes(hits)
    hits.map do |hit|
      recipe = hit['recipe']
      {
        title: recipe['label'],
        cooking_time: recipe['totalTime'].to_i,
        dietary_labels: recipe['dietLabels'] + recipe['healthLabels'],
        ingredients_list: recipe['ingredientLines'].join(', '),
        image_url: recipe['image'],
        source: recipe['source'],
        url: recipe['url'],
        calories: recipe['calories'].round,
        servings: recipe['yield']
      }
    end
  end
end