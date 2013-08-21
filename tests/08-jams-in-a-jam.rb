require 'Bacon_Colored'
require("Jam_Func")

describe '.new(jam1, jam2)' do

  it 'prepends arguments in specified order to .includes' do
    t1 = Jam_Func.new
    t2 = Jam_Func.new
    t3 = Jam_Func.new(t1, t2)
    o={:v=>[]}
    t2.on('one', lambda { |o| o[:v].push 2})
    t1.on('one', lambda { |o| o[:v].push 1})
    t3.run('one', o)

    o[:v].should.be.equal [1,2]
  end

  it 'filters out duplicates among arguments in .includes' do
    o={:v=>[]}
    t1 = Jam_Func.new
    t1.on('one', lambda { |o| o[:v].push 1})
    t2 = Jam_Func.new(t1, t1, t1)
    t2.run('one', o)

    o[:v].should.be.equal [1]
  end

  it 'runs events in .includes of the .includes' do
    t1 = Jam_Func.new
    t1.on 'add', lambda { |f| f[:vals].push 1 }

    t2 = Jam_Func.new(t1)
    t2.on 'add', lambda { |f| f[:vals].push 2 }

    t3 = Jam_Func.new(t2)
    t3.on 'add', lambda { |f| f[:vals].push 3 }

    t4 = Jam_Func.new(t3)
    t4.on 'add', lambda { |f| f[:vals].push 4 }

    o = {:vals=>[]}
    t4.run('add', o)

    o.should.equal({:vals=>[1,2,3,4]})
  end

end #--  === end desc


