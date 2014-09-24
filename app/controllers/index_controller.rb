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
          tmpStation = ApplicationController::Station.new()
          tmpStation.name = station["dc:title"]

          #プラットフォーム情報生成
          tmpPlatform = ApplicationController::Platform.new()

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
end
