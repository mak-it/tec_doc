require "spec_helper"

describe TecDoc::Article do
  context ".search" do
    before do
      VCR.use_cassette('article_search') do
        @articles = TecDoc::Article.search(
          :article_number => "31966",
          :number_type => 10,
          :lang => "lv",
          :country => "lv",
          :sort_type => 1,
          :search_exact => false,
          :brandno => nil,
          :generic_article_id => nil
        )
      end
    end

    it "should return array of articles" do
      @articles.should be_an_instance_of(Array)
      @articles.each do |article|
        article.should be_an_instance_of(TecDoc::Article)
        article.id.should be_kind_of(Integer)
        article.id.should > 0
        article.name.should be_an_instance_of(String)
        article.name.size.should > 0
        article.search_number.size.should > 0
      end
    end

    context "#assigned_article" do
      before do
        @article = @articles.detect { |a| a.brand_name == "FEBI BILSTEIN" && a.number == "31966" }
        VCR.use_cassette('article_assigned_article') do
          @article.send(:assigned_article)
        end
      end

      it "should have EAN number" do
        @article.ean_number.should == "4027816319665"
      end

      it "should have OE numbers" do
        @article.oe_numbers.size.should > 0
        @article.oe_numbers.each do |oe_number|
          oe_number.should be_an_instance_of(TecDoc::ArticleOENumber)
          oe_number.brand_name.should == "BMW"
          oe_number.oe_number.should be_an_instance_of(String)
          oe_number.oe_number.size.should > 0
        end
      end

      it "should have attributes" do
        @article.attributes.size.should > 0
        @article.attributes.each do |attribute|
          attribute.name.should be_an_instance_of(String)
          attribute.name.size.should > 0
          attribute.value.should be_an_instance_of(String)
          attribute.value.size.should > 0
        end
      end
    end
  end
end
