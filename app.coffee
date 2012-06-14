$ ->
  afterLogIn = =>
    form = $("<form>")
    textarea = $("<textarea cols=\"80\" rows=\"8\">")
    link = $("<input type=\"text\">")
    submit = $("<input type=\"submit\">")
    form.append("Link:")
    form.append(link)
    form.append("<br>")
    form.append("Tekst:")
    form.append(textarea)
    form.append("<br>")
    form.append(submit)
    $("body").append(form)
    form.submit((e) =>
      e.preventDefault()
      form.detach()
      postOnWalls(link.val(), textarea.val())
    )

  postOnWalls = (link, text) ->
    FB.api("/me/accounts", (response) =>
      wallsToPerform = response.data
      for wall in wallsToPerform
        do (wall) ->
          postOnWall(link, text, wall)
    )

  postOnWall = (link, text, wall) =>
    FB.api("/#{wall.id}/feed", 'post',
      message: text
      link: link
      access_token: wall.access_token
    , (response) =>
      console.log(response)
      $("body").append("posted on: #{wall.name}")
    )

  logIn = =>
    FB.login(afterLogIn, scope: "publish_stream,manage_pages")

  showLogInButton = =>
    button = $("<a href=\"#\">Log in</a>")
    button.click((e) =>
      e.preventDefault()
      logIn()
      button.hide()
    )
    $("body").append(button)

  FB.init(
    appId: 'appIdFromAdminPanel'
    status: true
    cookie: true
  )

  FB.getLoginStatus((response) =>
    if response.status != "connected"
      showLogInButton()
    else
      afterLogIn()
  )
