describe SearchQueryParser do
  describe ".to_ts_query" do
    before do
      @f = SearchQueryParser.method(:to_ts_query)
    end

    it 'produces PostgreSQL ts_query structures from bare string' do
      expect(@f.("cats !dogs !собаки || (birds & птицы*  ) ^")).to eq "(((to_tsquery('english', 'cats:*') <-> (!! to_tsquery('english', 'dogs:*'))) <-> (!! to_tsquery('english', 'собаки:*'))) || (to_tsquery('english', 'birds:*') && to_tsquery('english', 'птицы:*')))"
    end
  end
end
