class Luhnybin
  CREDIT_CARD_REGEX = /\d[ \-]?\d[ \-]?\d[ \-]?\d[ \-]?\d[ \-]?\d[ \-]?\d[ \-]?\d[ \-]?\d[ \-]?\d[ \-]?\d[ \-]?\d[ \-]?\d[ \-]?(\d[ \-]?)?(\d[ \-]?)?\d+/

  DIGITS = {'0'=>0, '1'=>1, '2'=>2, '3'=>3, '4'=>4, '5'=>5, '6'=>6, '7'=>7, '8'=>8, '9'=>9}
  
  def process
    ARGF.each_line do |line|
      puts process_line(line)
    end
  end

  def process_line line
    line.gsub(CREDIT_CARD_REGEX) do |match|
      check_and_mask(match)
    end
  end

  def check_and_mask line
    to_replace = []
    count, start, len = [0, 0, 0]
    while start + len <= line.length 
      c = line[start + len]
      len += 1
      count += DIGITS[c] ? 1 : 0
      if count >= 14
        word = line[start, len]
        if luhn_check? word
          to_replace << [start, len]
        end
      end
      if count == 16 || (start + len == line.length && count >= 14)
        start += 1
        count, len = [0, 0]
      end
    end
    chars = line.chars.to_a
    to_replace.each do |start, len|
      len.times do |i|
        c = chars[start + i]
        if (DIGITS[c])
          chars[start + i] = 'X'
        end
      end
    end
    chars.join
  end

  def luhn_check? word
    chars = word.chars.to_a.reverse
    i, sum = [0, 0]
    chars.each do |c|
      num = DIGITS[c]
      if num
        if i%2 == 1
          num += num
          if num >= 10
            num -= 10
            sum += 1
          end
        end
        i += 1
        sum += num
      end
    end 
    sum % 10 == 0
  end
end

if __FILE__ == $PROGRAM_NAME
  Luhnybin.new.process
end
