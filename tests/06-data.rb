
require 'Bacon_Colored'
require "Jam_Func"
One = Jam_Func.new


describe 'data' do

  it 'holds changes done in callbacks' do
    One.on('change', lambda { |f|
      f[:a] = 1
    })

    data = {}
    One.run('change', data)

    data[:a].should.equal 1
  end

  it 'merges changes done in callbacks' do
    One.on('merge', lambda { |f|
      f[:b] = 2
    })

    data = {}
    One.run('merge', data)

    data[:b].should.equal 2
  end

  it 'merges multiple objects into the first' do
    One.on('multi-merge', lambda { |f|
      f[:c] = 3
    })

    d1 = {}
    d2 = {:d=>4}
    One.run('multi-merge', d1, d2)

    d1.should.equal({:c=>3, :d=>4})
  end

end # -- === end desc
