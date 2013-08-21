
require 'Bacon_Colored'
require "Jam_Func"

module MULTI_RUN
  One   = Jam_Func.new
  Two   = Jam_Func.new
  Third = Jam_Func.new

  One.on 'one', lambda { |o|
    o[:l].push 1
  }

  One.on 'two', lambda { |o|
    o[:l].push 2
  }

  One.on 'after two', lambda { |o|
    o[:l].push 3
  }
end # === module

describe 'multi run' do

  it 'runs functions in sequential order' do
    o = {:l=>[]};
    MULTI_RUN::One.run('one', 'two', o)
    o[:l].should.equal [1,2,3]
  end

  it 'runs last callback at end' do
    o = {:l=>[]}
    MULTI_RUN::One.run('one', 'two', o, lambda { |o|
      o[:l].push '4'
    })

    o[:l].should.equal [1,2,3,'4']
  end

end # -- === end desc
