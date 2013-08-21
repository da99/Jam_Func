require 'Bacon_Colored'
require("Jam_Func")

T     = Jam_Func.new
One   = Jam_Func.new
Two   = Jam_Func.new
Third = Jam_Func.new

T.on('add', lambda { |o| o.result.push 1})
T.on('add', lambda { |o| o.result.push 2})
T.on('mult', 'div', lambda { |o| o[:result].push "mult or div" })


# -- .RUN ------------------------------------------------
describe '.run' do

  it "runs funcs in order added" do
    j = Jam_Func.new
    o = []
    j.on 'add', lambda { o.push 1 }
    j.on 'add', lambda { o.push 2 }
    j.on 'add', lambda { o.push 3 }
    j.run 'add'
    o.should.be.equal [1,2,3]
  end

  it "returns value of data.val" do
    j = Jam_Func.new
    o = []
    j.on 'add', lambda { |d,last,j| j.val(1) }
    j.on 'add', lambda { |d,last,j| j.val(2) }
    j.on 'add', lambda { |d,last,j| j.val(3) }

    j.run('add').should.be.same_as 3
  end

  it 'runs on multi-defined events' do
    T.run 'mult', {:result=>[]}, lambda { |o|
      o[:result].should.be.equal ["mult or div"]
    }

    T.run 'div', {:result=>[]}, lambda { |o|
      o[:result].should.be.equal ["mult or div"]
    }
  end

  it 'combines data objects into one object' do
    o = {};
    a = Jam_Func.new
    a.on 'one', lambda { |d|
      o.merge!(d).merge!({:two=>'b'})
    }

    a.on 'one', lambda { |d|
      o.merge!(d).merge!({:three=>'c'})
    }

    a.run 'one', {:zero => 0}, {:one => 1}

    o.should.be.equal({:zero=>0, :one=>1, :two=>'b', :three=>'c'})
  end

  it 'squeezes spaces in event names upon .on and .run' do
    T.on 'spaced    NAME', lambda { |f|
      f[:vals] = 1
    }

    o = {:vals=>nil}
    T.run('spaced          NAME', o)
    o.should.be.equal({:vals=>1})
  end

  it 'ignores capitalization of event name upon .on and .run' do
    j = Jam_Func.new
    j.on 'strange CAPS', lambda { |f|
      f[:vals].push 1
    }

    o = {:vals=>[]}
    j.run('STRANGE CApS', o)

    o.should.be.equal({:vals=>[1]})
  end

  it 'ignores surrounding spaces of event name upon .on and .run' do
    j = Jam_Func.new
    j.on '  non-trim NAME  ', lambda { |f|
      f[:vals].push 1
    }

    o = {:vals=>[]}
    j.run 'non-trim   NAME', o

    o.should.be.equal({:vals=>[1]})
  end

  it 'passes last value as second argument to callbacks' do
    last = nil
    j = Jam_Func.new
    j.on 'a', lambda { |f| 1 }
    j.on 'a', lambda { |f, l| last = l }
    j.run 'a'

    last.should.be.equal 1
  end

end # --  === end desc


describe ".run(func1, func2, ...)" do
  it 'runs functions in sequential order' do
    d = []
    One.run(
      lambda { |o| d.push 1 },
      lambda { |o| d.push 2 }
    )

    d.should.be.equal [1,2]
  end

end # -- describe --







