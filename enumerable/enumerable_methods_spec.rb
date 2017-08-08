require "enumerable_methods"

describe "my_count function" do

  before do
    @ary = [1,2,2,3,3,3]
  end

  context "when no input is given" do
    it "counts the number of items in the array" do
      expect(@ary.my_count).to eql(6)
    end
  end

  context "when a value is given" do
    it "counts the items that matches the value" do
      expect(@ary.my_count(3)).to eql(3)
    end
  end

  context "when a block is given" do
    it "counts the items that match the requirement of the block" do
      expect(@ary.my_count{|i| i > 2}).to eql(3)
    end
  end

end
