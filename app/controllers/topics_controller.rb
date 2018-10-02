# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
class TopicsController < ApplicationController

  def index
    @topics = Topic.all
    @topics.each do |topic|
      scrape(topic)
    end
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)

    if @topic.save
      redirect_to topics_path, notice: '記事を登録しました。'
    else
      redirect_to new_topic, notice: '記事を登録できませんでした。'
    end
  end

  def show
    @topic = Topic.find(params[:id])
    @topics = Topic.all
    @topic = Topic.new
  end
end


private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(current_user.id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def topic_params
    params.require(:topic).permit(:url, :user_id)
  end

  def scrape(topic)
    url = topic.url
    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end

    # htmlをパース(解析)してオブジェクトを作成
    doc = Nokogiri::HTML.parse(html, nil, charset)

    # title
    if doc.css('//meta[property="og:title"]/@content').empty?
      p doc.title.to_s
    else
      doc.css('//meta[property="og:title"]/@content').to_s
      topic.title = doc.title.to_s
    end

    # description
    if doc.css('//meta[property="og:description"]/@content').empty?
      # p doc.css('//meta[name$="escription"]/@content').to_s
    else
      topic.description = doc.css('//meta[property="og:description"]/@content').to_s
    end

    # image
    topic.image = doc.css('//meta[property="og:image"]/@content').to_s
  end
