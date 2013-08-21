
require 'Bacon_Colored'
require "Jam_Func"

describe 'Jam_Func.on'  do

  it 'adds function to main jam' do
    class << self
      include Jam_Func::DSL
    end

    v = []
    on( 'one', lambda { |o, last, jam| v.push 1 } )
    on( 'one', lambda { |o, last, jam| v.push 1 } )
    run 'one', lambda { |o| v.push 1 }

    v.should.equal [1,1,1]
  end

end # -- === end desc


describe 'Jam_Func.on_error'  do

  it 'adds function to main jam' do
    class << self
      include Jam_Func::DSL
    end

    v = []
    on_error( 'some error', lambda { |o, val| v.push val } )
    run 'one', lambda { |o, last, jam| jam.error('some error', 1) }

    v.should.equal [1]
  end

end # -- === end desc
