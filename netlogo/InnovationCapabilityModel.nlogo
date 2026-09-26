globals
[
  ;; number of workers currently sensitized to innovation culture
  ;; harmony-duration = number of periods during which innovation culture remains active
  num-inn
]

breed [individualas individuala]  ;;  employee, worker
breed [individualbs individualb]  ;; executive

turtles-own [ w pw wa awa p c d sf s r emo  expend ladvantage IP dip dipe aladvantage sensitized?
  remaining-harmony ladvantage0 recoverye impacte impacte-d impacte-s impacte-r discounte timep-sf
  timep-c timep-d timep-s timep-r
];; Solo adicione el mensaje remaining-harmony = how many periods of harmony the turtle has left
;; DIP is closely related to Organizational Support.
;; Organizational Support represents the organizational condition,
;; while DIP operates at the individual level.
;; DIP represents the rate at which the worker's Innovation Profile changes.
;; per = temperament/personality parameter associated with the degree
;; to which the worker is willing to accept organizational influence. dipe = delta personality
;; accor = degree of satisfaction experienced by the worker,
;; associated with the level of innovation capability (Ladvantage) generated.
;; welfare = w; produce = p; cooperate = c; distractor = d; self cultivation = SF; selfish = s; wage-income=wa
;; relationship with the environment = r, emotional = emo, ladvantage = level of advaantage, aladvantage acumulated lavantage
;; awa = accumulated wage-income, IP = Innovative profile, IPb = Innovative profile individualbs, PIP = Projected innovative profile. DIP = Delta IP
;; IPa = Innovative profile individualas, pw = projected welfare, y las variables de la parte de abajo del modelo.
;; CICT = % collaborat. work suppor by ICT. Level of Autonomy = LA. team =  Takt hours of teamwork. YS = Years of seniority
;; EL = Educational level. ML = Motivational level. TG = Trainning grade. FE = Frequency of interaction with external entities
;; NN = Number of nodes in the contacts network. dl = Duration of the links in the contact network
;; Assimilation percentage = %a.
;; Represents the probability that a worker adopts innovation-oriented behaviors.

patches-own [ advantage ]  ;; Level of competitive advantage in which the worker is
;; Determines the level of organizational innovation capability represented by the patch
;; and influences the rewards associated with worker actions.
;; initial location of individuals
;; to stop si ladvantage es igual a 0 en todas las tortugas
to setup
  clear-all
  let my-seed 8
  set-default-shape individualas "person"
  set-default-shape individualbs "person business"
  create-individualas number-a [ setxy random-xcor random-ycor ]
  create-individualbs number-b [ setxy random-xcor random-ycor ]
  set num-inn 0
  ask turtles [  set sensitized? false ]
  ask turtles [ set ladvantage random-normal mean. sd ]  ;; initial distribution of individual ladvantage
  ask turtles [ set ladvantage0 ( ladvantage * 1 ) ]
  ask turtles [ set w random-normal (ladvantage * inn-culture) accor ];; depends on organizational culture and worker profile,
  ;; values near to -1 represent stronger innovation-oriented cultures
  ;;ask turtles [ set w random-normal ladvantage accor ]
  ask turtles [ set aladvantage 0] ;; initial accumulated innovation capability
  ask turtles [ set awa 0 ]  ;;  initial accumulated rewards received by the worker
  ask turtles [ set dip ( TPB + MT + TSL ) / 3 ] ;; falta incluir un cuarto termino que simboliza factores que se afectan desde más de una escuela. Esto se explica extensivamene en el texto.
  ask turtles [ set dipe random-normal dip per ]
  ask turtles [ set recoverye random-normal recovery per ]
  ask turtles [ set impacte random-normal impact per ]
  ask turtles [ set impacte-d random-normal impact-d per ]
  ask turtles [ set impacte-s random-normal impact-s per ]
  ask turtles [ set impacte-r random-normal impact-r per ]
  ask turtles [ set discounte random-normal discount per ]
  ask turtles [ set timep-sf random-normal time-sf per ]
  ask turtles [ set timep-c random-normal time-c per ]
  ask turtles [ set timep-d random-normal time-d per ]
  ask turtles [ set timep-s random-normal time-s per ]
  ask turtles [ set timep-r random-normal time-r per ]
  ;; ask turtles [ set w random-normal ladvantage per ]
