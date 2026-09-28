# Proyecto-corto-I-Dise-o-digital-combinacional-mixto
Primer Proyecto de Diseño lógico de la creación de un transmisor y un receptor con el algoritmo de Hamming, para la corrección de una palabra transmitida con error (SEC), y la detección de una palabra con dos errores (DED).
# Proyecto corto I: Diseño digital combinacional mixto

## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays

## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

## 3. Desarrollo

### 3.0 Descripción general del sistema
El proyecto consiste en el diseño e implementación de un sistema digital de transmisión y recepción de datos capaz de detectar y corregir errores utilizando el código Hamming extendido, conocido como SECDED (Single Error Correction, Double Error Detection).

El objetivo principal del sistema es recibir una palabra de datos, generar una versión codificada que incluya los bits de paridad necesarios, simular la transmisión de esta palabra y posteriormente analizar la información recibida para determinar si se produjo algún error. En caso de existir un error de un solo bit, el sistema identifica su posición y realiza la corrección correspondiente. Además, el sistema permite visualizar el estado del proceso mediante los LEDs de la FPGA y representar información binaria en formato hexadecimal mediante un display de siete segmentos.

Para facilitar el diseño y la verificación, el sistema se dividió en diferentes bloques funcionales. Cada bloque realiza una tarea específica y posteriormente sus señales son conectadas mediante el módulo superior del proyecto.
De manera paralela, la información necesaria para la visualización es enviada al conversor de binario a hexadecimal y posteriormente al display de siete segmentos.

1) Codificador (palabra correcta)
Entrada: una palabra binaria de 4 bits, seleccionada mediante interruptores de 4 switch [datos_i[3];,datos_i[2]; datos_i[1]; datos_i[0];
Se calculan tres bits de paridad (I1,I2,I3) utilizando compuertas XOR, permitiendo que se calcule un bit de paridad global P
Se forma una palabra de 8 bits en formato: [D0, D1, D2, D3, I1, I2, I3, P] correspondiente al Hamming (7,4) codificado.  
En la salida se forma una palabra de 8 bits que corresponde al síndrome de la palabra codificada. En formato: [D0, D1, D2, D3, I1, I2, I3, P]

2) Receptor: (palabra codificada recibida)
Entrada: Palabra de 8 bits correspondiente a la palabra recibida con el mismo formato del Hamming codificado: [D0, D1, D2, D3, I1, I2, I3, P] del interruptor de 8 switch. Este módulo recalcula el síndrome de la palabra recibida utilizando las paridades ingresadas en la palabra. De modo que solo se recalcula la paridad global [P] de la palabra recibida. De modo que el único caso de error que excluye este código corresponde al error en bit global.
Salida: Corrección de la palabra transmitida y visualización en el display de binario a Hexadecimal 

3) Comparador:
Entrada: Síndrome de la palabra codificada y transmitida.
Procesamiento: 
Con compuertas XOR se comparan ambos síndromes de modo que se obtienen una coordenada en binario de la posición del error en la palabra recibida.
Casos:
Síndrome = 000 → no hay error detectado en los 7 bits principales, excluye bit global.
Si el síndrome ≠ 000 → indica la posición del bit con error.
Se revisa el bit de paridad global G0:
Si síndrome ≠ 000 y G0 falla → se corrige un error de 1 bit en la posición indicada.
Si síndrome = 000 y G0 falla → se detecta un error de 2 bits (DED) que no puede corregirse.
Salida: la posición de error que corresponde los bits comparados [eG, e2, e1, e0].

4) Corrector
Receptor: (palabra codificada recibida)
Entrada: Palabra de 8 bits correspondiente a la palabra recibida con el mismo formato del Hamming codificado: [D0, D1, D2, D3, I1, I2, I3, P] del interruptor de 8 switch.
procedimiento:
 Este módulo recalcula el síndrome de la palabra recibida utilizando las paridades ingresadas en la palabra. De modo que solo se recalcula la paridad global [P] de la palabra recibida. De modo que el único caso de error que excluye este código corresponde al error en bit global. Esta palabra hace que los bits del receptor sean corregidos utilizando el síndrome de Hamming para identificar la posición del bit erróneo y luego invertirlo mediante una operación XOR.
Salida: Corrección de la palabra transmitida y visualización en el display de binario a Hexadecimal.

