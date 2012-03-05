require 'rspec'
require_relative 'luhnybin.rb'

describe Luhnybin do
  before :all do
    @luhn = Luhnybin.new
  end

  describe ".check_luhn" do
    it "is valid for 5678" do
      @luhn.luhn_check?("5678").should be_true
    end

    it "is not valid for 6789" do
      @luhn.luhn_check?("6789").should be_false
    end

    it "is not valid for '4417 1234 5678 9112'" do
      @luhn.luhn_check?('4417 1234 5678 9112').should be_false
    end

    it "is valid for '4408 0412 3456 7893'" do
      @luhn.luhn_check?('4408 0412 3456 7893').should be_true
    end
    it "is valid for '00000000000059'" do
      @luhn.luhn_check?('00000000000059').should == true
    end
  end

  describe ".check_and_mask" do
    it "should mask valid 14 digist number inside 16 digit number" do
      @luhn.check_and_mask('11448 412 3456 7893').should == 'XXXXX XXX XXXX XXXX'
      @luhn.check_and_mask('12448 412 3456 7893').should == 'XXXXX XXX XXXX XXX3'
      @luhn.check_and_mask('1300000000000059').should == '13XXXXXXXXXXXXXX'
    end
  end

  describe ".process_line" do
    it {
      @luhn.process_line('hello 4408 0412 3456 7893').should == 'hello XXXX XXXX XXXX XXXX'
    }

    it "finds valid in long digits word" do
      @luhn.process_line('9875610591081018250321').should == '987XXXXXXXXXXXXXXXX321'
    end

    context "1000 zeros" do
      it "mask all" do
        @luhn.process_line('0' * 1000).should == ('X' * 1000)
      end
    end
  end
end
