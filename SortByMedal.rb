# coding: utf-8


=begin
///////////////////////////////////////////////////////////////////
/                                                                 /
/                 【A-2】並び替えの問題解答プログラム                                                      /
/                                                                 /
/                    SortByMedal.rb　Ver.1                         /
/                    作成日2015年9月14日                                                                       /
/                    制作者:谷　旭志朗                                                                               /
///////////////////////////////////////////////////////////////////
=end

require 'csv'

#-----------------------データ入力部------------------
#読み込みデータ設定
medal_data_file =  './medal_results.tsv'

#無加工データ取り込み配列
medal_data_ary = Array.new

#データ読み読み
CSV.foreach(medal_data_file){ |file|
    list = file.join.split("\t")                                      #配列->文字列変換
    1.upto(3){|list_index|
       list[list_index] = list[list_index].to_i                       #文字列->数値への型変換
    }
     medal_data_ary << list                                           #一レコードごとmedal_data_aryへ追記
}

#-----------------------ソート部-------------------
 g_medal_ary =  medal_data_ary.sort{|a,b| b[1] <=> a[1]}              #金メダルの数で一旦ソート

#金メダル以外の条件によるソート
((g_medal_ary.size)-1).times{|index|
  flg = 0                                                             #ケース別ソート判定フラグ変数
  flg = flg +100 if g_medal_ary[index][1] == g_medal_ary[index+1][1]  #金メダルの数が同じ場合
  flg = flg +10 if g_medal_ary[index][2] == g_medal_ary[index+1][2]   #銀メダルの数が同じ場合
  flg = flg +20 if g_medal_ary[index][2] < g_medal_ary[index+1][2]    #銀メタルの数が多い場合
  flg = flg +1 if g_medal_ary[index][3] == g_medal_ary[index+1][3]    #銅メダルが同じ場合
  flg = flg +2 if g_medal_ary[index][3] < g_medal_ary[index+1][3]     #銅メダルの数が多い場合
  flg = flg +1000 if g_medal_ary[index][0] > g_medal_ary[index+1][0]  #国別コードの辞書式順序が逆の場合

=begin
 #ケース別ソート処理
  以下の条件の場合、順序を入れ替える
    １）金メダルがより多い国の順位を繰り上げる
    ２）金メダルの数が同一の場合は、銀メダルがより多い国を繰り上げる
    ３）金・銀メダルの数が共に同一の場合は、銅メダルがより多い国を切り上げる
    ４）金・銀・銅メダルの数が全て同一の場合は、国名が辞書式順序でより先頭になる国を切り上げる
=end
  case flg
  when 120,121,122,110,112,1111 then

    g_medal_ary[index],g_medal_ary[index+1] = g_medal_ary[index+1],g_medal_ary[index]

  end
}


#---------------------表示部------------------
country_num = 1
#インデックス表示
puts "\t金 \t銀 \t銅"
#ソート結果表示
g_medal_ary.each{|list|
  #puts "#{country_num}\t#{list[0]}\t#{list[1]}\t#{list[2]}\t#{list[3]}"
  printf("%d\s%s\t%2d\t%2d\t%2d\n",country_num,list[0],list[1],list[2],list[3])
  country_num +=1
}