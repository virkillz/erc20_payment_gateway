# IDKPay

IDKPay is a ERC20 payment gateway configured for IDK. Goal: To be used by other ERC20 by changing 1 line in config.


## TODO
  [ ] make the payment page dynamic, live view.
  [ ] credential detail
  [ ] invoice detail
  [ ] payment page
  [ ] wire up change password
  [ ] wire up delete account




## To start:

  * Install dependencies with `mix deps.get`
  * Check your database setting at `config/dev.exs` and match your postgresql credential
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Run seed `mix run priv/repo/seeds.exs` (if you are from asset folder, dont forget to back to root project folder `cd ..`)
  * Start Phoenix endpoint with `mix phx.server`

### For User
Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
You can register as a regular user.

### For Admin
You can visit [`localhost:4000/admin`](http://localhost:4000/admin) and login using username 'administrator' and passsword 'administrator'


## Use IdkPay Generator instead of phoenix!
You probably familiar using `phx.gen.html` like this:

`mix phx.gen.html Content Post post title:string content:string is_published:boolean`

Instead, you better use:

`mix idk_pay.gen.html Content Post post title:string content:string is_published:boolean`

The later one will give nicer html output.

Put `resources "/post", PostController` in the router `/lib/Yourapp_web/router.ex`

Run migration `mix ecto.migrate`

Add link to your menu at '/lib/Yourapp_web/templates/layout/app.html.eex'

Bam it's done!

