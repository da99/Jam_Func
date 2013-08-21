
require 'Bacon_Colored'
require "Jam_Func"
TH  = Jam_Func.new()

TH.on 'before add', lambda { |o|
  o[:result].push 1
}

TH.on 'before add', lambda { |o|
  o[:result].push 2
}

TH.on 'add', lambda { |o|
  o[:result].push 3
}

TH.on 'after add', lambda { |o|
  o[:result].push 4
}

TH.on 'after add', lambda { |o|
  o[:result].push 5
}


describe 'hooks' do

  it 'runs hooks in defined order' do
    o = {:result=>[]}
    TH.run('add', o)
    o[:result].should.equal [1,2,3,4,5]
  end

end # -- === end desc

