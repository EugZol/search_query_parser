class SearchQueryParser::Interpreter
  prechigh
    nonassoc '!'
    left '<->'
    left '&'
    left '|'
  preclow
rule
  target: exp

  exp: exp '&' exp   { result &= val[2]  }
     | exp '|' exp   { result |= val[2]  }
     | exp '<->' exp { result >>= val[2] }
     | '(' exp ')'   { result = val[1]   }
     | '!' exp       { result = !val[1]  }
     | TERM          { result = val[0]   }
end

---- header

require 'search_query_parser/grammar'

class SearchQueryParser::ParseError < ArgumentError; end

---- inner

  def parse(str)
    @q = []
    str = SearchQueryParser::Grammar.prepare_text(str)
    str.scan(/[[:alnum:]\-]+|[&|()!\s]/) do |token|
      case token
      when /[[:alnum:]\-]+/
        @q.push [:TERM, SearchQueryParser::Grammar.new(token)]
      when /\s/
        @q.push ['<->', '<->']
      else
        @q.push [token, token]
      end
    end
    @q.push [false, '$end']
    begin
      do_parse
    rescue Racc::ParseError => e
      raise SearchQueryParser::ParseError.new(e)
    end
  end

  def next_token
    @q.shift
  end

---- footer
