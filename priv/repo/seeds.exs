alias IdkPay.Repo
alias IdkPay.Account.User

  Repo.insert! %User{
    fullname: "Joe Admin",
    username: "administrator",
    password_hash: "$2b$12$8As.fIX4fQsbZuhcIhKr7OU3fqxaaPsfYuFZ/S6fUEDd2HDkzN.Tu",
    avatar: "/images/default.png",
    role: "administrator"    
  }