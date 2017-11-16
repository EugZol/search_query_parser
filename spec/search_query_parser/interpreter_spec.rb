require 'search_query_parser/interpreter'

describe SearchQueryParser::Interpreter do
  describe '#parser' do
    before do
      @f = SearchQueryParser::Interpreter.new.method(:parse)
    end

    it 'parses complex expressions' do
      expect(@f.("a b&c|d e&(f|g)").to_s).to eq "(((a <-> b) & c) | ((d <-> e) & (f | g)))"
    end
  end
end