5) Leds de la FPGA
Recibe la palabra corregida y enciende los leds de la FPGA invirtiendo los bits.

6) Conversor de Binario a Hexadecimal
Entradas: Palabra corregida de 8 bits
Procedimiento:
Realmente este modulo pasa de binario a otro número en binario que según ese orden enciende los siete LEDS del segmento en forma hexadecimal. 
Salida: Palabra corregida ilustrada en el display de siete segmentos.

### 3.1 Oscilador de anillo
Para el primer caso con 5 inversores:  Se armó un oscilador de anillo con 5 inversores del 74HC04 en cascada, El anillo más largo amortigua mejor la resonancia parásita del cableado porque su frecuencia fundamental que es aproximadamente de 9 MHz queda muy por debajo de la resonancia del montaje que ronda entre 90-150 MHz, permitiendo ver una forma de onda razonablemente limpia incluso a 5V siendo una gráfica que muestra que concuerda con la hoja de datos.
<img width="800" height="480" alt="5Inversores" src="https://github.com/user-attachments/assets/c45befae-ab1d-4d95-bf12-c7107c3b64d0" />

Para el segundo caso de 3 inversores: La frecuencia fundamental de un anillo tan corto (ósea de periodo rápido) caía demasiado cerca de la resonancia parásita, produciendo las senoides si se hacía con una tensión mayor, a diferencia del anterior de 5 inversores este caso se tuvo que hacer con una tensión de 2.7V, se supone que el mínimo no debe bajar de cero puesto que es simplemente una fuente CD lo que se usó, sin embargo esto se puede atribuir al ruido de los cables del osciloscopio que generan inductancias y capacitancias parásitas ya que los cables del laboratorio son muy largos y esto también propicia esta discrepancia.
<img width="800" height="480" alt="3Inverssores" src="https://github.com/user-attachments/assets/a421d9c5-e180-4eea-955f-c6a73be652d1" />

Caso de los 3 inversores con cable de 1 metro: Es como el anterior mostrando bastante concordancia con el cálculo teórico de los 3 inversores con la salvedad de que evidentemente al tener un cable de 1 metro entre una inversión su periodo será mayor.
<img width="800" height="480" alt="3Inversores_metro" src="https://github.com/user-attachments/assets/e4c3940c-3a6a-46b6-948b-e36b5d376963" />

Caso de inversor con capacitor: El inversor queda atrapado en su región lineal de alta ganancia, formando un oscilador tipo relajación por realimentación negativa con retardo, tal como dice el propio enunciado. Esta tensión es el punto de conmutación del inversor. La curva de transferencia de un inversor Vout en función de un Vin no es un escalón perfecto sino que tiene una zona de transición donde el inversor se comporta como un amplificador analógico de alta ganancia y no como un interruptor digital ideal.
<img width="800" height="480" alt="1Inversor" src="https://github.com/user-attachments/assets/21515e6e-555b-4ebd-ab27-278fbaef4ab5" />



### 3.2 Módulo 1
#### 1. Encabezado del módulo
##### Encabezado del modulo Lectura_Palabra:

module Lectura_Palabra (
    input  [3:0] datos_i, // 4 bits de entrada: [3]=D3, [2]=D2, [1]=D1, [0]=D0
    output [6:0] seg_o    // 7 segmentos: [0]=A, [1]=B, [2]=C, [3]=D, [4]=E, [5]=F, [6]=G
);


##### Encabezado del módulo Inyeccion_Error_Hamming:
module Inyeccion_Error_Hamming (

    input wire clk_i,   // reloj del Tang Nano 9K (ej. 27 MHz)

    input wire [3:0] datos_i,

    input wire I1_i,
    input wire I2_i,
    input wire I3_i,

    input wire [2:0] err1_pos_i,
    input wire [2:0] err2_pos_i,

    input wire error_P_i,

    output wire D0_o,
    output wire D1_o,
    output wire D2_o,
    output wire D3_o,

    output wire I1_o,
    output wire I2_o,
    output wire I3_o,

    output wire P_o
);

##### Encabezado del módulo parity_decoder:
module parity_decoder (
    input wire [7:0] palabra_recibida,

    output wire paridad_ok,
    output wire error_paridad
);


##### Encabezado del módulo syndrome_decoder:
module syndrome_decoder (
    input wire [6:0] hamming_recibido,

    output wire [2:0] syndrome
);


