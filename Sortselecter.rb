# coding: utf-8


=begin
///////////////////////////////////////////////////////////////////
/                                                                 /
/                 【B-3】並び替えの問題解答プログラム                                                      /
/                                                                 /
/                    Sortselecter.rb　Ver.1                        /
/                    作成日2015年9月16日                                                                       /
/                    制作者:谷　旭志朗                                                                               /
///////////////////////////////////////////////////////////////////
=end

require 'benchmark'
#----------------------------クラス部-------------------------------------
include Math
class SortCollections

  #バブルソート
  def self.bubbleSort(ary)
    #配列要素数
    aryLeng = ary.length
    #返信用配列
    ansAry = []
    #カウンタ
    cut= 0
    until ary.empty?
      cut +=1
      (aryLeng-cut).times{ |i|
        #入れ替え部
        if ary[i] < ary[i+1]
          ary[i], ary[i+1] = ary[i+1], ary[i]
        end
      }
      #結果挿入
      ansAry.push(ary.delete_at(-1))
    end
    return ansAry
  end
  #バブルソートEND

  #マージソート
  #マージソートメイン
  def self.mergeSort(ary)
    #配列要素が1まで行ったら再帰終了
    return ary if ary.length <= 1
    #配列を分割
    a, b = half(ary).map{|e| mergeSort(e) }
    #分割した配列の並び替え統合
    merge(a, b)
  end
  #マージソート 二分割器
  def self.half(hAry)
    #配列の二分割ポイント計算
    midAry = hAry.length/2
    #二つに分割した配列を返す
    return hAry.slice(0...midAry), hAry.slice(midAry..-1)
  end
  #マージソート マージ器
  def self.merge(a, b)
    #結果収納配列
    ansAry = []
    #case whenの条件にしたがって並び替えを行う
    until a.empty? && b.empty?
      #並び替え結果の格納
      ansAry <<
        case
        when a.empty? then b.shift
        when b.empty? then a.shift
        when a.first < b.first then a.shift
        else b.shift
        end
    end
    return ansAry
  end
  #マージソートEND

  #クイックソート
  def self.quickSort(ary)
    #配列の要素が1になったら再帰終了
    return ary if ary.size <= 1
    #任意の要素(最後尾)抽出
    center = ary.pop
    #任意の要素との大小関係を調べsmallerとbiggerに分ける
    smaller, bigger = ary.partition{|i| i < center}
    #要素を結合
    quickSort(smaller) + [center] + quickSort(bigger)
  end
  #クイックソートEND

  #ソート
  def self.ssort(ary)

    selectID = orderSelevter(ary)

    useAry = ary.dup

    case selectID
    when 0
      #バブルソート
      typeName = "バブルソート"
      ansAry = bubbleSort(useAry)
    when 1
      #クイックソート
      typeName = "クイックソート"
      ansAry = quickSort(useAry)
    else
      #マージソート
      typeName = "マージソート"
      ansAry = mergeSort(useAry)
    end

    return typeName,ansAry
  end

  #計算量測定
  def self.orderSelevter(ary)
     #n = ary.length
     #aryEnd = ary[n-1]    #配列最後尾
     #aryMax = ary.max     #最大要素
     #aryMin = ary.min     #最小要素

    selecter = 0
    #ソートセレクト条件部
    #クイックソート
    sortChecker, defLevAry = quickSortChecker(ary)
    selecter = selecter + 10 if sortChecker == 1
    #バブルソート
    selecter = selecter + 100 if sortChecker == 0
    selecter = selecter + 100 if defLevAry.to_f <  ary.length.to_f*0.7 && ary.length < 100 #極力バブルソートは使いたくない。使ってもイライラしないときは+100
    #p selecter
    #ソートセレクター
    case  selecter
    when 200,210 then
        #バブルソート
        return 0
    when 10,11 then
        #クイックソート
        return 1
    else
        #マージソート
        return 2
    end

  end

  #クイックソート効率チェック
  def self.quickSortChecker(ary)
  #入力されたデータの並びを調べ、クイックソートを使用するか選択する
    aryLength = ary.length
    plusCounter = 0
    minusCounter = 0
    paramFlg = 0
    contigAry = Array.new       #昇順・降順連続位置確認
    #一階階差による整列度合いの確認
    (aryLength-1).times{|i|
               if (ary[i+1] - ary[i]) >= 0
                 plusCounter +=1
                 if paramFlg == 1
                    contigAry << minusCounter
                    minusCounter = 0
                    paramFlg = 0
                 end
               else
                 minusCounter -=1
                 if paramFlg == 0
                    contigAry << plusCounter
                    plusCounter = 0
                    paramFlg = 1
                 end
               end

               if (aryLength - 2) == i
                 contigAry << plusCounter if paramFlg == 0
                 contigAry << minusCounter if paramFlg == 1
               end
     }

    #連番箇所の確認
    contigTotaly = 0
    contigAry.each{|count|
      unless count.abs == 1
        contigTotaly = contigTotaly + count.abs
      end
    }


    #最悪実行時間発生仮定粗確率
    pd = (contigTotaly.to_f/aryLength.to_f)
    #最悪実行時間込み粗計算時間
    #badCal = ((contigTotaly)**2)*pd + ((aryLength - contigTotaly)*log2(aryLength - contigTotaly))*(1.0-pd)
    #平均計算時間
    #avgCal = (aryLength)*log(aryLength)

    return 0,0 if pd**2 > 0.5
    return 1,contigTotaly
  end
end




#----------------------------メイン部-------------------------------------

#サンプルデータ作成
  sampleAry = []
  #sampleAry = (1..5000).sort_by{rand}
  10000.times{sampleAry << rand(1..10000)}
  #sampleAry = [5,8,2,6,4,5]
  #sampleAry << 30000
  #sampleAry = [1,2,3,4,5,6,7,8,9,15,14,12,18,19,25,20,100]
  #sampleAry = (1..5000).sort
  #sampleAry = (1..50).sort

  typeName,sortedSet = SortCollections.ssort(sampleAry)

  #サンプルデータによるソート形式の選択とソート結果出力
  puts "#{typeName}\n #{sortedSet} \n End"
