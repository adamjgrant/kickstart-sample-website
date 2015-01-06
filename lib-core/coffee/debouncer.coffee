debounce = (fn, id, delay) ->

  $delay = delay || 1000

  k$.debounceQueue = id if k$.debounceQueue == null
  clearTimeout k$.debounceTimer if id == k$.debounceQueue
  k$.debounceTimer = setTimeout ->
    fn()
    k$.debounceQueue = null
  , $delay

k$.debounce = debounce

module.exports = debounce