ask turtles [ set IPa iIPa ]
  ask turtles [ set IPb iIPb ]
  work
  ask turtles [ create-links-with other turtles ]
  ;; set ladvantage = advantage
    ;; in order to define the areas of competitive SE's  advantage
  ask n-of n-colonize turtles [ get-inn ]
 ask patch -16 16 [ set advantage  number ]
  repeat rep [ diffuse advantage dif ]
  ask patches [ set pcolor scale-color green advantage 50 0 ]
  ;; ask patches [ set recovery 2 ] <== Hay que estableder por que tenia esto antes.
  ;; falta explicar que cada persona posee un potenciar para infliuenciar a otros
  check-setup ;; la idea es poder validar si ha quedado bien el inicio.
  reset-ticks
end

to colonize
  ask one-of turtles [ become-aligned ]
end

;; validar inicialmente podría ser: que los trabajadores no se encuentren en un área en la cual no puedan movilizarse.
;; Que se sepa cuantas personas están muy descachadas del nivel de ventaja competitiva que aporta de una manera que
;; no corresponde a la realidad. Que haya alguno de los valores fuera de rango, y bueno las que vayan saliendo.
to check-setup
end

to go
  ;; hace fata definirle el mecanismo para parar.
  ;; con with puedo diferenciar los individuos por caracteristicas por ejemplo: let fast-cars turtles with [speed > 0.5]
  ;; esto sirve cuando por ejemplo quiera diferenciar los agentes que han interactuado con el mecanismo de soporte
  ;; o cuando quiera ver los que si cooperan y se dejan ayudar por ejemplo. Obviamente se les puede asignar funciones
  ;; let fast-cars turtles with [speed > 0.5]
  ;; ask fast-cars [
  ;; set size 2.0
  ;; ]if all? turtles [xcor >= food-x]
   ;; [ stop ]
 if all? turtles [ladvantage <= 0]
  [stop]

  ask turtles
  [
       set ladvantage ladvantage + ( ( recoverye * timep-sf ) + ( impacte * timep-c ) + ( impacte-d * timep-d )
      + (impacte-s * timep-s) + (impacte-r * timep-r ) - ( discounte ));; recovery of ability to work for competitive advantage
    ;; impact * time-c It is the effect of cooperation. (impact-d * time-d) Activities that do not add value
    ifelse ladvantage >=  advantage ;; evaluar este signo
    [ downhill pcolor ]     ;; in order to go to the green zone
    [ uphill pcolor ]       ;; carried away by the current
    ;; gain-seniority
    if sensitized? [ deduct ]  ;; hasta aca validado, falta quedar sin cultura
   evolve ;; Compare current outcomes with outcomes that could have been obtained through alternative behavior and decisions
    work ;; executes the actions of the period
    deliver ;; deliver to SE
    receive ;; receive his/her payment-welfare
    recieve-new ;; receive your new level of capabilities
    update ;; update behavior
     ;; Evaluates the level of advantage of the turtle who hosts
  ]
  ask turtles with [ sensitized? ]
  [ spread-culture ]
   set num-inn count turtles with [ sensitized? ]
  my-update-histogram
  my-update-plot-p
  tick
end

to spread-culture
  ask other turtles in-radius radiu [ maybe-get-inn ] ;; toca con vecindario radio, ver modelo de segregación. Aca voy.
end

to maybe-get-inn
  if ( not sensitized? ) and ( random 100 < propagation-chance )
  [ get-inn ]
end

to get-inn
  if not sensitized?
  [ set sensitized? true
    set remaining-harmony 0
    set size 1.5]
end

to become-aligned ;;
  set sensitized? true
  set remaining-harmony harmony-duration ;; hace falta un proceso para volver a quedar sin cultura innovadora
  set size 1.5
end

to deduct
  set  remaining-harmony remaining-harmony - 1
  if remaining-harmony < 1
  [if random-float 100 < chance-relapse
  [
    (set sensitized? false )
      ( set size 5 )]
  ]
end

;;to gain-seniority
 ;; if sensitized? [ set remaining-harmony remaining-harmony - 1 ] ;; hasta aca validado, falta quedar sin cultura
;; if remaining-harmony < 1
;;[
 ;; (set sensitized? false )
   ;; ( set size 5 )
;; ]
;; end

