# -*- coding: utf-8 -*-

import re

from urllib import urlopen
from HTMLParser import HTMLParser
import urllib2
from BeautifulSoup import BeautifulSoup
import csv

def checkTrainLine(trainLine):
  flag = 0
  if trainLine.startswith(u" 銀座線") or trainLine.startswith(u" 千代田線") or trainLine.startswith(u" 有楽町線") or trainLine.startswith(u" 丸ノ内線") or trainLine.startswith(u" 半蔵門線") or trainLine.startswith(u" 日比谷線") or trainLine.startswith(u" 南北線") or trainLine.startswith(u" 東西線") or trainLine.startswith(u" 副都心線"):
    flag = 1
  return flag

def includeTargetTrainLine(trainInformation):
  flag = 0
  if u"銀座線" in trainInformation or u"千代田線" in trainInformation or u"有楽町線" in trainInformation or u"丸ノ内線" in trainInformation or u"半蔵門線" in trainInformation or u"日比谷線" in trainInformation or u"南北線" in trainInformation or u"東西線" in trainInformation or u"副都心線" in trainInformation:
    flag = 1
  return flag

import re

from urllib import urlopen
from HTMLParser import HTMLParser
import urllib2
from BeautifulSoup import BeautifulSoup

def main():
  targetURLlist = [
  ["http://ja.wikipedia.org/wiki/%E6%9D%B1%E4%BA%AC%E3%83%A1%E3%83%88%E3%83%AD%E5%89%AF%E9%83%BD%E5%BF%83%E7%B7%9A",1,u"副都心線"],
  ["http://ja.wikipedia.org/wiki/%E6%9D%B1%E4%BA%AC%E3%83%A1%E3%83%88%E3%83%AD%E5%8D%83%E4%BB%A3%E7%94%B0%E7%B7%9A",2,u"千代田線"],
  ["http://ja.wikipedia.org/wiki/%E6%9D%B1%E4%BA%AC%E3%83%A1%E3%83%88%E3%83%AD%E9%8A%80%E5%BA%A7%E7%B7%9A",0,u"銀座線"],
  ["http://ja.wikipedia.org/wiki/%E6%9D%B1%E4%BA%AC%E3%83%A1%E3%83%88%E3%83%AD%E6%9C%89%E6%A5%BD%E7%94%BA%E7%B7%9A",0,u"有楽町線"],
  ["http://ja.wikipedia.org/wiki/%E6%9D%B1%E4%BA%AC%E3%83%A1%E3%83%88%E3%83%AD%E4%B8%B8%E3%83%8E%E5%86%85%E7%B7%9A",0,u"丸ノ内線"],
  ["http://ja.wikipedia.org/wiki/%E6%9D%B1%E4%BA%AC%E3%83%A1%E3%83%88%E3%83%AD%E5%8D%8A%E8%94%B5%E9%96%80%E7%B7%9A",0,u"半蔵門線"],
  ["http://ja.wikipedia.org/wiki/%E6%9D%B1%E4%BA%AC%E3%83%A1%E3%83%88%E3%83%AD%E6%97%A5%E6%AF%94%E8%B0%B7%E7%B7%9A",0,u"日比谷線"],
  ["http://ja.wikipedia.org/wiki/%E6%9D%B1%E4%BA%AC%E3%83%A1%E3%83%88%E3%83%AD%E5%8D%97%E5%8C%97%E7%B7%9A",0,u"南北線"],
  ["http://ja.wikipedia.org/wiki/%E6%9D%B1%E4%BA%AC%E3%83%A1%E3%83%88%E3%83%AD%E6%9D%B1%E8%A5%BF%E7%B7%9A",1,u"東西線"]
  ]

  for target in targetURLlist:
    extractTrainInformation(target[0],target[1],target[2])

