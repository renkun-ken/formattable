{ pkgs ? import <nixpkgs> {}, displayrUtils }:

pkgs.rPackages.buildRPackage {
  name = "formattable";
  version = displayrUtils.extractRVersion (builtins.readFile ./DESCRIPTION); 
  src = ./.;
  description = ''Provides functions to create formattable vectors and data frames.
    'Formattable' vectors are printed with text formatting, and formattable
    data frames are printed with multiple types of formatting in HTML
    to improve the readability of data presented in tabular form rendered in
    web pages.'';
  propagatedBuildInputs = with pkgs.rPackages; [ 
    htmltools
    htmlwidgets
    knitr
    rmarkdown
 ];

}
