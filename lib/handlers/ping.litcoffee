Обработчик события Ping 
=======================

[Ping Event][1] вызывается в момент создания новой хуки. Это простое событие, полезное для отладки.

    module.exports = (event) ->
      console.log "GitHub says #{event.zen}"

[1]: https://developer.github.com/webhooks/#ping-event