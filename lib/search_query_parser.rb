require "search_query_parser/version"
require "search_query_parser/interpreter"

module SearchQueryParser
  @interpreter = SearchQueryParser::Interpreter.new

  def self.to_string(str)
    @interpreter.parse(str).to_s
  end

  def self.to_ts_query(str, language = 'english', prefix = true)
    language = language.gsub(/[^a-zA-Z\-]/, '')
    @interpreter.parse(str).reduce do |op, x, y|
      case op
      when :term
        if prefix
          %Q{to_tsquery('#{language}', '#{x}:*')}
        else
          %Q{to_tsquery('#{language}', '#{x}')}
        end
      when :not
        %Q{(!! #{x})}
      when :and
        %Q{(#{x} && #{y})}
      when :or
        %Q{(#{x} || #{y})}
      when :join
        %Q{(#{x} <-> #{y})}
      end
    end
  end
end
