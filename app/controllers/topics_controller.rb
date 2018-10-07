# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
class TopicsController < ApplicationController
  before_action  :set_article_tags_to_gon, only: [:create]

  def index
    @topics = Topic.all
    # @topics.each do |topic|
    #   scrape(topic)
    # end
  end

  def new
    @topic = Topic.new
  end

  #TODO：ロジック書きすぎ。リファクタする。
  def create
    @topic = Topic.new(topic_params)
    Topic.transaction do
      @topic.url = delete_params(@topic.url)
      @topic.save!
      Evaluation.transaction do
        @evaluation = Evaluation.new(evaluation_params)
        @evaluation.topic_id = @topic.id
        @evaluation.save!
        TopicTag.transaction do
          # @topic_tag = TopicTag.new(topic_tag_params)
          # @topic_tag.topic_id = @topic.id
          # @topic_tag.save!

          #複数登録（テキストを,で分ける）
          tag_list = params.require(:topic).permit(:tag_list)[:tag_list].split(",")
          tag_list.each do |tags|
            @topic_tag = TopicTag.new(topic_tag_list_params)
            @topic_tag.topic_id = @topic.id
            @topic_tag.tag_id = Tag.find_by(name: tags).id
            @topic_tag.save!
          end
        end
        rescue => e
          logger.error(e)
          redirect_to topics_path, notice: 'タグを登録できませんでした。' and return
      end
      rescue => e
        #TODO ここでErrorを作ってTopicの例外処置にrescueさせる
        logger.error(e)
        redirect_to topics_path, notice: '評価を登録できませんでした。' and return
    end
    redirect_to topics_path, notice: '記事と評価とタグを登録しました。'
    rescue => e
      logger.error(e)
      redirect_to topics_path, notice: '記事を登録できませんでした。'
  end

  def show
    @topic = Topic.find(params[:id])
    @topics = Topic.all
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

  def evaluation_params
    params.require(:topic).permit(:user_id, :evaluation)
  end

  def topic_tag_params
    params.require(:topic).permit(:user_id,:tag_id)
  end

  def topic_tag_list_params
    params.require(:topic).permit(:user_id)
  end

  # URLのパラメータ削除
  def delete_params(url)
    if url.include?("?")
      reg = /\?/.match(url)
      return reg.pre_match
    end
    return url
  end

  # タグの予測候補設定
  def set_article_tags_to_gon
    gon.article_tags = Tag.all
  end

  # スクレイピング
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