def extractTrainInformation(targetURL,hasRapidTrain,lineName):

  csvFile = open('stationData.csv', 'ab') #ファイルが無ければ作る、の'a'を指定します
  csvWriter = csv.writer(csvFile)
  
  target = "http://ja.wikipedia.org/wiki/%E6%9D%B1%E4%BA%AC%E3%83%A1%E3%83%88%E3%83%AD%E5%89%AF%E9%83%BD%E5%BF%83%E7%B7%9A"

  target = targetURL
  opener = urllib2.build_opener()
  html = opener.open(target)

  #<table class="wikitable" rules="all">

  soup = BeautifulSoup(html)
  result =  soup.findAll("table",{"class":"wikitable","rules":"all"})
  #print result
  #print len(result)

  #print len(result[0].findAll("tr"))

  resultTR = result[0].findAll("tr")
  for station in resultTR:

    print "-----------------"
    #getting station name
    tempResult = station.findAll("a")
    if len(tempResult) != 0:
      stationName = tempResult[0].text
      stationDetailLink = tempResult[0].get("href")
      platformArray = []
      print "station name " + stationName
      print "station detail " + "http://ja.wikipedia.org"+stationDetailLink

      #getting stop train kind 1:rapid and jun rapid 2:only rapid
      rapidInfor1 = ""
      rapidInfor2 = ""
      if hasRapidTrain == 1 or hasRapidTrain == 2:
        tempResult2 = station.findAll("td")
        rapidInfor1 = tempResult2[3].text
        print "working rapd train " + rapidInfor1
        if hasRapidTrain == 1:
          rapidInfor2 = tempResult2[4].text
          print "rapid train " + rapidInfor2

      #getting platform information
      openerPlatform = urllib2.build_opener()
      htmlPlatform = openerPlatform.open("http://ja.wikipedia.org"+stationDetailLink)
      soupForPlatform = BeautifulSoup(htmlPlatform)
      platformTableResult = soupForPlatform.findAll("table",{"class":"wikitable"})

      print "++platform number++"

      for eachPlatformTableResult in platformTableResult:    
        resultTRplatform =  eachPlatformTableResult.findAll("tr")

        platformLine = "" #路線名
        platformNo   = "" #番線
        # trでまわす
        for platformNnumber in resultTRplatform:
          selectedPlatformNumberTH = platformNnumber.findAll("th") # th get プラットフォームNoがあるかもしれない
          selectedPlatformNumberTD = platformNnumber.findAll("td") # td get 方面

          for eachPlatformNumberTD in selectedPlatformNumberTD:       #路線があるかをチェック　
            if eachPlatformNumberTD.text.endswith(u"線"):
              platformLine = "" 
          
          flag = 0
          for eachPlatformNumberTH in selectedPlatformNumberTH:         #thの中身が数字であることを確認
            if eachPlatformNumberTH.text.replace(u"・","").isdigit():
              flag = 1
              platformNo = ""

          if flag == 1 or len(platformNo) != 0:                       #thの中身が数字であった場合　or 以前に番線を取得していた場合
            for eachPlatformNumberTH in selectedPlatformNumberTH:       #番線取得
              platformNo = eachPlatformNumberTH.text
            for eachPlatformNumberTD in selectedPlatformNumberTD:       #路線と方面取得　路線がない場合がある　
              platformLine = platformLine + " " + eachPlatformNumberTD.text
              finalResult = platformNo + " " + platformLine
            #print finalResult
            if checkTrainLine(platformLine) == 1 and u"方面" in platformLine:
              finalResult = platformNo + " "
              for i in range(0,len(platformLine.split(u"方面"))-1):
                finalResult = finalResult + platformLine.split(u"方面")[i] + u"方面"
              #結果を出力
              print "result =>" + finalResult
              platformArray.append(finalResult)
            
            platformLine = " " + platformLine.split(" ")[1]


      #csv出力
      csvData = []
      csvData.append(lineName.encode('sjis'))          #路線
      csvData.append(stationName.encode('sjis'))       #駅名
      for p in platformArray:           #プラットフォームの情報を追加する
        csvData.append(p.encode('sjis'))
      csvData.append(r"http://ja.wikipedia.org"+stationDetailLink.encode('sjis')) #駅の詳細情報が記載されているページのリンク
      csvData.append(rapidInfor1.encode('sjis'))       #快速が止まるかの情報
      csvData.append(rapidInfor2.encode('sjis'))       #快速が止まるかの情報
      csvWriter.writerow(csvData) 
      print "------------------"
  csvFile.close()

if __name__ == '__main__':
  main()