##### Encabezado del módulo error_correction:
module syndrome_decoder (
    input wire [6:0] hamming_recibido,

    output wire [2:0] syndrome
);
##### Encabezado del módulo display_decoder:
module display_decoder (
    input wire [6:0] palabra_corregida,
    input wire [2:0] syndrome,
    input wire ded,
    input wire switch_display,

    output wire [6:0] leds,
    output reg [6:0] segmentos
);


#### 2. Parámetros

El módulo no utiliza parámetros configurables, es decir, las dimensiones de las señales y la lógica del procesamiento están definidas en el código SystemVerilog de acuerdo con el sistema Hamming implementado.

#### 3. Entradas y salidas:
- `entrada_i`: La entrada es proporcionada por el usuario correspondiente a los cuatro bits de la palaba para el primer subsistema. Para el segundo subsistema se recibe de entrada la palabra de 8 bits la cual se le inyecta el error. Para el receptor, el primer subsistema recibe la palabra de 8 bits codificada con el error o sin el, luego recibe los 7 bits de hamming sin el bit de paridad global, el siguiente recibe los 7 bits con la corrección y finalmente el ultimo subsistema recibe la palabra de 4 bits para mostrarla en el display.
- `salida_o`: La salida del primer módulo de transmisión es la palabra hexadecimal de la palabra original de 4 bits que el usuario introdujo, para el segundo subsistema se envía la palabra de 8 bits al receptor (4 bits correspondientes a D0,D1,D2,D3, 3 bits de paridad P1,P2,P3 y un octavo bit de paridad global P). Para el primer subsistema del receptor da como salida los 7 bits sin la paridad global, después para el segundo subsistema la salida de este son los 7 bits pero con la posición del error, luego la salida para el tercer subsistema es la palabra ya corregida y puesta en el display 7 segmentos. 

#### 4. Criterios de diseño
Para el diseño del proyecto se priorizó la funcionalidad antes que la estética, sin embargo también está en duda, debido a los constantes problemas que se tuvieron para implementar las herramientas. Se priorizó completar el transmisor debido a que es la parte más complicada de hacer y luego se realizó el receptor.
#### 5. Testbench
Simulaciones para el decodificador 7 segmentos:
<img width="1196" height="289" alt="WhatsApp Image 2026-09-27 at 9 10 14 PM" src="https://github.com/user-attachments/assets/e3763ba7-9d35-4d72-bca1-3088160e7586" />
<img width="903" height="474" alt="WhatsApp Image 2026-09-27 at 9 11 09 PM" src="https://github.com/user-attachments/assets/b5ab35c0-1a10-4297-93ee-134e146564d6" />

Simulaciones para el Hamming:
<img width="1440" height="819" alt="WhatsApp Image 2026-09-28 at 12 28 04 AM" src="https://github.com/user-attachments/assets/907c745c-01ca-4c7b-b6fc-9dd2f5b31fdd" />
<img width="1600" height="811" alt="WhatsApp Image 2026-09-28 at 12 28 46 AM" src="https://github.com/user-attachments/assets/8f238951-09ed-49db-835e-b0ca069f575e" />
<img width="963" height="920" alt="WhatsApp Image 2026-09-28 at 12 28 33 AM" src="https://github.com/user-attachments/assets/bafbf411-5220-4dec-bd11-234625774ce5" />
<img width="960" height="897" alt="WhatsApp Image 2026-09-28 at 12 28 24 AM" src="https://github.com/user-attachments/assets/acf44eae-b76e-4816-9aa5-7470d78aaef9" />
<img width="958" height="918" alt="WhatsApp Image 2026-09-28 at 12 28 14 AM" src="https://github.com/user-attachments/assets/234d517e-5f72-495d-930a-eba36718c5ac" />

