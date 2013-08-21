
require 'Bacon_Colored'
require "Jam_Func"
One = Jam_Func.new

describe 'data[:val]'  do

  it 'gets updated with jam.val' do
    v = 0

    One.on  'one', lambda { |o, last, jam| jam.val(1) }
    One.run 'one', lambda { |o| v = o[:val] }

    v.should.equal 1
  end

end # -- === end desc
