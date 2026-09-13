# formattable.numeric: formatting

    Code
      format(obj)
    Output
       [1] "-1.21" "1.69"  "0.59"  "0.96"  "-0.57" "1.55"  "-0.57" "-1.05" "1.05" 
      [10] "1.73" 
    Code
      format(c(obj, 0.1))
    Output
       [1] "-1.21" "1.69"  "0.59"  "0.96"  "-0.57" "1.55"  "-0.57" "-1.05" "1.05" 
      [10] "1.73"  "0.10" 

# formattable.data.frame

    Code
      df <- data.frame(id = integer(), name = character(), value = numeric())
      format_table(formattable(df, list(value = color_tile("red", "blue"))))
    Output
      <table class="table table-condensed">
       <thead>
        <tr>
         <th style="text-align:right;"> id </th>
         <th style="text-align:right;"> name </th>
         <th style="text-align:right;"> value </th>
        </tr>
       </thead>
      <tbody>
        <tr>
      
        </tr>
      </tbody>
      </table>
    Code
      df <- data.frame(a = rnorm(10, 0.1), b = rnorm(10, 0.1), c = rnorm(10, 0.1))
      format_table(df, list(~percent))
    Condition
      Warning:
      `signal_superseded()` was deprecated in lifecycle 1.1.0.
      i Please use `signal_stage()` instead.
    Output
      <table class="table table-condensed">
       <thead>
        <tr>
         <th style="text-align:right;"> a </th>
         <th style="text-align:right;"> b </th>
         <th style="text-align:right;"> c </th>
        </tr>
       </thead>
      <tbody>
        <tr>
         <td style="text-align:right;"> -111.02% </td>
         <td style="text-align:right;"> 19.09% </td>
         <td style="text-align:right;"> 168.43% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 178.72% </td>
         <td style="text-align:right;"> -25.12% </td>
         <td style="text-align:right;"> -86.72% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 68.66% </td>
         <td style="text-align:right;"> -9.85% </td>
         <td style="text-align:right;"> -46.25% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 105.79% </td>
         <td style="text-align:right;"> 47.78% </td>
         <td style="text-align:right;"> 183.50% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -46.75% </td>
         <td style="text-align:right;"> 43.88% </td>
         <td style="text-align:right;"> 100.72% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 165.38% </td>
         <td style="text-align:right;"> -17.72% </td>
         <td style="text-align:right;"> -47.16% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -47.04% </td>
         <td style="text-align:right;"> 8.38% </td>
         <td style="text-align:right;"> -35.46% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -94.98% </td>
         <td style="text-align:right;"> 56.21% </td>
         <td style="text-align:right;"> 6.58% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 115.07% </td>
         <td style="text-align:right;"> -94.75% </td>
         <td style="text-align:right;"> -3.13% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 183.30% </td>
         <td style="text-align:right;"> 66.07% </td>
         <td style="text-align:right;"> -43.15% </td>
        </tr>
      </tbody>
      </table>
    Code
      format_table(df, list(b = formatter("span", style = ~ style(color = ifelse(a >=
        mean(a), "red", "green")))))
    Output
      <table class="table table-condensed">
       <thead>
        <tr>
         <th style="text-align:right;"> a </th>
         <th style="text-align:right;"> b </th>
         <th style="text-align:right;"> c </th>
        </tr>
       </thead>
      <tbody>
        <tr>
         <td style="text-align:right;"> -1.1102392 </td>
         <td style="text-align:right;"> <span style="color: green">0.19086862</span> </td>
         <td style="text-align:right;"> 1.68430541 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 1.7872136 </td>
         <td style="text-align:right;"> <span style="color: red">-0.25124218</span> </td>
         <td style="text-align:right;"> -0.86719369 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 0.6865856 </td>
         <td style="text-align:right;"> <span style="color: red">-0.09850694</span> </td>
         <td style="text-align:right;"> -0.46245348 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 1.0578816 </td>
         <td style="text-align:right;"> <span style="color: red">0.47778840</span> </td>
         <td style="text-align:right;"> 1.83500905 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -0.4674892 </td>
         <td style="text-align:right;"> <span style="color: green">0.43880084</span> </td>
         <td style="text-align:right;"> 1.00716539 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 1.6538145 </td>
         <td style="text-align:right;"> <span style="color: red">-0.17718045</span> </td>
         <td style="text-align:right;"> -0.47160862 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -0.4704075 </td>
         <td style="text-align:right;"> <span style="color: green">0.08377234</span> </td>
         <td style="text-align:right;"> -0.35463600 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -0.9498399 </td>
         <td style="text-align:right;"> <span style="color: green">0.56213624</span> </td>
         <td style="text-align:right;"> 0.06575976 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 1.1507057 </td>
         <td style="text-align:right;"> <span style="color: red">-0.94747097</span> </td>
         <td style="text-align:right;"> -0.03132490 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 1.8329852 </td>
         <td style="text-align:right;"> <span style="color: red">0.66067170</span> </td>
         <td style="text-align:right;"> -0.43153335 </td>
        </tr>
      </tbody>
      </table>
    Code
      format_table(df, list(a = FALSE))
    Output
      <table class="table table-condensed">
       <thead>
        <tr>
         <th style="text-align:right;"> b </th>
         <th style="text-align:right;"> c </th>
        </tr>
       </thead>
      <tbody>
        <tr>
         <td style="text-align:right;"> 0.19086862 </td>
         <td style="text-align:right;"> 1.68430541 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -0.25124218 </td>
         <td style="text-align:right;"> -0.86719369 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -0.09850694 </td>
         <td style="text-align:right;"> -0.46245348 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 0.47778840 </td>
         <td style="text-align:right;"> 1.83500905 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 0.43880084 </td>
         <td style="text-align:right;"> 1.00716539 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -0.17718045 </td>
         <td style="text-align:right;"> -0.47160862 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 0.08377234 </td>
         <td style="text-align:right;"> -0.35463600 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 0.56213624 </td>
         <td style="text-align:right;"> 0.06575976 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -0.94747097 </td>
         <td style="text-align:right;"> -0.03132490 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 0.66067170 </td>
         <td style="text-align:right;"> -0.43153335 </td>
        </tr>
      </tbody>
      </table>
    Code
      df <- data.frame(a = rnorm(10, 0.1), b = rnorm(10, 0.1), c = rnorm(10, 0.1))
      format_table(df, list(area(col = c("a", "b")) ~ percent))
    Condition
      Warning:
      `signal_superseded()` was deprecated in lifecycle 1.1.0.
      i Please use `signal_stage()` instead.
    Output
      <table class="table table-condensed">
       <thead>
        <tr>
         <th style="text-align:right;"> a </th>
         <th style="text-align:right;"> b </th>
         <th style="text-align:right;"> c </th>
        </tr>
       </thead>
      <tbody>
        <tr>
         <td style="text-align:right;"> 8.51% </td>
         <td style="text-align:right;"> -89.33% </td>
         <td style="text-align:right;"> 0.085522411 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -7.62% </td>
         <td style="text-align:right;"> 43.50% </td>
         <td style="text-align:right;"> -0.485648020 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -63.61% </td>
         <td style="text-align:right;"> 149.55% </td>
         <td style="text-align:right;"> -0.004124837 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 218.52% </td>
         <td style="text-align:right;"> 91.93% </td>
         <td style="text-align:right;"> 1.087532388 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 100.06% </td>
         <td style="text-align:right;"> -48.44% </td>
         <td style="text-align:right;"> 0.704724949 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -127.58% </td>
         <td style="text-align:right;"> -245.49% </td>
         <td style="text-align:right;"> 0.222743420 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -30.18% </td>
         <td style="text-align:right;"> -81.94% </td>
         <td style="text-align:right;"> -0.605565694 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -9.54% </td>
         <td style="text-align:right;"> 199.98% </td>
         <td style="text-align:right;"> 0.930465170 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -49.56% </td>
         <td style="text-align:right;"> 52.37% </td>
         <td style="text-align:right;"> 0.375936621 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 30.28% </td>
         <td style="text-align:right;"> -57.78% </td>
         <td style="text-align:right;"> -0.652086134 </td>
        </tr>
      </tbody>
      </table>
    Code
      format_table(df, list(area(col = b:c) ~ percent))
    Condition
      Warning:
      `signal_superseded()` was deprecated in lifecycle 1.1.0.
      i Please use `signal_stage()` instead.
    Output
      <table class="table table-condensed">
       <thead>
        <tr>
         <th style="text-align:right;"> a </th>
         <th style="text-align:right;"> b </th>
         <th style="text-align:right;"> c </th>
        </tr>
       </thead>
      <tbody>
        <tr>
         <td style="text-align:right;"> 0.08506515 </td>
         <td style="text-align:right;"> -89.33% </td>
         <td style="text-align:right;"> 8.55% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -0.07623893 </td>
         <td style="text-align:right;"> 43.50% </td>
         <td style="text-align:right;"> -48.56% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -0.63614640 </td>
         <td style="text-align:right;"> 149.55% </td>
         <td style="text-align:right;"> -0.41% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 2.18522667 </td>
         <td style="text-align:right;"> 91.93% </td>
         <td style="text-align:right;"> 108.75% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 1.00060697 </td>
         <td style="text-align:right;"> -48.44% </td>
         <td style="text-align:right;"> 70.47% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -1.27578862 </td>
         <td style="text-align:right;"> -245.49% </td>
         <td style="text-align:right;"> 22.27% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -0.30184491 </td>
         <td style="text-align:right;"> -81.94% </td>
         <td style="text-align:right;"> -60.56% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -0.09535104 </td>
         <td style="text-align:right;"> 199.98% </td>
         <td style="text-align:right;"> 93.05% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -0.49562439 </td>
         <td style="text-align:right;"> 52.37% </td>
         <td style="text-align:right;"> 37.59% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 0.30281946 </td>
         <td style="text-align:right;"> -57.78% </td>
         <td style="text-align:right;"> -65.21% </td>
        </tr>
      </tbody>
      </table>
    Code
      format_table(df, list(area(1:5) ~ percent))
    Condition
      Warning:
      `signal_superseded()` was deprecated in lifecycle 1.1.0.
      i Please use `signal_stage()` instead.
    Output
      <table class="table table-condensed">
       <thead>
        <tr>
         <th style="text-align:right;"> a </th>
         <th style="text-align:right;"> b </th>
         <th style="text-align:right;"> c </th>
        </tr>
       </thead>
      <tbody>
        <tr>
         <td style="text-align:right;"> 8.51% </td>
         <td style="text-align:right;"> -89.33% </td>
         <td style="text-align:right;"> 8.55% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -7.62% </td>
         <td style="text-align:right;"> 43.50% </td>
         <td style="text-align:right;"> -48.56% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -63.61% </td>
         <td style="text-align:right;"> 149.55% </td>
         <td style="text-align:right;"> -0.41% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 218.52% </td>
         <td style="text-align:right;"> 91.93% </td>
         <td style="text-align:right;"> 108.75% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 100.06% </td>
         <td style="text-align:right;"> -48.44% </td>
         <td style="text-align:right;"> 70.47% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -1.27578862 </td>
         <td style="text-align:right;"> -2.4549394 </td>
         <td style="text-align:right;"> 0.222743420 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -0.30184491 </td>
         <td style="text-align:right;"> -0.8193570 </td>
         <td style="text-align:right;"> -0.605565694 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -0.09535104 </td>
         <td style="text-align:right;"> 1.9998221 </td>
         <td style="text-align:right;"> 0.930465170 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -0.49562439 </td>
         <td style="text-align:right;"> 0.5237278 </td>
         <td style="text-align:right;"> 0.375936621 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 0.30281946 </td>
         <td style="text-align:right;"> -0.5777537 </td>
         <td style="text-align:right;"> -0.652086134 </td>
        </tr>
      </tbody>
      </table>
    Code
      format_table(df, list(area(1:5, b:c) ~ percent))
    Condition
      Warning:
      `signal_superseded()` was deprecated in lifecycle 1.1.0.
      i Please use `signal_stage()` instead.
    Output
      <table class="table table-condensed">
       <thead>
        <tr>
         <th style="text-align:right;"> a </th>
         <th style="text-align:right;"> b </th>
         <th style="text-align:right;"> c </th>
        </tr>
       </thead>
      <tbody>
        <tr>
         <td style="text-align:right;"> 0.08506515 </td>
         <td style="text-align:right;"> -89.33% </td>
         <td style="text-align:right;"> 8.55% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -0.07623893 </td>
         <td style="text-align:right;"> 43.50% </td>
         <td style="text-align:right;"> -48.56% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -0.63614640 </td>
         <td style="text-align:right;"> 149.55% </td>
         <td style="text-align:right;"> -0.41% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 2.18522667 </td>
         <td style="text-align:right;"> 91.93% </td>
         <td style="text-align:right;"> 108.75% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 1.00060697 </td>
         <td style="text-align:right;"> -48.44% </td>
         <td style="text-align:right;"> 70.47% </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -1.27578862 </td>
         <td style="text-align:right;"> -2.4549394 </td>
         <td style="text-align:right;"> 0.222743420 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -0.30184491 </td>
         <td style="text-align:right;"> -0.8193570 </td>
         <td style="text-align:right;"> -0.605565694 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -0.09535104 </td>
         <td style="text-align:right;"> 1.9998221 </td>
         <td style="text-align:right;"> 0.930465170 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> -0.49562439 </td>
         <td style="text-align:right;"> 0.5237278 </td>
         <td style="text-align:right;"> 0.375936621 </td>
        </tr>
        <tr>
         <td style="text-align:right;"> 0.30281946 </td>
         <td style="text-align:right;"> -0.5777537 </td>
         <td style="text-align:right;"> -0.652086134 </td>
        </tr>
      </tbody>
      </table>

