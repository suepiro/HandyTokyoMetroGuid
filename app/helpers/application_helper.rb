module ApplicationHelper
	require "csv"
	
	#ページごとの完全なタイトルを返す
	def full_title(page_title)
		base_title = "Handy Tokyo-Metro Guide"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end

	#路線を返す関数
	#rawTrainLine:apiから取得した生の路線情報
	#return:路線
	def getTrainLineJP(rawTrainLine)
		trainLineMap = {}
		trainLineMap["Ginza"] = "銀座線"
		trainLineMap["Marunouchi"] = "丸ノ内線"
		#trainLineMap[] = "丸ノ内線（分岐線）"
		trainLineMap["Hibiya"] = "日比谷線"
		trainLineMap["Chiyoda"] = "千代田線"
		#trainLineMap[] = "千代田線（支線）"
		trainLineMap["Yurakucho"] = "有楽町線"
		trainLineMap["Hanzomon"] = "半蔵門線"
		trainLineMap["Nanboku"] = "南北線"
		trainLineMap["Fukutoshin"] = "副都心線"
		trainLineMap["Tozai"] = "東西線"

		trainLineMap.each {|key,value|
			check = rawTrainLine.include?(key)
			if check == true
				return value
			end
		}
		return nil
	end

	#行き先を返す関数
	#rawTrainBound:apiから取得した行き先
	#return:行き先
	def getTrainBoundJP(rawTrainBound)
		trainBoundJP = {}
		trainBoundJP[["銀座線","Shibuya"]] = "浅草 → 渋谷" 
		trainBoundJP[["銀座線","Asakusa"]] = "渋谷 → 浅草" 
		trainBoundJP[["銀座線","Ogikubo"]] = "池袋 → 荻窪" 
		trainBoundJP[["銀座線","Shibuya"]] = "浅草 → 渋谷" 
		trainBoundJP[["銀座線","Shibuya"]] = "浅草 → 渋谷" 
		trainBoundJP[["銀座線","Shibuya"]] = "浅草 → 渋谷" 
		trainBoundJP[["銀座線","Shibuya"]] = "浅草 → 渋谷" 
		trainBoundJP[["銀座線","Shibuya"]] = "浅草 → 渋谷" 
		trainBoundJP[["銀座線","Shibuya"]] = "浅草 → 渋谷" 
		trainBoundJP[["銀座線","Shibuya"]] = "浅草 → 渋谷" 
		trainBoundJP[["銀座線","Shibuya"]] = "浅草 → 渋谷" 
		trainBoundJP[["銀座線","Shibuya"]] = "浅草 → 渋谷" 
		trainBoundJP[["銀座線","Shibuya"]] = "浅草 → 渋谷" 
		trainBoundJP[["銀座線","Shibuya"]] = "浅草 → 渋谷" 
	end
end