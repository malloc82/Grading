(mapc #'mk-group
      '(("Jeremiah, Lukacs" "Albert,Banuelos") ;; :lab4 10; :lab5 10; :lab8, bcd finished in lab, all done
        ("Cory, Cook" "Roman,Ruiz" "Corey,Lunt") ;; :lab4 7, no source & diagram; :lab5 8, missing timing
                                                 ;; :lab8 working, :lab9 working, lab10 working
        ("Douglas,Duncan" "Jessica,Brown") ;; :lab4 10; :lab5 10; 
        ("Edward,Munoz III" "Guillermo,Garcia Jr") ;; lab8 done
        ("Bryan,Johnson" "Taylor,Sanchez" "Diego,Bernal") ;;
        ("Johnny,Nguyen" "David,Smit" "Jonathan,Carranza") ;; lab8 done,
        ("Manuel,Del Rio" "Christina,Torres") ;; 
        ("Andrew,Davis" "Eugene,Chandler") ;; lab8 done
        ("Maurice,Njuguna" "Mac,Chou") ;; lab5 , no source & diagram; 
        ("Paul,Cummings" "Gustavo,Cruz") ;; lab5, incomplete source
        ("La,Van Doren Jr" "Darin,Truckenmiller") ;;
        ("Ran,Wei" "Muhammad,Ali") ;; 

        ("Viviane,Helmig" "Roman,Savilov" "Abigail,Farrier") ;; 
        ("Anthony,Phillips" "Theodore,Phillips II" "Aminul,Hasan") ;; 
        ("Evan,Casey" "Ngan,Do" "Kyle,Johnson");; 
        ("Michael,Shabsin" "Nikolay,Figurin") ;; 
        ("Lavern,Slusher Jr" "Michael,Korcha I" "Garrett,Albers") ;; 
        ("Jeffrey,Carter" "Henry,Gomez" "Dennis,Zamora") ;; 
        ("Bryan,Amann" "Sean,Finucane" "Peter,Diaz III") ;; 
        ("Ahmed,Kamel" "Dylan,Allbee" "Ryan,Stegmann") ;; 
        ("Kanika,Bhat" "Francisco,Ron" "Janettea,Rodriguez") ;;  :lab 8, working
        ("Carlos,Gomez Viramontes" "Ryan,Rady") ;; 
        ("Henry,Johnson" "Dillon,Li" "Michael,Schenk") ;; 
        ("Joey,Cantellano" "Abraham,Flores Jr"))) ;; 