Simulaciones para la paridad DED:
<img width="1600" height="857" alt="WhatsApp Image 2026-09-28 at 1 00 23 AM" src="https://github.com/user-attachments/assets/680da941-68ab-4248-bbe8-50640eba3040" />
<img width="1130" height="811" alt="WhatsApp Image 2026-09-28 at 12 59 27 AM" src="https://github.com/user-attachments/assets/efceb339-ce59-4ad6-9fe6-ad3c9fe2bc35" />
<img width="1032" height="923" alt="WhatsApp Image 2026-09-28 at 12 59 08 AM" src="https://github.com/user-attachments/assets/04ff58db-4c96-4cff-b07e-a97564fa88ee" />
<img width="1028" height="893" alt="WhatsApp Image 2026-09-28 at 12 58 59 AM" src="https://github.com/user-attachments/assets/7c5d52c3-a0e7-4faf-a86d-fec0618f1a7d" />
<img width="1460" height="942" alt="WhatsApp Image 2026-09-28 at 12 58 46 AM" src="https://github.com/user-attachments/assets/b9148f9a-315b-4212-b311-26029b9f6c2d" />

Simulaciones para la inyección de uno,dos o ningún error:
<img width="1600" height="747" alt="WhatsApp Image 2026-09-28 at 1 28 41 AM (3)" src="https://github.com/user-attachments/assets/814d1533-cd3b-47f4-8129-0ae679bc6731" />
<img width="998" height="343" alt="WhatsApp Image 2026-09-28 at 1 28 41 AM (2)" src="https://github.com/user-attachments/assets/d1eab4d8-3710-4ad6-9845-bf1591293571" />
<img width="865" height="811" alt="WhatsApp Image 2026-09-28 at 1 28 41 AM (1)" src="https://github.com/user-attachments/assets/8f789239-72f4-414b-b653-0d29842e5fd6" />
<img width="1441" height="757" alt="WhatsApp Image 2026-09-28 at 1 28 41 AM" src="https://github.com/user-attachments/assets/86d68633-3b91-4638-a0e8-fa4e2985f57e" />

Simulación del topTransmisor:
<img width="1600" height="506" alt="WhatsApp Image 2026-09-28 at 4 18 41 AM (2)" src="https://github.com/user-attachments/assets/887f0750-77a5-4f09-ad71-dbc0a8f86b5e" />
<img width="880" height="503" alt="WhatsApp Image 2026-09-28 at 4 18 41 AM (1)" src="https://github.com/user-attachments/assets/26d2328b-579a-4b3b-9259-32cc4ea7f3c2" />
<img width="1022" height="739" alt="WhatsApp Image 2026-09-28 at 4 18 41 AM" src="https://github.com/user-attachments/assets/cdaf6582-06e9-4876-829b-f1f3d8468eb7" />

Simulación del Verificador de Paridad
<img width="1268" height="186" alt="Captura de pantalla 2026-09-28 170449" src="https://github.com/user-attachments/assets/6b0d665d-4920-42ae-b0fd-ddbf19c37d26" />
<img width="1044" height="803" alt="Captura de pantalla 2026-09-22 013314" src="https://github.com/user-attachments/assets/036a5002-4747-444f-bcdf-779f63a69b76" />

Simulación del determinador del síndrome
<img width="1632" height="184" alt="Captura de pantalla 2026-09-28 171139" src="https://github.com/user-attachments/assets/85031145-abc1-4638-8cc8-19f076b3b843" />
<img width="462" height="566" alt="Captura de pantalla 2026-09-28 170722" src="https://github.com/user-attachments/assets/81089f39-597d-4d1e-93f8-dda059db3cd1" />

Simulación de la Corrección de error
<img width="1612" height="248" alt="Captura de pantalla 2026-09-28 171727" src="https://github.com/user-attachments/assets/4befb826-e16a-433e-aa93-e7a04c3c821c" />
<img width="515" height="587" alt="Captura de pantalla 2026-09-28 171610" src="https://github.com/user-attachments/assets/1c1db32c-cef8-4bb7-909a-6eb5b71ff663" />

Simulación del display del Receptor
<img width="1481" height="314" alt="Captura de pantalla 2026-09-28 172306" src="https://github.com/user-attachments/assets/37e8ad4a-85f0-4d9a-a42c-562accb0a2e3" />
<img width="621" height="696" alt="Captura de pantalla 2026-09-28 172121" src="https://github.com/user-attachments/assets/513241f1-ea3f-49ae-a8a5-f8acc8c054db" />




## 4. Consumo de recursos
Number of wires:                 63
   Number of wire bits:            148
   Number of public wires:          63
   Number of public wire bits:     148
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:                 36
     GND                             1
     IBUF                           13
     LUT4                            7
     OBUF                           15
