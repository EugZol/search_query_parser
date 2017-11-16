require 'search_query_parser/grammar'

describe SearchQueryParser::Grammar do
  describe '.preapre' do
    before do
      @f = SearchQueryParser::Grammar.method(:prepare_text)
    end

    it 'preserves "-" inside of a word' do
      expect(@f.('mini-model')).to eq 'mini-model'
    end

    it 'removes "-" if not inside of a word' do
      expect(@f.("-mini- -model-")).to eq 'mini model'
    end

    it 'preserves unicode' do
      expect(@f.('幸运1')).to eq '幸运1'
    end

    it 'removes several spaces and non-al-num in a row' do
      expect(@f.("  too  many   * spaces$( )*  \t")).to eq 'too many spaces()'
    end

    it 'changes && to & and || to |, removing extra spaces' do
      expect(@f.("a && b || c d")).to eq 'a&b|c d'
    end

    it 'removes spaces at brackets' do
      expect(@f.("(a b  ) \t(c& d )(e) (   f")).to eq "(a b)(c&d)(e)(f"
    end
  end

  describe "building tree and #to_s" do
    before do
      @c = SearchQueryParser::Grammar.method(:new)
    end

    it "correctly represents a combination of AND, OR, JOIN and TERMs" do
      expression = (@c.("a") >> @c.("b")) & @c.("c") | (@c.("d") >> !@c.("e"))
      expect(expression.to_s).to eq "(((a <-> b) & c) | (d <-> (! e)))"
    end
  end
end
