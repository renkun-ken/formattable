# formatters

    Code
      x <- c(0.1, 0.2, 0.3)
      f <- color_tile("white", "pink")
      writeLines(f(0.1))
    Output
      <span style="display: block; padding: 0 4px; border-radius: 4px; background-color: #ffc0cb">0.1</span>
    Code
      writeLines(f(x))
    Output
      <span style="display: block; padding: 0 4px; border-radius: 4px; background-color: #ffffff">0.1</span>
      <span style="display: block; padding: 0 4px; border-radius: 4px; background-color: #ffdfe5">0.2</span>
      <span style="display: block; padding: 0 4px; border-radius: 4px; background-color: #ffc0cb">0.3</span>
    Code
      writeLines(f(percent(x)))
    Condition
      Warning:
      `signal_superseded()` was deprecated in lifecycle 1.1.0.
      i Please use `signal_stage()` instead.
    Output
      <span style="display: block; padding: 0 4px; border-radius: 4px; background-color: #ffffff">10.00%</span>
      <span style="display: block; padding: 0 4px; border-radius: 4px; background-color: #ffdfe5">20.00%</span>
      <span style="display: block; padding: 0 4px; border-radius: 4px; background-color: #ffc0cb">30.00%</span>