(set-group-grade '("jeremiah" "albert")
                 '((:lab1 7) (:lab2 5) (:lab3 6) (:lab4 10) (:lab5 10) (:lab6 8))) ;; all done
(set-group-grade '("cory" "roman")
                 '((:lab1 6) (:lab2 6) (:lab3 7) (:lab4 7) (:lab5 8) (:lab6 8)))
(set-group-grade '("duncan" "jessica")
                 '((:lab1 10) (:lab2 7) (:lab3 9) (:lab5 10) (:lab6 9)))
(set-group-grade '("edward" "guillermo")
                 '((:lab1 6) (:lab2 7) (:lab3 4) (:lab4 10) (:lab5 10) (:lab6 10)))
(set-group-grade '("bryan" "taylor")
                 '((:lab1 6) (:lab2 8) (:lab3 6) (:lab4 10) (:lab5 10) ))
(set-group-grade '("johnny" "david")
                 '((:lab1 5) (:lab2 8) (:lab3 6) (:lab4 10) (:lab5 10) (:lab6 10)))
(set-group-grade '("manuel" "torres")
                 '((:lab1 6) (:lab2 4) (:lab3 5) (:lab4 8) (:lab5 10) (:lab6 7)))
(set-group-grade '("andrew" "eugene")
                 '((:lab1 7) (:lab2 7) (:lab3 6) (:lab4 10) (:lab5 10) (:lab6 10)))
(set-group-grade '("maurice" "chou")
                 '((:lab1 6) (:lab2 5) (:lab3 3) (:lab4 8) (:lab5 5) (:lab6 7)))
(set-group-grade '("paul" "Gustavo")
                 '((:lab1 5) (:lab2 4) (:lab3 3) (:lab4 10) (:lab5 9) (:lab6 7)))
(set-group-grade '("la" "darin")
                 '((:lab1 8) (:lab2 4) (:lab4 8) (:lab5 10)))
(set-group-grade '("ran" "ali")
                 '((:lab1 5) (:lab2 7) (:lab3 4) (:lab4 10) (:lab5 10) (:lab6 10)))

(set-grade '((:lab1 6)) :firstname "diego" :lastname "bernal")
(set-grade '((:lab1 8) (:lab2 4)) :firstname "abraham")

(set-group-grade '("viviane" "abigail")
                 '((:lab1 9) (:lab2 8) (:lab3 9) (:lab5 8) (:lab6 10))) ;; (:lab8 ) done (:lab9 ) done
(set-group-grade '("phillips" "hasan")
                 '((:lab1 10) (:lab2 10) (:lab3 6) (:lab5 8) (:lab6 8))) ;; (:lab8 ) done
(set-group-grade '("evan" "ngan")
                 '((:lab1 7) (:lab2 10) (:lab3 8) (:lab5 9) (:lab6 7)))
(set-group-grade '("michael" "nikolay")
                 '((:lab1 9) (:lab2 9) (:lab3 4) (:lab4 6) (:lab5 9) (:lab6 9))) ;; (:lab 8) done
                                       
(set-group-grade '("lavern" "michael")
                 '((:lab1 6) (:lab2 5) (:lab3 7) (:lab4 10) (:lab5 8) (:lab6 8)))
(set-group-grade '("jeffrey" "henry" "dennis")
                 '((:lab1 9) (:lab2 8) (:lab3 4) (:lab5 6) (:lab6 7))) ;; (:lab8 ) done, all?
(set-group-grade '("bryan" "sean")
                 '((:lab1 9) (:lab2 9) (:lab3 10) (:lab5 10) (:lab6 10))) ;; all done 
(set-group-grade '("ahmed" "dylan")
                 '((:lab1 10) (:lab2 8) (:lab3 5) (:lab4 8) (:lab5 10) (:lab6 10))) ;; (:lab8) done
(set-group-grade '("kanika" "ron")
                 '((:lab1 7) (:lab2 6) (:lab3 4) (:lab5 8) (:lab6 8))) ;; all done
(set-group-grade '("henry" "dillon")
                 '((:lab1 8) (:lab2 7) (:lab3 9) (:lab5 10) (:lab6 10)))
(set-group-grade '("joey" "abraham")
                 '((:lab5 8) (:lab6 10)))
(set-group-grade '("carlos" "ryan")
                 '((:lab1 8) (:lab2 7) (:lab3 4) (:lab5  10) (:lab6 10))) ;; (:lab8) done

(set-grade '((:lab1 8) (:lab2 7) (:lab3 4)) :firstname "Joey" :lastname "Cantellano")


;; --------------------------------------------------------------------------------------------


  (set-group-grade '("jeremiah" "albert")
                   '((:lab7 8) (:lab9 8)))
  (set-group-grade '("cory" "roman")
                   '((:lab7 6) (:lab8 10)))
  (set-group-grade '("duncan" "jessica")
                   '((:lab7 10) (:lab8 8) (:lab9 9)))
  (set-group-grade '("edward" "guillermo") ;; lab10 works + extra (5)
                   '((:lab7 10) (:lab8 10)  (:lab9 10)))
  (set-group-grade '("bryan" "taylor")
                   '((:lab7 10)))
  (set-group-grade '("johnny" "david") ;; lab9 works
                   '((:lab7 10) (:lab9 10)))
  (set-group-grade '("manuel" "torres") ;; lab9 works 
                   '((:lab7 6)))
  (set-group-grade '("andrew" "eugene")
                   '((:lab7 10) (:lab8 10) (:lab9 10) (:lab10 10))) ;; extra credit
  (set-group-grade '("maurice" "chou")
                   '((:lab7 8) (:lab8 8) (:lab9 10)))
  (set-group-grade '("paul" "Gustavo")
                   '((:lab7 8)))
  (set-group-grade '("la" "darin")
                   '((:lab3 7) (:lab6 8) (:lab7 10) (:lab8 10) (:lab9 10) (:lab10 10)))
  (set-group-grade '("ran" "ali")
                   '((:lab8 10) ))

  (set-group-grade '("viviane" "abigail") ;; all done
                   '((:lab7 10) (:lab8 10) (:lab9 10)))
  (set-group-grade '("phillips" "hasan")
                   '((:lab7 10) (:lab8 6) (:lab9 8) ))
  (set-group-grade '("evan" "ngan")
                   '((:lab7 10) ))
  (set-group-grade '("michael" "nikolay")
                   '( (:lab7 10) (:lab8 10) (:lab9 10) (:lab10 10)))
  (set-group-grade '("lavern" "michael")
                   '((:lab7 8)))
  (set-group-grade '("jeffrey" "henry")
                   '((:lab7 10) (:lab8 10)))
  (set-group-grade '("bryan" "sean")
                   '((:lab7 10) (:lab8 10) (:lab9 7)))
  (set-group-grade '("ahmed" "dylan")
                   '((:lab7 9) (:lab8 10) (:lab9 10)))
  (set-group-grade '("kanika" "ron")
                   '((:lab7 8) (:lab8 10) (:lab9 10) (:lab10 10)))
  (set-group-grade '("carlos" "ryan")
                   '((:lab7 10)))
  (set-group-grade '("henry" "dillon") ;; lab8 working
                   '((:lab7 10)))
  (set-group-grade '("joey" "abraham")
                   '((:lab7 10)))
;; lab4 missing: philips, lavern