# encoding: UTF-8
require 'spec_helper'

describe Correios::Frete::Pacote do
  before(:each) { @pacote = Correios::Frete::Pacote.new }

  describe ".new" do
    context "create with default value of" do
      { :peso => 0.0,
        :comprimento => 0.0,
        :altura => 0.0,
        :largura => 0.0
      }.each do |attr, value|
        it attr do
          @pacote.send(attr).should == value
        end
      end

      it "itens" do
        @pacote.itens.should be_empty
      end
    end
  end

  describe "#formato" do
    it "is caixa/pacote" do
      @pacote.formato.should == :caixa_pacote
    end
  end

  describe "#adicionar_item" do
    context "when adds a package item" do
      it "adds in items" do
        item = Correios::Frete::PacoteItem.new
        @pacote.adicionar_item(item)
        @pacote.itens.first.should == item
      end
    end

    context "when adds package item params" do
      it "adds new item" do
        params = { :peso => 0.3, :comprimento => 30, :largura => 15, :altura => 2 }
        @pacote.adicionar_item(params)

        @pacote.itens.first.peso.should == params[:peso]
        @pacote.itens.first.comprimento.should == params[:comprimento]
        @pacote.itens.first.altura.should == params[:altura]
        @pacote.itens.first.largura.should == params[:largura]
      end
    end

    context "when adds nil item" do
      it "does not add" do
        @pacote.adicionar_item(nil)
        @pacote.itens.should be_empty
      end
    end
  end

  describe "calculations" do
    before :each do
      @item1 = Correios::Frete::PacoteItem.new(:peso => 0.3, :comprimento => 30, :largura => 15, :altura => 2)
      @item2 = Correios::Frete::PacoteItem.new(:peso => 0.7, :comprimento => 70, :largura => 25, :altura => 3)
    end

    context "when adds one package item" do
      it "calculates package weight" do
        @pacote.adicionar_item(@item1)
        @pacote.peso.should == @item1.peso
      end

      it "calculates package volume" do
        @pacote.adicionar_item(@item1)
        @pacote.volume.should == @item1.volume
      end

      it "calculates package length" do
        @pacote.adicionar_item(@item1)
        @pacote.comprimento.should == @item1.comprimento
      end

      it "calculates package width" do
        @pacote.adicionar_item(@item1)
        @pacote.largura.should == @item1.largura
      end

      it "calculates package height" do
        @pacote.adicionar_item(@item1)
        @pacote.altura.should == @item1.altura
      end
    end

    context "when adds more than one package item" do
      before :each do
        @expected_dimension = (@item1.volume + @item2.volume).to_f**(1.0/3)
      end

      it "calculates package weight" do
        @pacote.adicionar_item(@item1)
        @pacote.adicionar_item(@item2)
        @pacote.peso.should == @item1.peso + @item2.peso
      end

      it "calculates package volume" do
        @pacote.adicionar_item(@item1)
        @pacote.adicionar_item(@item2)
        @pacote.volume.should == @item1.volume + @item2.volume
      end

      it "calculates package length" do
        @pacote.adicionar_item(@item1)
        @pacote.adicionar_item(@item2)
        @pacote.comprimento.should == @expected_dimension
      end

      it "calculates package width" do
        @pacote.adicionar_item(@item1)
        @pacote.adicionar_item(@item2)
        @pacote.largura.should == @expected_dimension
      end

      it "calculates package height" do
        @pacote.adicionar_item(@item1)
        @pacote.adicionar_item(@item2)
        @pacote.altura.should == @expected_dimension
      end
    end
  end
end
