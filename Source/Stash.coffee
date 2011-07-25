class Stash
  constructor: (context,prefix = "",verbose = false) ->
    @$global = if window? then window else exports
    @$units = {}
    @$context = context
    @$stash = []
    @$prefix = prefix
    @verbose = verbose
    if prefix isnt "" and typeof @$prefix is 'string'
      @$prefix += "."
    @
  define: (requires=[],name,obj) ->
    if not (m = name.match /^\^/ )
      name = @$prefix+name
    switch typeof requires
      when "string"
        requires = [requires]
    @$units[name] =
      content: obj
      requires: requires
    if @check name
      @load name
    else
      if @verbose
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
        if not context[req]?
          return false
      else
        last = context
        for segment in path
          if last[segment]?
            last = last[segment]
          else
            return false
        if not last[end]?
          return false
    true
  load: (name) ->
    if @check name
      if name.match /^\^/
        if @verbose
          console.log "Running:", name
        @$units[name].content.call @$contex
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
            if not @$context[segment]?  
              @$context[segment] = {}
              last = @$context[segment]
        if @verbose
          console.log "Loading:", name
        switch typeof @$units[name].content
          when 'function'
            last[end] = @$units[name].content.call @$context
          else
            last[end] = @$units[name].content
      @checkStash()
if window?
  window.Stash = Stash
if exports?
  exports.Stash = Stash
