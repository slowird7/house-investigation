module ApplicationHelper
  # 和暦な日付文字列を得る。尚、「元年」は「1年」と表記する。
  # !!!!!!!!! 引数の date は必ず jisx0301 で変換できる値であること !!!!!!!!!
  def disp_wareki(date)
    if date.blank?
      sprintf('')
    else
      unless date.is_a?(Date)
        date = date.to_date
      end
      
      _wareki, mon, day = date.jisx0301.split(".")
      gengou, year = _wareki.partition(/\d+/).take(2) # 元号と和暦の年に分解
  
      # 元号のアルファベットを漢字に変換
      gengou.gsub!('M', '明治')
      gengou.gsub!('T', '大正')
      gengou.gsub!('S', '昭和')
      gengou.gsub!('H', '平成')
      gengou.gsub!('R', '令和')
 
      # ゼロサプレスした和暦の日付を返す
      sprintf("%s%d年%d月%d日", gengou, year.to_i, mon.to_i, day.to_i)
    end
  end

  def disp_user_role(role)
    if role == "superuser"
      return "システム管理者"
    elsif role == "admin"
      return "管理者"
    elsif role == "operator"
      return "オペレーター"
    elsif role == "outside_operator"
      return "外部オペレーター"
    else
      return "unknown"
    end
  end
  
  def disp_alphabet(num)
    q = (num - 1).div(26) # 商
    r = num.modulo(26) # 余り
    
    return front_alphabet(q) + back_alphabet(r)
  end
  
  def front_alphabet(digit)
    if digit == 0
      return ""
    elsif digit == 1
      return "A"
    elsif digit == 2
      return "B"
    elsif digit == 3
      return "C"
    elsif digit == 4
      return "D"
    elsif digit == 5
      return "E"      
    elsif digit == 6
      return "F"
    elsif digit == 7
      return "G"
    elsif digit == 8
      return "H"
    elsif digit == 9
      return "I"
    elsif digit == 10
      return "J"
    elsif digit == 11
      return "K"      
    elsif digit == 12
      return "L"
    elsif digit == 13
      return "M"
    elsif digit == 14
      return "N"
    elsif digit == 15
      return "O"
    elsif digit == 16
      return "P"
    elsif digit == 17
      return "Q"      
    elsif digit == 18
      return "R"
    elsif digit == 19
      return "S"
    elsif digit == 20
      return "T"
    elsif digit == 21
      return "U"
    elsif digit == 22
      return "V"
    elsif digit == 23
      return "W"      
    elsif digit == 24
      return "X"
    elsif digit == 25
      return "Y"
    elsif digit == 26
      return "Z"
    else
      return "unknown"
    end
  end

  def back_alphabet(digit)
    if digit == 0
      return "Z"
    elsif digit == 1
      return "A"
    elsif digit == 2
      return "B"
    elsif digit == 3
      return "C"
    elsif digit == 4
      return "D"
    elsif digit == 5
      return "E"      
    elsif digit == 6
      return "F"
    elsif digit == 7
      return "G"
    elsif digit == 8
      return "H"
    elsif digit == 9
      return "I"
    elsif digit == 10
      return "J"
    elsif digit == 11
      return "K"      
    elsif digit == 12
      return "L"
    elsif digit == 13
      return "M"
    elsif digit == 14
      return "N"
    elsif digit == 15
      return "O"
    elsif digit == 16
      return "P"
    elsif digit == 17
      return "Q"      
    elsif digit == 18
      return "R"
    elsif digit == 19
      return "S"
    elsif digit == 20
      return "T"
    elsif digit == 21
      return "U"
    elsif digit == 22
      return "V"
    elsif digit == 23
      return "W"      
    elsif digit == 24
      return "X"
    elsif digit == 25
      return "Y"
#    elsif digit == 26
#      return "Z"
    else
      return "unknown"
    end
  end

end