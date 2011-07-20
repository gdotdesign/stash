{Stash} = require "../Source/Stash.coffee"
Stash.version = 
  last: 0.05

exports["Require basic"] = (test) ->
  c = {}
  loader = new Stash c
  loader.define ['UnitB'], 'UnitA', 0
  test.strictEqual c.UnitA, undefined
  loader.define null, 'UnitB', 1
  test.strictEqual c.UnitA, 0
  test.strictEqual c.UnitB, 1
  test.done()

exports["Require string"] = (test) ->
  c = {}
  loader = new Stash c
  loader.define 'UnitB', 'UnitA', 0
  test.strictEqual c.UnitA, undefined
  loader.define null, 'UnitB',  1
  test.strictEqual c.UnitA, 0
  test.strictEqual c.UnitB, 1
  test.done()
  
exports["Require mutiple"] = (test) ->
  c = {}
  loader = new Stash c
  loader.define ['UnitB','UnitC'], 'UnitA', 0
  test.strictEqual c.UnitA, undefined
  loader.define null, 'UnitB', 1
  test.strictEqual c.UnitB, 1
  test.strictEqual c.UnitA, undefined
  loader.define null, 'UnitC', 2
  test.strictEqual c.UnitA, 0
  test.strictEqual c.UnitC, 2
  test.done()
  
exports["Require global"] = (test) ->
  c = {}
  loader = new Stash c
  loader.define '!Stash', 'Unit', 0
  test.strictEqual c.Unit, 0
  test.done()
  
exports["Require package (one level)"] = (test) ->
  c = {
    Package:
      subClass: 'class'
  }
  loader = new Stash c
  loader.define 'Package.subClass', 'Unit', 0
  test.strictEqual c.Unit, 0
  test.done()

exports["Require package (deep)"] = (test) ->
  c = 
    Package:
      subClass: 
        subSubClass: 'class'
  loader = new Stash c
  loader.define 'Package.subClass.subSubClass', 'Unit', 0
  test.strictEqual c.Unit, 0
  test.done()
  
exports["Require package global (one level)"] = (test) ->
  c = {}
  loader = new Stash c
  loader.define '!Stash.version', 'Unit', 0
  test.strictEqual c.Unit, 0
  test.done()

exports["Require package global (deep)"] = (test) ->
  c = {}
  loader = new Stash c
  loader.define '!Stash.version.last', 'Unit', 0
  test.strictEqual c.Unit, 0
  test.done()
  
exports["Require mixed"] = (test) ->
  c = {}
  loader = new Stash c
  loader.define ['!Stash','UnitB'], 'UnitA', 0
  test.strictEqual c.UnitA, undefined
  loader.define null, 'UnitB', 1
  test.strictEqual c.UnitA, 0
  test.strictEqual c.UnitB, 1
  test.done()
  
exports["Content value"] = (test) ->
  c = {}
  loader = new Stash c
  loader.define null, 'Unit', 0
  test.strictEqual c.Unit, 0
  test.done()

exports["Content Function"] = (test) ->
  c = {}
  loader = new Stash c
  content = ->
  loader.define null, 'Unit', -> content
  test.strictEqual c.Unit, content
  test.done() 

exports["Prefix basic"] = (test) ->
  c = {}
  loader = new Stash c, 'Stash'
  loader.define null, 'UnitA', 0
  test.strictEqual c.Stash.UnitA, 0
  test.done()
  
exports["Prefix require basic"] = (test) ->
  c = {}
  loader = new Stash c, 'Stash'
  loader.define ['UnitB'], 'UnitA', 0
  test.strictEqual c.Stash, undefined
  loader.define null, 'UnitB', 1
  test.strictEqual c.Stash.UnitA, 0
  test.strictEqual c.Stash.UnitB, 1
  test.done()
  
exports["Prefix require global"] = (test) ->
  c = {}
  loader = new Stash c, 'Stash'
  loader.define ['!Stash'], 'UnitA', 0
  test.strictEqual c.Stash.UnitA, 0
  test.done()
  
exports["Prefix require local whithout prefix"] = (test) ->
  c = 
    local: true
  loader = new Stash c, 'Stash'
  loader.define ['@local'], 'UnitA', 0
  test.strictEqual c.Stash.UnitA, 0
  test.done()
