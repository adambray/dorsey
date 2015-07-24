# HTTP From Scratch

## Starter

See server0.rb - server3.rb. Each file is self-documenting.

## Exercise

Starting with server3.rb, modify the app to add the following features:

- Visiting "GET /signup" responds with an HTML page with a form to add your email to a list.
- Visiting "POST /signup" adds the email address to the list (storing it as a global array is fine for now)
- Visiting "GET /attendees" returns a page listing all the signups

### Bonus

- Save attendees to a database or file.
- Write simple templating method(s) to add 'layout' functionality.

### Mega-Bonus

- Built a simple framework that lets you write code like sinatra.