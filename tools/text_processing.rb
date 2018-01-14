# This is a class for automatic text upgrade
class TextProcessing
  DOWNCASE_CAPITAL = {'А' => 'а', 'Б' => 'б', 'В' => 'в', 'Г' => 'г', 'Ґ' => 'ґ',
                      'Д' => 'д', 'Е' => 'е', 'Є' => 'є', 'Ж' => 'ж', 'З' => 'з',
                      'И' => 'и', 'І' => 'і', 'Ї' => 'ї', 'Й' => 'й', 'К' => 'к',
                      'Л' => 'л', 'М' => 'м', 'Н' => 'н', 'О' => 'о', 'П' => 'п',
                      'Р' => 'р', 'С' => 'с', 'Т' => 'т', 'У' => 'у', 'Ф' => 'ф',
                      'Х' => 'х', 'Ц' => 'ц', 'Ч' => 'ч', 'Ш' => 'ш', 'Щ' => 'щ',
                      'Ь' => 'ь', 'Ю' => 'ю', 'Я' => 'я'}

  def initialize(text)
    @text = text
  end

  def change_quotes
    @text = @text.gsub(/[„“]/, '„' => '«', '“' => '»')
  end

  def remove_trailing_whitespace
    @text.gsub(/ $/, '').gsub(/^ /, '')
  end

  def capitalize_line(line)
    new_line = []
    line.split(' ').each do |word|
      new_line << downcase_word(word)
    end
    upcase_first_letter(new_line.join(' ')) << "\n"
  end

  def upcase_first_letter(line)
    line[0] = DOWNCASE_CAPITAL.key(line[0]) if DOWNCASE_CAPITAL.has_value?(line[0])
    line
  end

  def downcase_word(word)
    new_word = ''
    word.each_char do |letter|
      DOWNCASE_CAPITAL.include?(letter) ? new_word << DOWNCASE_CAPITAL[letter] : new_word << letter
    end
    new_word
  end

  def uppercase_line?(line)
    return true if line.match(/\p{Upper}/) && !line.match(%r{[\p{Lower}—./\\]})
    false
  end

  def remove_line_breaks
    @text.gsub(/-\n(\S+)\s/, "\\1\n")
    # In plain English, we looking for a pattern (/(-\n)(\S+)\s/),
    # that represent, hyphen then end of a line, then any charcter except
    # whitespace, then whitespace and replace with second group of pattern
    # \\1 means referance to (\S+), then end of a line \n
  end

  def capitalize_heading
    # TODO: somehow remuve new_text variable
    new_text = ''
    @text.each_line do |line|
      uppercase_line?(line) ? new_text << capitalize_line(line) : new_text << line
    end
    @text = new_text
  end

  def add_empty_line
    @text.match(/\S\z/) ? @text << "\n" : @text
    # \z match end of a string
    # \S match any symbol except whitespace and Line seperator
  end

  def replace_double_chars
    @text.gsub(/([+, -, =, —, X])(\n)[+, -, =, —, X]\s/, "\\1\n")
  end

  def get_dash_dict
    r = /([[:alpha:]]+)\ *\-\ *([[:alpha:]]+)/
    # this is syntax for match all
    @text.to_enum(:scan, r).map do 
      m = Regexp.last_match
      puts m[1] + '-' + m[2]
    end
    @text
  end
end
