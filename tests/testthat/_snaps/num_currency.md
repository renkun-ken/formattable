# currency

    Code
      format(obj, symbol = "$")
    Output
      [1] "$-5,300.00" "$10,500.00" "$20,300.00" "$35,010.00"
    Code
      format(currency(data, symbol = "$", digits = 0))
    Output
      [1] "$-5,300" "$10,500" "$20,300" "$35,010"
    Code
      format(currency(obj, symbol = "$", digits = 0, big.mark = "/"))
    Output
      [1] "$-5/300" "$10/500" "$20/300" "$35/010"
    Code
      format(currency(1000, "USD", digits = 0, sep = " "))
    Output
      [1] "USD 1,000"
    Code
      format(currency("$ 123,234.50", symbol = "$", sep = " "))
    Output
      [1] "$ 123,234.50"

