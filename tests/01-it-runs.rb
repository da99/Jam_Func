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


lambda { # --- let's ignore these for now.
describe '.run .includes' do

  it 'prepends arguments in specified order to .includes' do
    t1 = Jam_Func.new

    t2 = Jam_Func.new

    t3 = Jam_Func.new(t1, t2)

    t3.includes[0].should.same_as t1
    t3.includes[1].should.same_as t2
  end

  it 'filters out duplicates among arguments in .includes' do
    t1 = Jam_Func.new
    t2 = Jam_Func.new(t1, t1, t1)

    t2.includes.size.should.same_as 2
  end

  it 'runs events in .includes' do
    t1 = Jam_Func.new
    t1.on 'one', lambda { |f| f[:vals].push 1 }
    t1.on 'two', lambda { |f| f[:vals].push 2 }

    t2 = Jam_Func.new(t1, t1, t1)
    t2.on 'one', lambda { |f| f[:vals].push 3 }
    t2.on 'two', lambda { |f| f[:vals].push 4 }

    o = {:vals=>[]}
    t2.run('one', 'two', o)
    o.should.equal({:vals=>[1,3,2,4]})
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
}






