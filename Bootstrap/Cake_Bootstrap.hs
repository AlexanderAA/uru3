
module Cake_Bootstrap where

import Development.Cake3
import Development.Cake3.Ext.UrWeb
import Cake_Bootstrap_P

lib = do
  uwlib (file "lib.urp") $ do
    rewrite style "Bootstrap/bs3_table table"
    rewrite style "Bootstrap/* [-]"
    library' (externalMake (file "../Uru/lib.urp"))
    library' (externalMake (file "../JQuery/lib.urp"))
    bin (file "dist/fonts/glyphicons-halflings-regular.eot") []
    bin (file "dist/fonts/glyphicons-halflings-regular.svg") []
    bin (file "dist/fonts/glyphicons-halflings-regular.ttf") []
    bin (file "dist/fonts/glyphicons-halflings-regular.woff") []
    bin (file "dist/css/bootstrap.css") []
    bin (file "dist/css/bootstrap-theme.css") []
    bin (file "dist/js/bootstrap.min.js") [NoScan]
    ur (pair (file "Bootstrap.ur"))

demo1 useUrembed = do
  u <- lib
  uwapp "-dbms sqlite" (file "test/B1.urp") $ do
    rewrite style "B1/* [-]"
    library u
    ur (sys "list")
    bin (file "test/B1.css") useUrembed
    ur (pair (file "test/B1.ur"))

demo2 useUrembed = do
  u <- lib
  uwapp "-dbms sqlite" (file "test/B2.urp") $ do
    allow url "https://github.com/grwlf/*"
    allow url "https://camo.githubusercontent.com/*"
    rewrite style "B2/* [-]"
    library u
    ur (sys "list")
    bin (file "test/B2.css") useUrembed
    bin (file "test/holder.js") useUrembed
    ur (pair (file "test/B2.ur"))

mfiles f = do
  writeMake (file "Makefile.devel") (f [UseUrembed,NoScan])
  writeMake (file "Makefile") (f [NoScan])

main = do
  mfiles $ \useUrembed -> do
    u <- lib
    
    b1 <- demo1 useUrembed

    b2 <- demo2 useUrembed

    rule $ do
      phony "lib"
      depend u

    rule $ do
      phony "all"
      depend b1
      depend b2
