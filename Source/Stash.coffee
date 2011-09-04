# test for array
typeOf = (obj) ->
  if typeof obj isnt 'object' or obj is null or obj is undefined
    return typeof obj
  if obj.length
    return 'array'
  else
    return 'object'
      
class Stash
  constructor: (options) ->
    # Setting up options
    options = options || {}
    if (a = options.context)?
      if typeof a is 'object'
        context = a
    if ( b = options.prefix)?
      if typeof b is 'string'
        prefix = b
    if (c = options.global)?
      if typeof c is 'object'
        glob = c
    
    @$context = context or ( if window? then window else exports )
    @$prefix = prefix or ''
    @$verbose = if typeof (d=options.verbose) is 'boolean' then d else true
    @$autoLoad = if typeof (e=options.autoLoad) is 'boolean' then e else true
    
    # instance variables
    @$global = glob or ( if window? then window else exports )
    @$units = {}
    @$stash = []
    if @$prefix isnt ""
      @$prefix += "."
    @
    
  define: () ->
    # support for define 'Something', true instead of define null, 'Something', true
    if arguments.length is 2
      name = arguments[0]
      obj = arguments[1]
    if arguments.length is 3
      requires = arguments[0]
      name = arguments[1]
      obj = arguments[2]


    # check for function running prefix
    if not (m = name.match /^\^/ )
      name = @$prefix+name
    
    # arrayize
    unless typeOf(requires) is 'array'
      requires = [requires]

    # create the stash object  
    @$units[name] =
      content: obj
      requires: requires

    stash = true
    if @$autoLoad 
      if @check name
        @load name    
        stash = false
    if stash  
      if @$verbose
        console.log "Stashing:", name
      @$stash[name] = @$units[name]
      
      
  checkStash: ->
    load = (unit,name) ->
      if @check name
        delete @$stash[name]
        @load name
    if MooTools?
      Object.each @$stash, load, @
    else
      for name,unit of @$stash
        load.call @, unit,name
        
  check: (name) ->
    for req in @$units[name].requires
      if req?
        if typeof req is 'boolean'
          return req
        if req.match /^!/ 
          context = @$global
          req = req[1..]
        else
          context = @$context
          if req.match /^@/
            req = req[1..]
          else
            if @$prefix isnt ""
              req = @$prefix+req
        path = req.split /\./
        end = path.pop()
        if path.length is 0
          if context[req] is undefined
            return false
        else
          last = context
          for segment in path
            if last[segment]?
              last = last[segment]
            else
              return false
          if last[end] is undefined
            return false
    true
  loadWithDependencies: (name) ->
    if @$stash[name]
      for req in @$units[name].requires
        if req?
          if typeof req is 'boolean' 
            if req is false
              return null
          if typeof req is 'string' 
            @loadWithDependencies req
      @load name, false
  load: (name, checkStash = true) ->
    if @check name
      if name.match /^\^/
        if @$verbose
          console.log "Running:", name
        @$units[name].content.call @$context
      else
        path = name.split /\./
        end = path.pop()
        last = @$context
        for segment in path
          if last?
            if not last[segment]
              last[segment] = {}
            last = last[segment]
          else
            if @$context[segment] is undefined
              @$context[segment] = {}
              last = @$context[segment]
        if @$verbose
          console.log "Loading:", name
        switch typeof @$units[name].content
          when 'function'
            last[end] = @$units[name].content.call @$context
          else
            last[end] = @$units[name].content
      if checkStash
        @checkStash()
context = if window? then window else exports
context.Stash = Stash
context.stash = new Stash
context.define = context.stash.define
