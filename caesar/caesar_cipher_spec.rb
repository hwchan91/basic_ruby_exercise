require "caesar_cipher"

describe "cipher converting function" do
  it "shifts a letter by a value" do
    expect(caesar_cipher("a",1)).to eq("b")
  end
end

describe "cipher converting function" do
  it "shifts a letter by a value" do
    expect(caesar_cipher("z",1)).to eq("a")
  end
end

describe "cipher converting function" do
  it "shifts a letter by a value" do
    expect(caesar_cipher("AZ",2)).to eq("CB")
  end
end

describe "cipher converting function" do
  it "converts a string to cipher" do
    expect(caesar_cipher("Abc",1)).to eq("Bcd")
  end
end

describe "cipher converting function" do
  it "converts a string to cipher" do
    expect(caesar_cipher("Good day!",2)).to eq("Iqqf fca!")
  end
end
