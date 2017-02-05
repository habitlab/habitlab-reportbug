require! {
  'koa'
  'koa-router'
  'koa-logger'
  'koa-bodyparser'
  'koa-jsonp'
  #'koa-static'
  'sendgrid'
}

kapp = koa()
kapp.use(koa-jsonp())
kapp.use(koa-logger())
kapp.use(koa-bodyparser())
app = koa-router()

helper = sendgrid.mail
getsecret = require('getsecret')
sg = sendgrid(getsecret('sendgrid_api_key'))
default_from_email = getsecret('from_email')
default_to_email = getsecret('to_email')

# based off https://github.com/habitlab/habitlab-website/blob/master/app.ls
app.get '/send_test_email', ->*
  this.type = 'json'
  from_email = new helper.Email(default_from_email)
  to_email = new helper.Email(default_to_email)
  subject = 'Hello World from the SendGrid Node.js Library!'
  img_data_base64 = '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'
  #var img_data = 'data:image/png;base64,'
  content = new helper.Content('text/html', 'See screenshot below')
  mail = new helper.Mail(from_email, subject, to_email, content)

  attachment = new helper.Attachment()
  attachment.setContent(img_data_base64)
  attachment.setType("image/png")
  attachment.setFilename("screenshot.png")
  attachment.setDisposition("inline")
  attachment.setContentId("screenshot")
  mail.addAttachment(attachment)

  request = sg.emptyRequest({
    method: 'POST',
    path: '/v3/mail/send',
    body: mail.toJSON(),
  })

  response = yield -> sg.API request, it
  this.body = JSON.stringify(response)

kapp.use(app.routes())
kapp.use(app.allowedMethods())
#kapp.use(koa-static(__dirname + '/www'))
port = process.env.PORT ? 5000
kapp.listen(port)
console.log "listening to port #{port} visit http://localhost:#{port}"