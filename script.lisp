(mapc #'mk-group
      '(("Jeremiah, Lukacs" "Albert,Banuelos") ;; :lab4 10; :lab5 10; :lab8, bcd finished in lab
        ("Cory, Cook" "Roman,Ruiz" "Corey,Lunt") ;; :lab4 7, no source & diagram; :lab5 8, missing timing
        ("Douglas,Duncan" "Jessica,Brown") ;; :lab4 10; :lab5 10; 
        ("Edward,Munoz III" "Guillermo,Garcia Jr") ;; 
        ("Bryan,Johnson" "Taylor,Sanchez" "Diego,Bernal") ;;
        ("Johnny,Nguyen" "David,Smit" "Jonathan,Carranza") ;; 
        ("Manuel,Del Rio" "Christina,Torres") ;; 
        ("Andrew,Davis" "Eugene,Chandler") ;; 
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
        ("Kanika,Bhat" "Francisco,Ron" "Janette,Rodriguez") ;;  :lab 8, working
        ("Carlos,Gomez Viramontes" "Ryan,Rady") ;; 
        ("Henry,Johnson" "Dillon,Li" "Michael,Schenk") ;; 
        ("Joey,Cantellano" "Abraham,Flores Jr"))) ;; 

(set-group-grade '((:lab1 7) (:lab4 10) (:lab5 10))
                 '("jeremiah" "albert"))
(set-group-grade '((:lab1 6) (:lab4 7) (:lab5 8))
                 '("cory" "roman"))
(set-group-grade '((:lab4 10) (:lab5 10))
                 '("duncan" "jessica"))
(set-group-grade '((:lab1 6) (:lab4 10) (:lab5 10))
                 '("edward" "guillermo"))
(set-group-grade '((:lab1 6) (:lab4 10) (:lab5 10) )
                 '("bryan" "taylor"))
(set-group-grade '((:lab1 5) (:lab4 10) (:lab5 10))
                 '("johnny" "david"))
(set-group-grade '((:lab1 6) (:lab4 8) (:lab5 10))
                 '("manuel" "torres"))
(set-group-grade '((:lab1 7) (:lab4 10) (:lab5 10))
                 '("andrew" "eugene"))
(set-group-grade '((:lab1 6) (:lab4 8) (:lab5 5))
                 '("maurice" "chou"))
(set-group-grade '((:lab1 5) (:lab4 10) (:lab5 9))
                 '("paul" "Gustavo"))
(set-group-grade '((:lab1 8) (:lab4 8) (:lab5 10))
                 '("la" "darin"))
(set-group-grade '((:lab1 5) (:lab4 10) (:lab5 10) )
                 '("ran" "ali"))

(set-grade '((:lab1 6))
           :firstname "diego" :lastname "bernal")
(set-grade '((:lab1 8))
           :firstname "abraham")



(set-group-grade '((:lab5 8) (:lab6 10))
                 '("viviane" "roman"))
(set-group-grade '((:lab5 8)  (:lab5 8))
                 '("phillips" "hasan"))
(set-group-grade '((:lab6 7)  (:lab5 9))
                 '("evan" "ngan"))
(set-group-grade '((:lab4 6) (:lab5 5) (:lab6 6))
                 '("michael" "nikolay"))
(set-group-grade '((:lab5 8) (:lab6 8))
                 '("lavern" "michael"))
(set-group-grade '((:lab5 6) (:lab6 7))
                 '("jeffrey" "henry"))
(set-group-grade '((:lab5 10) (:lab6 10))
                 '("bryan" "sean"))
(set-group-grade '((:lab4 8) (:lab5 10) (:lab6 10))
                 '("ahmed" "dylan"))
(set-group-grade '((:lab5 8) (:lab6 8))
                 '("kanika" "ron"))
(set-group-grade '((:lab5  10) (:lab6 10))
                 '("carlos" "ryan"))
(set-group-grade '((:lab5 10) (:lab6 10))
                 '("henry" "dillon"))
(set-group-grade '((:lab5 8) (:lab6 10))
                 '("joey" "abraham"))
