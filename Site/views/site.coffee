window.addEvent "domready", ->
  prettyPrint()
  scroll = new Fx.Scroll($("content"))
  $$("a[href^=#]").addEvent 'click', (e)->
    e.stop()
    name = @get('href')[1..]
    el = $$("a[name=#{name}]")[0]
    scroll.toElement(el).chain -> window.location.hash = "#"+name
