
require 'Bacon_Colored'
require "Jam_Func"

describe 'data[:val]'  do

  it 'gets updated with jam.val' do
    v = 0

    j = Jam_Func.new
    j.on  'one', lambda { |o, last, jam| jam.val(1) }
    j.run 'one', lambda { |o| v = o[:val] }

    v.should.equal 1
  end

end # -- === end desc
