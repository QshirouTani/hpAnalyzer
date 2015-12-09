# coding: utf-8


=begin
///////////////////////////////////////////////////////////////////
/                                                                 /
/                 【B-1】判定問題解答プログラム                                                                  /
/                                                                 /
/                    StringMatcher.rb　Ver.1                       /
/                    作成日2015年9月14日                                                                        /
/                    制作者:谷　旭志朗                                                                                /
///////////////////////////////////////////////////////////////////
=end
#-----------------------　クラス部　-------------------------------

#StringMatcherクラス
class StringMatcher
=begin
 あらかじめ用意されたドメイン名の集合D(domainNamesAry)のいずれかが、与えられたホスト名(hostName)の
終端になるか判定するクラス。
戻り値はtrue(false)。
=end
   attr_accessor :domainNames

     def initialize(domainNamesAry)
       @domainNames = domainNamesAry
     end

  #判定メソッド
  def endsWith(hostName)
      @domainNames.each{|dName|
      if hostName =~ /.*#{dName}$/ then
        return true
      end
      }
      return false
  end

end

#----------------------------メイン部--------------------------------------
  #ターゲットホスト名
  targetHostName = "www.weblio.jp"

  #ターゲットドメイン名集合配列
  targetDomainNames = ["yahoo.co.jp","google.co.jp","weblio.jp"]

  #StringMatcherのインスタンス
  stringMatcher = StringMatcher.new(targetDomainNames)

#-------------------判定部----------------------------------------------
  #ターゲットホスト名の終端にターゲットドメイン名があれば(true)ターゲットホスト名を表示する
  #無かった場合(false)は何も表示されない。
  if stringMatcher.endsWith(targetHostName) then
    puts"#{targetHostName}\n"
  end
