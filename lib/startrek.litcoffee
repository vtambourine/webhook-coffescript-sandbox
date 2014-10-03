Startrek API
============

Синглтон для работы с [REST API Стартрека][1].

    Startrek = module.exports = {}

Вызовы ручек API подписываются OAuth-токеном. На данной момент используется отладочный токен, полученный вручную. Правильней использовать для запросов в Стартрек специального робота.

    token = ''
    sign = 'Authorization': "OAuth #{token}"

Модуь `superagent` позволяет писать http-запросы в лаконичной форме.

    request = require 'superagent'

Архитектура
-----------

[Структура API Стартрека][2] позволяет думать о каждом методе как о паре объект-действие. Объектом в этом смысле является ресурс, такой как тикет (`issue`) или очередь (`queue`), а действием — возможная операция с ним.

Таким образом, работа с API представляется в последовательном вызове пары методов — существительного или глагола. Метод-существительное создаст экземпляр ресурса, а метод-глагол сформирует правильный запрос и выполнит действие.

    class Resource
      constructor: (@object) ->


Методы
------

### Объекты

#### [Тикет](https://wiki.yandex-team.ru/tracker/api#rabotastiketami)

Предоставляет экземпляр тикета.
`id` — идентификатор тикета в Стартреке.

    Startrek.issue = (id) ->
      new Resource "/v2/issues/#{id}"

### Действия

#### Вокрфлоу

##### [Получение доступных шагов](https://wiki.yandex-team.ru/tracker/api/issues/transitions-list)

Возвращает список доступных шагов тикета.

    Resource::getTransitions = (callback) ->
      request.get "#{@object}/transitions"
        .set sign
        .end callback

##### [Выполнение выбранного шага](https://wiki.yandex-team.ru/tracker/api/issues/transitions-execute)

Переводит тикет на указанный шаг.

    Resource::doTransition = (transition, callback) ->
      request.post "#{@object}/transitions/#{transition}/_execute"
        .set sign
        .end callback

    Resource::startReview = (callback) ->
      @doTransition 'review', callback

    Resource::commit = (callback) ->
      @doTransition 'commit', callback

#### Связи со сторонними сервисами

##### [Создание свази](https://wiki.yandex-team.ru/tracker/api/issues/link)

Создает связь с объектом в другом сервисе.

    Resource::link = (link, callback) ->
      request 'LINK', "#{@object}"
        .set 'Link': "<#{link}>; rel=\"relates\""
        .set sign
        .end callback

##### [Удаление связи](https://wiki.yandex-team.ru/tracker/api/issues/unlink)

Удаляет связь с объектом в другом сервисе.

    Resource::unlink = (link, callback) ->
      request 'UNLINK', "#{@object}"
        .set 'Link': "<#{link}>; rel=\"relates\""
        .set sign
        .end callback



[1]: https://wiki.yandex-team.ru/tracker/api
[2]: https://wiki.yandex-team.ru/tracker/api#struktura 