to work
;; p + c + d + sf + s + r + ¿emo? = 1 ;; How you use time
  ;; Innovative profile (innovative culture) = IP . Innovative profile individualbs (innovative culture) = IPb
  ;; Innovative profile individualas (innovative culture) = IPa
  ;; DIP = f (TPB + MT + TSL) ;; Theory of Planned Behavior, Expectancy Theory and theory of social learning
  ;; IP debe jugarsela por los individuos, hay que establecer si es una nueva variable de IP o esta incluida en las de emprendimiento
  ;; Cumple pero se necesita algo que permita la maquina de ip no lo ponga a uno a sumar todo el tiempo.
  ;; set IP  ( CICT + LA + team + YS + EL + ML + TG + FE + NN + dl )
  ask individualas [
    ifelse IPa > 0.67 [  ;; IPa debe colocarse con rangos inicialmente, e idealmente como una funcion
      set time-p ( 1 - (  time-c + time-sf + time-r ) ) set time-d 0 set time-s 0 ]
    [ ifelse IPa >= 0.33  and IP <= 0.67 [
      set time-p ( 1 - ( time-c + time-sf + time-r + time-d + time-s )) ]
      [ set time-p ( 1 - ( time-d + time-s ) ) set time-c 0 set time-sf 0 set time-r 0 ]
    ]
  ]
   ask individualbs [
  ifelse IPb > 0.67[  ;; IPb debe colocarse con rangos inicialmente, e idealmente como una funcion
      set time-p ( 1 - (  time-c + time-sf + time-r ) ) set time-d 0 set time-s 0 ]
    [ ifelse IPb >= 0.33  and IP <= 0.67 [
      set time-p ( 1 - ( time-c + time-sf + time-r + time-d + time-s )) ]
      [ set time-p ( 1 - ( time-d + time-s ) ) set time-c 0 set time-sf 0 set time-r 0 ]
    ]
  ]
end

to deliver
  ;; delivery of results to the SE
  ;; Es entregar todo lo que hizo al patche, el patche acumula y entrega a la empresa el resultado
end


to receive ;; payment + welfare
    ;; welfare = w; produce = p; cooperate = c; distractor = d; self cultivation = SF; selfish = s;
;; relationship with the environment = r, emotional = emo
  ;; w = f ( p c d sf s r )
  ;; set w random-normal advantage accor
  set w random-normal (ladvantage * inn-culture) accor
  ;; esto necesrimente es con precios
  set wa ( p + c + d + sf + s + r + emo) ;; (time-c * impact ) * advantage  )
  ;; ask turtles [ set w random-normal ladvantage per ] <== deberia ir en el setup
  set p ( time-p * (random-normal advantage per));; interesante comparar ladvantage y advantage, el primero esta en el sentido de el aporte
  ;;Hay que  establecer si la personalidad cambia o fluctua en cada tick o si es una condición permanente del setup
  ;; puede ser conveniente definir en el setup per y que esta sea propia del individuo y afecte las variables. Esto es sicologico.
  ;; del individuo y que la empresa no se le quede corta.
  ;; set p  (time-p * (advantage + (time-r * impact-r ) ) )  ;; rewards associated with productive work and cooperation
  ;; puede ser muy alto el impacto del relacionarse con el SRI
  set awa awa + wa  ;;  toca colocarle el nivel del pago acumulado
  set aladvantage aladvantage + ladvantage
end