## 5. Problemas encontrados durante el proyecto
Literalmente todo. Desde la implementación de las herramientas hasta la realización del código nos hemos encontrado con demasiadas dificultades. La más importante es con la programación en Visual Studio ya que tuvimos demasiados problemas para implementar todas las herramientas necesarias, debido a que se necesitó ayuda extra del tutor para poder implementarlas. El armado del circuito fue otro problema bastante grande puesto que al tener muchos componentes si no se mantenía el orden era muy fácil perderse además de que los pines de la fgpa no son ordenados. Además esta misma presenta un fallo en el pin 35 que hace que no pueda recibir datos y nos dimos cuenta con ya pruebas avanzadas de este percanse.
## Apendices:
### Apendice 1:
Con esto se puede calcular el tiempo de propagación promedio del inversor TTL;
Para el caso de los 5 inversores:
T = 2·N·tPD
T = 10.55 ns y N=5:

tPD = T/ (2·5) = 1.055 ns

### Apendice 2 (Bitácoras):
BITACORA JORGE CHAVARRIA MATA
<img width="1080" height="1290" alt="bitacora1" src="https://github.com/user-attachments/assets/711ad037-9074-482b-852c-460b713fa12f" />
<img width="1332" height="1600" alt="WhatsApp Image 2026-09-22 at 1 58 21 AM" src="https://github.com/user-attachments/assets/62c3d7ae-0a5f-4de0-bb6d-7bdeadba52d2" />
<img width="1309" height="1600" alt="WhatsApp Image 2026-09-22 at 1 58 36 AM" src="https://github.com/user-attachments/assets/8eaf5f80-9cc5-4be6-8ade-17e04e8a0699" />
<img width="1060" height="1458" alt="WhatsApp Image 2026-09-22 at 1 58 55 AM" src="https://github.com/user-attachments/assets/3158d8d3-7af5-4ee6-82ab-307a2064edd5" />
<img width="905" height="1350" alt="WhatsApp Image 2026-09-22 at 1 59 16 AM" src="https://github.com/user-attachments/assets/5253244f-3a21-445b-a35f-47c44271d309" />


DEREK ROJAS CAMACHO
<img width="1190" height="1600" alt="WhatsApp Image 2026-09-22 at 6 54 03 AM" src="https://github.com/user-attachments/assets/4ca8141f-8568-41aa-9517-905fcc9293da" />
<img width="1152" height="1600" alt="WhatsApp Image 2026-09-22 at 6 53 59 AM" src="https://github.com/user-attachments/assets/076cc1eb-6654-40e1-b372-6052d692c42b" />
<img width="1224" height="1600" alt="WhatsApp Image 2026-09-22 at 6 540  AM" src="https://github.com/user-attachments/assets/d93b9725-1930-49bb-9059-d6f3a7725c8f" />
<img width="1264" height="1600" alt="WhatsApp Image 2026-09-22 at 6 54 06AM" src="https://github.com/user-attachments/assets/30e24d61-16e2-475c-aec4-c8e57773fe75" />
<img width="1234" height="1600" alt="WhatsApp Image 2026-09-22 at 6 54 04 AM" src="https://github.com/user-attachments/assets/cbe225b9-213f-46e6-9a86-05ebd4944921" />
<img width="1940" height="2516" alt="60bf0eb2-3922-4a3e-96c8-f2c259c2cf59" src="https://github.com/user-attachments/assets/d796f31d-3c0c-4fe7-91a9-599091ddf56d" />
<img width="2368" height="1532" alt="0e6421af-2392-4f02-bc33-7689ae6fda80" src="https://github.com/user-attachments/assets/965d9782-2e95-4307-898b-01a8311b4ee4" />
<img width="2364" height="2508" alt="1f28d4f0-6f71-4507-831d-8e451d3b464a" src="https://github.com/user-attachments/assets/0d181381-10d5-429b-852b-7af84df584f3" />
<img width="2064" height="2872" alt="1d83fb73-9429-4154-a9b7-b5f672b3c6be" src="https://github.com/user-attachments/assets/1b7d4fbf-26f5-4b5e-bdd0-b7c5cfb4ea69" />
<img width="1924" height="2496" alt="f98d2bd2-6d96-4247-b2bd-c04da49ba682" src="https://github.com/user-attachments/assets/6f370f45-48a5-4aa0-9700-0379a4cd1c2a" />
