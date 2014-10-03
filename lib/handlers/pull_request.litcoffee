Обработчик события PullRequest
==============================

[PullRequest Event][1] вызывается при открытии, закрытии и изменении пул-реквеста.

### Поля события

| Имя          | Тип     | Описание 
| ------------ | ------- | --- 
| `action`       | string  | Произошедшее действие. Возможные значения: “assigned”, “unassigned”, “labeled”, “unlabeled”, “opened”, “closed”, “reopened”, или “synchronize”.
| `number`       | integer | Номер пул-реквеста.
| `pull_request` | object  | Тело пул-реквеста.


Реакции на события
------------------

Обработчик синхронизирует состояние пул-реквеста с состоянием связанных с ним тикетов в Startrek. Связыванные с пул-реквестом тикеты определяются ключам, указынным в его заголовке. Например:

> BETAMAPS-1770 — Перекрасить логотип

    Startrek = require '../startrek'

    module.exports = (event) ->
      return if not event.pull_request
      title = event.pull_request.title
      action = event.action
      issues = title.match /[A-Z]+-\d+/

### Новый пул-реквест

Новые пул-реквесты связываем с соответствущим им тикетами.

      if action is 'opened' or action is 'reopened'
        for issue in issues
          Startrek.issue issue
            .link event.pull_request.html_url, (error) ->
              if error
                console.log error.body
              else
                console.log "Ticket #{issue} was linked with pull-request ##{event.number}"

### Закрытие пул-реквеста

При вливании пул-реквеста в ветку `dev` (закрытие пул-реквеста со статусом `merged`), переводим соответствущие ему тикеты в состояние `Commited`.

      if action is 'closed' and event.pull_request.merged
        for issue in issues
          Startrek.issue issue
            .commit (error) ->
              if error
                console.log error.body
              else
                console.log "Ticket #{link} was makred as commited"


[1]: https://developer.github.com/v3/activity/events/types/#pullrequestevent