to evolve
  ;; set pw
  ;; set PW  ( IP anteriores, W anteriores, IP-cercanos, w-cercanos, IP-red w-red, puede ser tambien que se
  ;; rastree historicos de los demas
 ;; Despues con ifelse se coloca la comparación del w con el pw y se evoluciona si Pw > w
  ;; EN este caso el PI evoluciona a una tasa de crecimiento provista por las escuelas y el arsenal de la empresa.
  ;; es como la  fuerza que puede hacer que se pueda ir contra la corriente.
  ;; Esto es simplemente IP = IP * (1 + dip) ; Este ultimo esta en teminos de las escuelas del intrameprendimiento
  ;; y el arsenal en general
;; set DIP  (  TPB +  MT +  TSL ) / 3
set pw ladvantage
  if sensitized?
  [
    ask individualas [
    if (pw > w)  [
      set IPa  IPa + ( dipe / ( (number-a + number-b) * (number-a + number-b) ))
    ]
      ]
  ]
  if sensitized?
  [
    ask individualbs [
    if (pw > w) [
     set IPb  IPb + ( dipe / ( ( number-a + number-b) * (number-a + number-b)))
    ];; simboliza que entre más personas más puede cambiar la cultura o más ellos aportan y se benefician del cambio
      ];; Represents bounded rationality and behavioral adaptation within the simulation.
  ]

end

to recieve-new
end

to update
end

to evaluate
  ;; the "ladvantage" value of the guest turtle must be greater than the "advantage" of the patch.
  ;; se trabaja con if
  ;; if ladvantage < advantage
 ;; [
 ;;   uphill pcolor  ;; si es un proceso de las tortugas. Hay que entender por que se detiene en
    ;; la zona verde. Toca hacerlo con ifelse para que avance a lo verde cuando la ventajal sea
    ;; mayor a la del patche. Se establice cuando seaan iguales y se dirija a la zona blanca
    ;; cuando sea menor a la del patche
;;  ]
end

;; update the histogram in the interface tab
to my-update-histogram
  histogram [ ladvantage ] of turtles
end

to my-update-plot-p
end

;;;;;;;;;;;;;
;;to-report;;
;;;;;;;;;;;;;

to-report report-who-x
  report list who ladvantage
end

to-report avg-ladvantage
  report mean [ ladvantage ] of turtles
end

to-report report-who-y
  report list who w
end

to-report avg-w
  report mean [ w ] of turtles
end

to-report report-who-z
  report list who pw
end

to-report avg-pw
  report mean [ pw ] of turtles
end

to-report report-who-a
  report list who awa
end

to-report avg-awa
  report mean [ awa ] of turtles
end

to-report report-who-b
  report list who aladvantage
end

to-report avg-aladvantage
  report mean [ aladvantage ] of turtles
end

to-report report-who-c
  report list who ladvantage0
end

to-report avg-ladvantage0
  report mean [ ladvantage0 ] of turtles
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
647
448
-1
-1
13.0
1
10
1
1
1
0
0
0
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
6
10
69
43
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
16
49
188
82
number-a
number-a
0
20
3.0
1
1
NIL
HORIZONTAL

SLIDER
27
88
199
121
number-b
number-b
0
5
1.0
1
1
NIL
HORIZONTAL

BUTTON
86
14
149
47
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
670
255
842
288
number
number
0
20000
12000.0
1
1
NIL
HORIZONTAL

SLIDER
668
179
840
212
rep
rep
0
400
224.0
1
1
NIL
HORIZONTAL

SLIDER
672
213
844
246
dif
dif
0
1
0.8
0.01
1
NIL
HORIZONTAL

PLOT
654
10
854
160
my-update-histogram
NIL
NIL
0.0
100.0
0.0
20.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "  histogram [ ladvantage ] of turtles\n"

SLIDER
25
204
197
237
discount
discount
0
10
1.5
0.1
1
NIL
HORIZONTAL

SLIDER
31
244
203
277
time-sf
time-sf
0
0.3
0.15
0.01
1
NIL
HORIZONTAL

SLIDER
26
291
198
324
recovery
recovery
0
10
8.0
0.1
1
NIL
HORIZONTAL

SLIDER
29
417
201
450
time-p
time-p
0
1
0.30000000000000004
0.05
1
NIL
HORIZONTAL

SLIDER
23
126
195
159
mean.
mean.
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
27
339
199
372
time-c
time-c
0
0.3
0.15
0.01
1
NIL
HORIZONTAL

SLIDER
28
382
200
415
Impact
Impact
-5
5
4.0
1
1
NIL
HORIZONTAL

SLIDER
28
459
200
492
time-d
time-d
0
0.3
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
32
503
204
536
impact-d
impact-d
0
0.5
0.15
0.05
1
NIL
HORIZONTAL

SLIDER
219
461
391
494
time-s
time-s
0
0.3
0.15
0.01
1
NIL
HORIZONTAL

SLIDER
221
508
393
541
impact-s
impact-s
-2
0
-0.5
0.1
1
NIL
HORIZONTAL

SLIDER
409
467
581
500
time-r
time-r
0
0.3
0.15
0.01
1
NIL
HORIZONTAL

SLIDER
418
512
590
545
impact-r
impact-r
0
10
8.0
0.1
1
NIL
HORIZONTAL

SLIDER
675
300
847
333
TPB
TPB
-0.05
0.05
0.5
0.005
1
NIL
HORIZONTAL

SLIDER
676
342
848
375
MT
MT
-0.05
0.05
0.0
0.005
1
NIL
HORIZONTAL

SLIDER
680
390
852
423
TSL
TSL
-0.05
0.05
0.0
0.005
1
NIL
HORIZONTAL

SLIDER
678
520
850
553
IPa
IPa
0
1
0.6
0.01
1
NIL
HORIZONTAL

SLIDER
678
561
850
594
IPb
IPb
0
1
0.6
0.01
1
NIL
HORIZONTAL

SLIDER
27
167
199
200
SD
SD
0
10
4.0
1
1
NIL
HORIZONTAL

SLIDER
485
559
657
592
%a
%a
0
100
54.0
1
1
NIL
HORIZONTAL

SLIDER
679
486
851
519
per
per
0
0.002
0.001
0.001
1
NIL
HORIZONTAL

SLIDER
686
604
858
637
iIPa
iIPa
0
1
0.6
0.01
1
NIL
HORIZONTAL

SLIDER
498
612
670
645
iIPb
iIPb
0
1
0.6
0.01
1
NIL
HORIZONTAL

SLIDER
35
555
207
588
inn-culture
inn-culture
0.5
1.5
1.3
0.1
1
NIL
HORIZONTAL

SLIDER
685
440
857
473
accor
accor
0
0.002
0.001
0.001
1
NIL
HORIZONTAL

SLIDER
300
605
492
638
propagation-chance
propagation-chance
0
99
0.66
1
1
%
HORIZONTAL

SLIDER
310
560
482
593
radiu
radiu
0
3
3.0
1
1
NIL
HORIZONTAL

SLIDER
125
605
297
638
harmony-duration
harmony-duration
0
20
13.0
1
1
NIL
HORIZONTAL

SLIDER
305
655
477
688
chance-relapse
chance-relapse
0
99
0.33
1
1
%
HORIZONTAL

SLIDER
515
665
687
698
n-colonize
n-colonize
0
2
1.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person business
false
0
Rectangle -1 true false 120 90 180 180
Polygon -13345367 true false 135 90 150 105 135 180 150 195 165 180 150 105 165 90
Polygon -7500403 true true 120 90 105 90 60 195 90 210 116 154 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 183 153 210 210 240 195 195 90 180 90 150 165
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 76 172 91
Line -16777216 false 172 90 161 94
Line -16777216 false 128 90 139 94
Polygon -13345367 true false 195 225 195 300 270 270 270 195
Rectangle -13791810 true false 180 225 195 300
Polygon -14835848 true false 180 226 195 226 270 196 255 196
Polygon -13345367 true false 209 202 209 216 244 202 243 188
Line -16777216 false 180 90 150 165
Line -16777216 false 120 90 150 165

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="Incrementos de 0.1 y autogestion" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>[report-who-x] of turtles</metric>
    <metric>[avg-ladvantage] of turtles</metric>
    <metric>[report-who-y] of turtles</metric>
    <metric>[avg-w] of turtles</metric>
    <metric>[report-who-z] of turtles</metric>
    <metric>[avg-aw] of turtles</metric>
    <enumeratedValueSet variable="%a">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rep">
      <value value="223"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-c">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-d">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dif">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-d">
      <value value="0.25"/>
    </enumeratedValueSet>
    <steppedValueSet variable="time-sf" first="0" step="0.2" last="1"/>
    <enumeratedValueSet variable="IPa">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Impact">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-s">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="iIPa">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IPb">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-a">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="iIPb">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TSL">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-b">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-p">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-r">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MT">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-s">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pw">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean.">
      <value value="100"/>
    </enumeratedValueSet>
    <steppedValueSet variable="recovery" first="0" step="2" last="10"/>
    <enumeratedValueSet variable="impact-r">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="per">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SD">
      <value value="1"/>
    </enumeratedValueSet>
    <steppedValueSet variable="discount" first="0" step="0.4" last="2"/>
  </experiment>
  <experiment name="experiment" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>[report-who-x] of turtles</metric>
    <metric>[avg-ladvantage] of turtles</metric>
    <enumeratedValueSet variable="%a">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-c">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rep">
      <value value="223"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-d">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dif">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-d">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-sf">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IPa">
      <value value="1.566993600072056"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Impact">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-s">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="iIPa">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IPb">
      <value value="0.9275614013829755"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-a">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="iIPb">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TSL">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-b">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-p">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-r">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MT">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-s">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pw">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean.">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recovery">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-r">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="per">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SD">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0"/>
      <value value="1"/>
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Decisiones 4rep" repetitions="4" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>[report-who-x] of turtles</metric>
    <metric>[avg-ladvantage] of turtles</metric>
    <metric>[report-who-y] of turtles</metric>
    <metric>[avg-w] of turtles</metric>
    <metric>[report-who-z] of turtles</metric>
    <metric>[avg-aw] of turtles</metric>
    <enumeratedValueSet variable="%a">
      <value value="54"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-c">
      <value value="0.3"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rep">
      <value value="224"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-d">
      <value value="0.3"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dif">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-d">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-sf">
      <value value="0.3"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IPa">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Impact">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-s">
      <value value="-1.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="iIPa">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IPb">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-a">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="iIPb">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TSL">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-b">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-p">
      <value value="0.3"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-r">
      <value value="0.3"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MT">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-s">
      <value value="0.3"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pw">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean.">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recovery">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-r">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="per">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SD">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Decisiones tiempo-impacto 2 rep pfijo" repetitions="2" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>[report-who-x] of turtles</metric>
    <metric>[avg-ladvantage] of turtles</metric>
    <metric>[report-who-y] of turtles</metric>
    <metric>[avg-w] of turtles</metric>
    <metric>[report-who-z] of turtles</metric>
    <metric>[avg-aw] of turtles</metric>
    <enumeratedValueSet variable="%a">
      <value value="54"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-c">
      <value value="0.3"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rep">
      <value value="224"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-d">
      <value value="0.3"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dif">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-d">
      <value value="0.1"/>
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-sf">
      <value value="0.3"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IPa">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Impact">
      <value value="1"/>
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-s">
      <value value="-1.5"/>
      <value value="-0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="iIPa">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IPb">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-a">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="iIPb">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TSL">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-b">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-p">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-r">
      <value value="0.3"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MT">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-s">
      <value value="0.3"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pw">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean.">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recovery">
      <value value="3"/>
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-r">
      <value value="3"/>
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="per">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SD">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Con el ala de bienestar incorporado" repetitions="4" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>[report-who-x] of turtles</metric>
    <metric>[avg-ladvantage] of turtles</metric>
    <metric>[report-who-y] of turtles</metric>
    <metric>[avg-w] of turtles</metric>
    <metric>[report-who-z] of turtles</metric>
    <metric>[avg-pw] of turtles</metric>
    <enumeratedValueSet variable="%a">
      <value value="54"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rep">
      <value value="224"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-c">
      <value value="0.3"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-d">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dif">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-d">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-sf">
      <value value="0.3"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IPa">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Impact">
      <value value="1"/>
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-s">
      <value value="1.5"/>
      <value value="-0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="iIPa">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IPb">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-a">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="iIPb">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TSL">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-b">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-p">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-r">
      <value value="0.3"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MT">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-s">
      <value value="0.3"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean.">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recovery">
      <value value="3"/>
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-r">
      <value value="3"/>
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SD">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="per">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="inn-culture">
      <value value="0.8"/>
      <value value="1.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Experimento economico inicial" repetitions="2" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>[report-who-x] of turtles</metric>
    <metric>[avg-ladvantage] of turtles</metric>
    <metric>[report-who-y] of turtles</metric>
    <metric>[avg-w] of turtles</metric>
    <metric>[report-who-z] of turtles</metric>
    <metric>[avg-aw] of turtles</metric>
    <enumeratedValueSet variable="%a">
      <value value="54"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-c">
      <value value="0.05"/>
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rep">
      <value value="224"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-d">
      <value value="0.05"/>
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dif">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-d">
      <value value="0.1"/>
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-sf">
      <value value="0.05"/>
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IPa">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Impact">
      <value value="1"/>
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-s">
      <value value="-1.5"/>
      <value value="-0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="iIPa">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IPb">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-a">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="iIPb">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TSL">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-b">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-r">
      <value value="0.05"/>
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MT">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-s">
      <value value="0.05"/>
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean.">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recovery">
      <value value="3"/>
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-r">
      <value value="3"/>
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="per">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SD">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="inn-culture">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experimento total enfermedad 6 nov" repetitions="2" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>[report-who-x] of turtles</metric>
    <metric>[avg-ladvantage] of turtles</metric>
    <metric>[report-who-y] of turtles</metric>
    <metric>[avg-w] of turtles</metric>
    <metric>[report-who-z] of turtles</metric>
    <metric>[avg-pw] of turtles</metric>
    <metric>[report-who-a] of turtles</metric>
    <metric>[avg-awa] of turtles</metric>
    <metric>[report-who-b] of turtles</metric>
    <metric>[avg-aladvantage] of turtles</metric>
    <metric>[report-who-c] of turtles</metric>
    <metric>[avg-ladvantage0] of turtles</metric>
    <metric>count turtles with [ sensitized? ]</metric>
    <enumeratedValueSet variable="%a">
      <value value="54"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rep">
      <value value="224"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-c">
      <value value="0.05"/>
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-d">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dif">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="accor">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-sf">
      <value value="0.05"/>
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IPa">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Impact">
      <value value="1"/>
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-s">
      <value value="-1.5"/>
      <value value="-0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-d">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="iIPa">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IPb">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-a">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="iIPb">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TSL">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-b">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="12000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-r">
      <value value="0.05"/>
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MT">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-s">
      <value value="0.05"/>
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean.">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recovery">
      <value value="3"/>
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-r">
      <value value="3"/>
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="0"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="per">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SD">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0.5"/>
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="inn-culture">
      <value value="0.8"/>
      <value value="1.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="radiu">
      <value value="1"/>
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propagation-chance">
      <value value="0.33"/>
      <value value="0.66"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="harmony-duration">
      <value value="6"/>
      <value value="13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-relapse">
      <value value="0.33"/>
      <value value="0.66"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="n-colonize">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experimento total basico" repetitions="2" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>[report-who-x] of turtles</metric>
    <metric>[avg-ladvantage] of turtles</metric>
    <metric>[report-who-y] of turtles</metric>
    <metric>[avg-w] of turtles</metric>
    <metric>[report-who-z] of turtles</metric>
    <metric>[avg-pw] of turtles</metric>
    <metric>[report-who-a] of turtles</metric>
    <metric>[avg-awa] of turtles</metric>
    <metric>[report-who-b] of turtles</metric>
    <metric>[avg-aladvantage] of turtles</metric>
    <enumeratedValueSet variable="%a">
      <value value="54"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rep">
      <value value="224"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-c">
      <value value="0.05"/>
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-d">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dif">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="accor">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-sf">
      <value value="0.05"/>
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IPa">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Impact">
      <value value="1"/>
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-s">
      <value value="-1.5"/>
      <value value="-0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-d">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="iIPa">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IPb">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-a">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="iIPb">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TSL">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-b">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="12000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-r">
      <value value="0.05"/>
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MT">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-s">
      <value value="0.05"/>
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean.">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recovery">
      <value value="3"/>
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-r">
      <value value="3"/>
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="0"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="per">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SD">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0.5"/>
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="inn-culture">
      <value value="0.8"/>
      <value value="1.3"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experimento total basico nuevo" repetitions="2" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="80"/>
    <metric>[report-who-x] of turtles</metric>
    <metric>[avg-ladvantage] of turtles</metric>
    <metric>[report-who-y] of turtles</metric>
    <metric>[avg-w] of turtles</metric>
    <metric>[report-who-z] of turtles</metric>
    <metric>[avg-pw] of turtles</metric>
    <metric>[report-who-a] of turtles</metric>
    <metric>[avg-awa] of turtles</metric>
    <metric>[report-who-b] of turtles</metric>
    <metric>[avg-aladvantage] of turtles</metric>
    <runMetricsCondition>ticks mod 10 = 0</runMetricsCondition>
    <enumeratedValueSet variable="%a">
      <value value="54"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rep">
      <value value="224"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-c">
      <value value="0.05"/>
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-d">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dif">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="accor">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-sf">
      <value value="0.05"/>
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IPa">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Impact">
      <value value="1"/>
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-s">
      <value value="-1.5"/>
      <value value="-0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-d">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="iIPa">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IPb">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-a">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="iIPb">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TSL">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-b">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="12000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-r">
      <value value="0.05"/>
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MT">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-s">
      <value value="0.05"/>
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean.">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recovery">
      <value value="3"/>
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="impact-r">
      <value value="3"/>
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TPB">
      <value value="0"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="per">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SD">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="discount">
      <value value="0.5"/>
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="inn-culture">
      <value value="0.8"/>
      <value value="1.3"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
