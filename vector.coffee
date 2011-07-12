define [
    './underscore'
], (_) ->

    class Vector
        constructor: (@components...) ->

        reduce: (initial, action) ->
            _.reduce @components, action, initial

        fmap: (action) ->
            new Vector (_.map @components, action)...

        vmap: (vector, action) ->
            new Vector (_.map _.zip(@components, vector.components), (components) -> action components...)...

        magnitude: ->
            Math.sqrt @reduce 0, (component, accumulator) -> accumulator + component*component

        scale: (factor) ->
            @fmap (component) -> component * factor

        invert: ->
            @scale -1

        add: (vector) ->
            @vmap vector, (c1, c2) -> c1 + c2
        
        subtract: (vector) ->
            @add(vector.invert())


    Vector::plus = Vector::add
    Vector::minus = Vector::subtract
