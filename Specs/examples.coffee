{Stash} = require "../Source/Stash.coffee"

verbose = true

exports["Basic: myOtherProperty"] = (test) ->
  c = {myProperty: 'hello'}
  loader = new Stash {context:c, verbose:verbose}
  loader.define 'myProperty', 'myOtherProperty', 'Hey There!'
  test.strictEqual c.myOtherProperty, 'Hey There!'
  test.done()
  
exports["Basic: Stuff.Things.Small.trinket"] = (test) ->
  c = {}
  loader = new Stash {context:c, verbose:verbose}
  loader.define 'Stuff.Things.Small.trinket', 'Yey!'
  test.strictEqual c.Stuff.Things.Small.trinket, 'Yey!'
  test.done()
  
exports["Basic: Hello Jhon!"] = (test) ->
  c = {}
  loader = new Stash {context:c, verbose:verbose}
  loader.define 'greetings', 'Hello '
  loader.define 'greetings', 'person', ->
    @greetings+"Jhon!"
  test.strictEqual c.person, 'Hello Jhon!'
  test.done()
  
exports["Basic: Hello Jhon!(reversed)"] = (test) ->
  c = {}
  loader = new Stash {context:c, verbose:verbose}
  loader.define 'greetings', 'person', ->
    @greetings+"Jhon!"
  loader.define 'greetings', 'Hello '
  test.strictEqual c.person, 'Hello Jhon!'
  test.done()

exports["Basic: TheThing"] = (test) ->
  c = {}
  loader = new Stash {context:c, verbose:verbose}
  loader.define (!window? and exports?), 'TheThing', 'Is Big!'
  if !window? and exports?
    test.strictEqual c.TheThing, 'Is Big!'
  test.done()
  
exports["Basic: Warning"] = (test) ->
  glob =
    Warning: (message)->
      console.log (msg = "Warning: #{message} !")
      msg
  myobj = {
    warn: true
  }
  stash = new Stash {context:myobj, global: glob}
  stash.define ['!Warning','warn'], 'Alert', ->
    (message) =>
      if @warn
        glob.Warning message
  test.strictEqual myobj.Alert('Hey'), 'Warning: Hey !'
  test.done()

exports["Basic: ^ Element monkey patch"] = (test) ->
  if window?
    c = window
  else
    c =
      Element:
        implement: (obj)->
          for key, value of obj
            @[key] = value
  loader = new Stash {context:c, verbose:verbose}
  loader.define 'Element', '^ Element monkey patch', ->
    @Element.implement
      opaque: ->
        @setStyle 'opacity', 0
  test.ok typeof c.Element['opaque'] if 'function'
  test.done()  
  
exports["Basic: ^ Element monkey patch"] = (test) ->  
  stash = new Stash {prefix: 'Lattice'}
  stash.define "Core.Abstract", "Buttons.Abstract", ->
    class Buttons.Abstract extend @Core.Abstract
  stash.define "Core.Abstract", ->
    class Core.Abstract
  
