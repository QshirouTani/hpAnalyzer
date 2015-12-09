#! ruby -Ku
# coding: utf-8


=begin
///////////////////////////////////////////////////////////////////
/                                                                 /
/                 【C】テキスト処理解答プログラム                                                                  /
/                                                                 /
/                    hpAnalyzer.rb　Ver.1                          /
/                    作成日2015年9月18日                                                                       /
/                    制作者:谷　旭志朗                                                                               /
///////////////////////////////////////////////////////////////////
=end

require 'net/http'
require 'uri'
require 'csv'


#-------------------------クラス部---------------------------------
class TextProcessiong

  attr_accessor :urlInfo


  def initialize(urlInfo)
      @urlAddress = urlInfo
  end

  #ホームページリソース取得
  def httpget
    uri = URI.parse(@urlAddress)
    return Net::HTTP.get(uri)
  end

  #取得リソースのファイルへの書き出し
  def uriWrite(fileName,resouse)
    File.open(fileName, 'w'){ |file|
      file.puts(resouse)
    }
  end

  #アンカータグ抽出
  def anchorGet(tag)
    anchorTag = tag.scan(/<a.*?\/a>/)
    return anchorTag
  end

  #アンカーテキスト抽出
  def anchorTextGet(tag)
    anchorTex = tag.slice(/>.+</)
    anchorTex.gsub!(/\u{C2A0}/)
    anchorTex.gsub!(/^>/,'')
    anchorTex.gsub!(/<$/,'')
    anchorTex.gsub!(/^\s/,'')
    anchorTex.gsub!(/"/,"'")
    return anchorTex
  end

  #アンカーTitle属性値抽出
  def anchorTitleGet(tag)
    tmpAry = tag.scan(/title=\".+?\"/)
    anchorTex = tmpAry.join
    anchorTex.gsub!(/title=\"/,"")
    anchorTex.gsub!(/\"$/,"")
    #unless anchorTex == ""
        return anchorTex
    #CSV利用時nilゴミ対策用オプション
    #else
    #  return  " "
    #end
  end

  #アンカーhref属性値抽出
  def anchorUriGet(tag)
    tmpAry = tag.scan(/href=\".+?\"/)
    anchorTex = tmpAry.join
    anchorTex.gsub!(/href=\"/,"")
    anchorTex.gsub!(/\"$/,"")
    return anchorTex
  end


end

class Sorter

  #辞書式順序ソート
    def self.lexicographicOrderSort(originAry)
      sortedAry = Array.new
      recursiveSort(originAry, sortedAry)
    end

    def self.recursiveSort(someAry, sortedAry)
      return sortedAry if someAry.length == 0
      localAry = someAry[0, someAry.length]
      minObj = localAry.pop
      tmpAry = Array.new
      localAry.each{|item|
        if (item[0].downcase < minObj[0].downcase) or (item[0].downcase == minObj[0].downcase and item[0] < minObj[0])
          tmpAry.push(minObj)
          minObj = item
        else
          tmpAry.push(item)
        end
      }
      sortedAry.push(minObj)
      recursiveSort(tmpAry, sortedAry)
    end
end

#-------------------------クラス部END-----------------------------

#-------------------------main部---------------------------------

  uri = 'http://www.weblio-inc.jp/wordpress/company/outline/'
  fileName = "weblio_uri.txt"

  textPec = TextProcessiong.new(uri)

  #ページアクセスオプション。使用時、以下begin/end機能を切る
=begin
  #HTMLソース取得/保存
  souse = textPec.httpget
  textPec.uriWrite(fileName,souse)
=end
  #ファイルデータ一次読み込み配列
  uriTextAry = Array.new
  #アンカータグリスト :アンカータグの要素「(A)アンカーテキスト(B)title属性の値(C)href属性」の格納用
  anchorTagListAry = Array.new

  File.open(fileName, 'r:utf-8'){|file|
      file.each_line{|line|
          uriTextAry << line
      }
  }


  #アンカータグデータ群
  anchorDataAry = Array.new

  #アンカータグ整理器
  uriTextAry.each{|line|
    #アンカータグのみ抽出
    anchor = textPec.anchorGet(line)
    #(A)アンカー整理抽出
    if anchor.length > 1
      #アンカータグが一行に複数ある場合
      anchor.each{|tag|
        anchorDataAry << tag
        #puts "#{tag}\n"
      }
     else
      anchorDataAry << anchor[0] unless anchor[0] == nil
    end
  }


  #総アンカータグ要素格納配列
  anchorCollecsAry = Array.new
  #アンカータグ格納配列[(0)アンカーテキスト(1)title属性の値(2)href属性]
  acAry = Array.new
  #使いまわし配列
  tmpAry = Array.new

  #アンカータグ要素分離器
  anchorDataAry.each{|line|
    #アンカーテキスト抽出
    #p textPec.anchorTextGet(line)
    tmpAry[0] = textPec.anchorTextGet(line)
    #title属性の値抽出
    tmpAry[1] = textPec.anchorTitleGet(line)
    #href属性の値抽出
    tmpAry[2] = textPec.anchorUriGet(line)
    acAry = tmpAry.dup
    anchorCollecsAry << acAry
  }


#=begin
  #ユニークなアンカータグ要素セット
  anchorCollecsArySet = Array.new
  #ユニーク要素排出器
  anchorCollecsArySet = anchorCollecsAry.uniq

  count = 0

  #数字セット
  numSet = Array.new
  anchorCollecsArySet.each{|word|
      if word[0][0,1].tr('０-９', '0-9') =~ /[0-9]/
        numSet << word
      end
  }
  numSet.each{|word| anchorCollecsArySet.delete(word)}


  #アルファベットセット
  alphabetSet = Array.new
  anchorCollecsArySet.each{|word|
      if word[0][0,1].tr!('ａ-ｚＡ-Ｚ', 'a-zA-Z') =~ /[a-zA-Z|]/
        alphabetSet << word
      end
  }
  alphabetSet.each{|word| anchorCollecsArySet.delete(word)}

  #ひらがなカタカナセット
  kanaSet = Array.new
  anchorCollecsArySet.each{|word|
      if word[0][0,1] =~ /[ぁ-んァ-ヴ]/
        kanaSet << word
      end
  }
  kanaSet.each{|word| anchorCollecsArySet.delete(word)}

  #漢字セット
  kannjiSet = Array.new
  anchorCollecsArySet.each{|word|
      if word[0][0,1] =~ /[一-龠々]/
        kannjiSet << word

      end
  }
  kannjiSet.each{|word| anchorCollecsArySet.delete(word)}

  #種別ソート
  #p "記号"
  symbolAnsSet = Sorter.lexicographicOrderSort(anchorCollecsArySet)

  #p "数字"
  numAnsAry = Sorter.lexicographicOrderSort(numSet)

  #p "英字"
  alphabetAnsSet = Sorter.lexicographicOrderSort(alphabetSet)

  #p "かな"
  kanaAnsSet = Sorter.lexicographicOrderSort(kanaSet)

  #p "漢字"
  kannjiAnsSet = Sorter.lexicographicOrderSort(kannjiSet)
  #kannjiAnsSet.each{|word| puts "#{word}\n"}

  #結合
  ansAry = symbolAnsSet + numAnsAry + alphabetAnsSet + kanaAnsSet + kannjiAnsSet

  #コンソール出力
  ansAry.each{|w| puts"#{w.join(',')}\n"}


  #出力形式と同じファイル書き出し用
  File.open("weblio_c_ans.csv", 'w:utf-8'){|file|
      ansAry.each{|line|
          data = line.join(",") + "\n"
          file.write(data)
      }
  }

=begin
  #CVSライブラリを使ったCSVファイルへの書き出し
   CSV.open("weblio_c_ans.csv","w:UTF-8"){|csv|
     ansAry.each{|line|
        csv << line
     }
   }
=end
