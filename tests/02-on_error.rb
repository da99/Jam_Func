
require 'Bacon_Colored'
require "Jam_Func"

module ONERROR
  One = Jam_Func.new
  Ho  = Jam_Func.new

  One.on_error 'not_found', lambda { |o, err|
    o[:result].push err
  }

  One.on 'raise not_found', lambda { |o, last, jam|
    jam.error('not_found', 1)
  }

  One.on 'raise made up error', lambda { |o, last, jam|
    jam.error('made up error', "rand val")
  }
end # === module

describe 'error handling' do

  it 'runs error handler' do
    o = {:result=>[]}
    ONERROR::One.run('raise not_found', o)
    o.should.equal({:result=>[1]})
  end

  it 'raises error if no error handlers found' do
    lambda { ONERROR::One.run('raise made up error') }.
    should.raise(RuntimeError).

    message.
    should.match(/No error handler found for: MADE UP ERROR\s+: rand val/)
  end

end # -- === end desc
