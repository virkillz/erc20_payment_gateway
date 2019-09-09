# IDKPay

IDKPay is a ERC20 payment gateway configured for IDK. Goal: To be used by other ERC20 by changing 1 line in config.

## TODO

  - [ ] invoice detail

  - [ ] wire up change password


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

### Screenshot


![Landing Page example](/screenshot/landing-page.png)

Landing page example

![Credential Generation](/screenshot/create-credential.png)

Create credential example

![Payment Page example](/screenshot/payment.png)

Payment Page example