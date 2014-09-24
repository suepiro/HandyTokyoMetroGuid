class IndexController < ApplicationController

	skip_before_filter :verify_authenticity_token ,:only=>[:stationElectronicBillboards]

	require 'httpclient'
	require 'sinatra'
	require 'yaml' # YAMLを扱うライブラリ
	require 'date' # 時刻ライブラリ
	require 'json' # JSONを扱うライブラリ

	API_ENDPOINT   = 'https://api.tokyometroapp.jp/api/v2/'
	DATAPOINTS_URL = API_ENDPOINT + "datapoints"
	PLACES_URL     = API_ENDPOINT + "places"
	ACCESS_TOKEN   = '129bbe0d0c766b4a361a3e85469c19450cca6ef9bf02f06dbd03097bdaf839fa'
	PLACES_RADIUS  = 1000 # Places APIでの検索半径(m)

	def home
	end

	def stationElectronicBillboards
		# 受け取った緯度経度周辺にある地物（駅）を、
  		# places API を利用して検索しています。
  		http_client = HTTPClient.new
  		response = http_client.get PLACES_URL,
  		{ "rdf:type"=>"odpt:Station",
      	  "lat"     =>params[:lat],
      	  "lon"     =>params[:lon],
      	  "radius"  => PLACES_RADIUS,
      	  "acl:consumerKey"=>ACCESS_TOKEN 
      	}

		# 検索結果のうち、東京メトロの駅のみを抽出しています。
  		@near_stations = {}
      @near_stations2 = []
  		JSON.parse( response.body ).each do |station|

          ##駅情報生成
          tmpStation = Station.new()
          tmpStation.name = station["dc:title"]

          #プラットフォーム情報生成
          tmpPlatform = Platform.new()

      		stationName = station["dc:title"]
      		stationLine = station["odpt:railway"]
      		@near_stations[[stationName,stationLine]] = station
      	  @near_stations2 << tmpStation
        end
      	puts @near_stations.size
        @near_stations2.each do |s|
          puts s.name
        end
      	respond_to do |format|
      	   	format.js
      	end
      	#render :partial => "stationElectronicBillboards",locals: { near_stations: @near_stations }
	end

  #CSVファイルから、路線マップとプラットフォーム情報を取得する関数
  #駅名
  #路線
  #返却値：[] 指定した駅が所属する路線マップ
  def getTrainLineAndStationData(stationName,lineName)
    lineMap = []
    csvDataFile = "python script/stationData.csv" #形式[路線、駅名、プラットフォーム情報、駅の詳細情報サイトへのリンク、急行が停止するかの有無]
    
    CSV.foreach(csvDataFile, encoding: "SJIS") do |row|
      csvStationName = row[1]
      csvLineName = row[0]

      #路線が同一な場合
      if csvLineName == lineName
        lineMap << csvStationName
      end
    end
    return lineMap
  end

  # 駅クラス
  class Station
  	@name = ""		#駅名
  	@platforms = []	#駅にあるプラットフォームの情報

  	#@nameに代入用関数
  	def name=(_name)
  		@name = _name
  	end

  	#@nameを返却する関数
  	def name
  		@name
  	end

  end

  # プラットフォームクラス
  class Platform
  	@number = nil	#プラットフォームの番号	
  	@line = ""		#路線
  	@trains = []		#そのプラットフォームに到着する電車情報
  	@bound = ""		#行き先
  	@stationMap = []	#路線マップ

  	#以下、変数代入用関数
  	def number=(_number)
  		@number = _number
  	end

  	def line=(_line)
  		@line = _line
  	end

  	def trains=(_train)
  		@trains << _train
  	end

  	def bound=(_bound)
  		@bound = _bound
  	end

  	def stationMap=(_station)
  		@stationMap << _station
  	end

  	#以下、変数参照用関数
  	def number
  		@number
  	end

  	def line
  		@line
  	end

  	def trains
  		@trains
  	end

  	def bound
  		@bound
  	end

  	def statinMap
  		@stationMap
  	end

  end

  # 電車クラス
  class Train
  	@kind = ""				#各停、急行なのか
  	@late = ""				#遅延情報
  	@location = []			#位置
  	@bound = ""				#行き先
  	@willArriveTime = ""		#この駅に到着する時間
  	@stopStationMap = []		#停車する駅

  	#以下、変数代入用関数
  	def kind=(_kind)
  		@kind = _kind
  	end

  	def late=(_late)
  		@late = _late
  	end

  	def location=(_lat,_lon)
  		@location << _lat
  		@location << _lon
  	end

  	def bound=(_bound)
  		@bound = _bound
  	end

  	def willArriveTime=(_willArriveTIme)
  		@willArriveTime = _willArriveTIme
  	end

  	def stopStationMap(_station)
  		@stopStationMap << _station
  	end

  	#以下、変数参照用関数
  	def kind
  		@kind
  	end

  	def late
  		@late
  	end

  	def location
  		@location
  	end

  	def bound
  		@bound
  	end

  	def willArriveTime
  		@willArriveTime
  	end

  	def stopStationMap
  		@stopStationMap
  	end
  end

end
