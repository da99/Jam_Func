
require "bacon"
require "Jam_Func"

describe "Jam_Func" do

  it "runs" do
    a = []
    Jam_Func.new
    .on('hello all', lambda { a.push(1) })
    .run('hello all')

    a.should.be.equal [1]
  end

end # === describe
